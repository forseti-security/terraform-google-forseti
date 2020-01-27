#!/bin/bash
set -eu

# Env variables
USER=ubuntu
USER_HOME=/home/ubuntu
INTERNET_CONNECTION="$(ping -q -w1 -c1 google.com &>/dev/null && echo online || echo offline)"

# Log status of internet connection
if [ $INTERNET_CONNECTION == "offline" ]; then
  echo "Forseti Startup - A connection to the internet was not detected."
fi

# forseti_conf_server digest: ${forseti_conf_server_checksum}
# This digest is included in the startup script to rebuild the Forseti server VM
# whenever the server configuration changes.

# Ubuntu update.
echo "Forseti Startup - Updating Ubuntu."
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get update -y
sudo apt-get --assume-yes install google-cloud-sdk git unzip

if ! [ -e "/usr/sbin/google-fluentd" ]; then
  echo "Forseti Startup - Installing GCP Logging agent."
  cd $USER_HOME
  curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
  bash install-logging-agent.sh
fi

# Check whether Cloud SQL proxy is installed.
if [ -z "$(which cloud_sql_proxy)" ]; then
  echo "Forseti Startup - Installing GCP Cloud SQL Proxy."
  cd $USER_HOME
  wget https://dl.google.com/cloudsql/cloud_sql_proxy.${cloudsql_proxy_arch}
  sudo mv cloud_sql_proxy.${cloudsql_proxy_arch} /usr/local/bin/cloud_sql_proxy
  chmod +x /usr/local/bin/cloud_sql_proxy
fi

# Install Forseti Security.
cd $USER_HOME
if [ $INTERNET_CONNECTION == "online" ]; then
  rm -rf *forseti*
fi

# Download Forseti source code
echo "Forseti Startup - Cloning Forseti repo."
git clone --branch ${forseti_version} --depth 1 ${forseti_repo_url}
cd forseti-security

# Forseti host dependencies
echo "Forseti Startup - Installing Forseti linux dependencies."
sudo apt-get install -y $(cat install/dependencies/apt_packages.txt | grep -v "#" | xargs)

# Forseti dependencies
echo "Forseti Startup - Installing Forseti python dependencies."
python3 -m pip install -q --upgrade setuptools wheel
python3 -m pip install -q --upgrade -r requirements.txt

# Setup Forseti logging
touch /var/log/forseti.log
chown ubuntu:root /var/log/forseti.log
cp ${forseti_home}/configs/logging/fluentd/forseti.conf /etc/google-fluentd/config.d/forseti.conf
cp ${forseti_home}/configs/logging/logrotate/forseti /etc/logrotate.d/forseti
chmod 644 /etc/logrotate.d/forseti
service google-fluentd restart
logrotate /etc/logrotate.conf

# Change the access level of configs/ rules/ and run_forseti.sh
chmod -R ug+rwx ${forseti_home}/configs ${forseti_home}/rules ${forseti_home}/install/gcp/scripts/run_forseti.sh


# Install Forseti
echo "Forseti Startup - Installing Forseti python package."
python3 setup.py install

# Export variables required by initialize_forseti_services.sh.
${forseti_env}

# Export variables required by run_forseti.sh
${forseti_environment}

# Store the variables in /etc/profile.d/forseti_environment.sh
# so all the users will have access to them
echo "${forseti_environment}" > /etc/profile.d/forseti_environment.sh | sudo sh

# Download server configuration from GCS
echo "Forseti Startup - Downloading Forseti configuration from GCS."
gsutil cp gs://${storage_bucket_name}/configs/forseti_conf_server.yaml ${forseti_server_conf_path}
gsutil cp -r gs://${storage_bucket_name}/rules ${forseti_home}/

# Get Config Validator constraints
sudo mkdir -m 777 -p ${policy_library_home}
if [ "${policy_library_sync_enabled}" == "true" ]; then
  # Policy Library Sync
  echo "Forseti Startup - Policy Library sync is enabled."

  # Install Docker
  if [ -z "$(which docker)" ]; then
    echo "Forseti Startup - Installing Docker for the Policy Library sync."
    sudo apt-get update
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt update
    apt-cache policy docker-ce
    sudo apt install -y docker-ce
  fi

  # Setup local FS
  # Note: gsutil is using the -n flag so that once the SSH key is copied locally, it is not overwritten for any subsequent runs of terraform
  sudo mkdir -p /etc/git-secret
  sudo gsutil cp -n gs://${storage_bucket_name}/${policy_library_sync_gcs_directory_name}/* /etc/git-secret/
else
  # Download the Newest Config Validator constraints from GCS
  echo "Forseti Startup - Copying Policy Library from GCS."
  sudo mkdir -m 777 -p ${policy_library_home}/policy-library
  gsutil -m rsync -d -r gs://${storage_bucket_name}/policy-library ${policy_library_home}/policy-library || echo "No policy available, continuing with Forseti installation"
fi

# Enable cloud-profiler in the initialize_forseti_services.sh script
if ${cloud_profiler_enabled}; then
  pip3 install google-cloud-profiler
  sed "/FORSETI_COMMAND+=\" --services/a FORSETI_COMMAND+=\" --enable_profiler\"" -i ./install/gcp/scripts/initialize_forseti_services.sh
fi

# Install mailjet_rest library
if ${mailjet_enabled}; then
  echo "Forseti Startup - mailjet_rest library is enabled."
  pip3 install mailjet_rest
fi

# Start Forseti service depends on vars defined above.
echo "Forseti Startup - Starting services."
bash ./install/gcp/scripts/initialize_forseti_services.sh
systemctl start cloudsqlproxy
if [ "${policy_library_sync_enabled}" == "true" ]; then
  systemctl start policy-library-sync
  sleep 5
fi
systemctl start config-validator
sleep 5

echo "Forseti Startup - Attempting to update database schema, if necessary."
python3 $USER_HOME/forseti-security/install/gcp/upgrade_tools/db_migrator.py

# Enable and start main Forseti service immediately
echo "Forseti Startup - Enabling and starting Forseti service."
systemctl enable --now forseti
echo "Forseti Startup - Success! The Forseti API server has been enabled and started."

# Increase Open File Limit
if grep -q "ubuntu soft nofile" /etc/security/limits.conf ; then
  echo "Ulimit soft nofile already set."
else
  echo "ubuntu soft nofile 32768" | sudo tee -a /etc/security/limits.conf
fi

if grep -q "ubuntu hard nofile" /etc/security/limits.conf ; then
  echo "Ulimit hard nofile already set."
else
  echo "ubuntu hard nofile 32768" | sudo tee -a /etc/security/limits.conf
fi

# Create a Forseti env script
FORSETI_ENV="$(cat << EOF
#!/bin/bash

export PATH=$PATH:/usr/local/bin

# Forseti environment variables
${forseti_environment}
EOF
)"
echo "$FORSETI_ENV" > $USER_HOME/forseti_env.sh

USER=ubuntu
# Use flock to prevent rerun of the same cron job when the previous job is still running.
# If the lock file does not exist under the tmp directory, it will create the file and put a lock on top of the file.
# When the previous cron job is not finished and the new one is trying to run, it will attempt to acquire the lock
# to the lock file and fail because the file is already locked by the previous process.
# The -n flag in flock will fail the process right away when the process is not able to acquire the lock so we won't
# queue up the jobs.
# If the cron job failed the acquire lock on the process, it will log a warning message to syslog.
(echo "${forseti_run_frequency} (/usr/bin/flock -n ${forseti_home}/forseti_cron_runner.lock ${forseti_home}/install/gcp/scripts/run_forseti.sh -b ${storage_bucket_name} || echo '[forseti-security] Warning: New Forseti cron job will not be started, because previous Forseti job is still running.') 2>&1 | logger") | crontab -u $USER -
echo "Forseti Startup - Added the run_forseti.sh to crontab under user $USER."
echo "Forseti Startup - Execution of startup script finished."
