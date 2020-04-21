#!/bin/bash
set -eu

# Env variables
USER=ubuntu
USER_HOME=/home/ubuntu
INTERNET_CONNECTION="$(ping -q -w1 -c1 google.com &>/dev/null && echo online || echo offline)"
INIT_SERVICES_MD5_HASH=${forseti_init_services_md5_hash}
RUN_FORSETI_SERVICES_MD5_HASH=${forseti_run_forseti_services_md5_hash}

export USER_HOME

# Log status of internet connection
if [ $INTERNET_CONNECTION == "offline" ]; then
  echo "Forseti Startup - A connection to the internet was not detected."
fi

# forseti_conf_server digest: ${forseti_conf_server_checksum}
# This digest is included in the startup script to rebuild the Forseti server VM
# whenever the server configuration changes.

function wait_on_lock_files() {
  lock_files=(
    "/var/lib/dpkg/lock"
    "/var/lib/apt/lists/lock"
    "/var/lib/dpkg/lock-frontend"
    "/var/cache/apt/archives/lock"
  )

  for lock_file in "$${lock_files[@]}"; do
    while sudo fuser $lock_file >/dev/null 2>&1; do
      echo "Forseti Startup - $lock_file - lock found, retry in 10 seconds."
      sleep 10
    done
  done
}

if [ ! "$(grep "apparmor=1" /etc/default/grub.d/50-cloudimg-settings.cfg)" ]; then
  echo "Forseti Startup - Ensure AppArmor is always enabled"
  sed -i.bak 's/\GRUB_CMDLINE_LINUX=.*\>/& apparmor=1 security=apparmor/' /etc/default/grub.d/50-cloudimg-settings.cfg
  sed -i.bak 's/\GRUB_CMDLINE_LINUX_DEFAULT=.*\>/& apparmor=1 security=apparmor/' /etc/default/grub.d/50-cloudimg-settings.cfg
  sudo update-grub
fi

# Ubuntu update.
echo "Forseti Startup - Upgrading Ubuntu packages."
sudo apt-get update -y
wait_on_lock_files
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# Install Ubuntu packages
echo "Forseti Startup - Installing Ubuntu packages."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates git gnupg unzip

# Install Google Cloud SDK
echo "Forseti Startup - Installing Google Cloud SDK."
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update -y && sudo apt-get install -y google-cloud-sdk=${google_cloud_sdk_version}

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

# Install Docker
if [ -z "$(which docker)" ]; then
  echo "Forseti Startup - Installing Docker for the Policy Library sync and Config Validator."
  sudo apt-get update
  sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
  sudo apt update
  apt-cache policy docker-ce
  sudo apt install -y docker-ce
fi

# Setup Forseti logging
touch /var/log/forseti.log
chown ubuntu:root /var/log/forseti.log
cp ${forseti_home}/configs/logging/fluentd/forseti.conf /etc/google-fluentd/config.d/forseti.conf
cp ${forseti_home}/configs/logging/logrotate/forseti /etc/logrotate.d/forseti
chmod 644 /etc/logrotate.d/forseti
service google-fluentd restart
logrotate /etc/logrotate.conf

# Change the access level of configs/ and rules/
chmod -R ug+rw ${forseti_home}/configs ${forseti_home}/rules

# Install Forseti
echo "Forseti Startup - Installing Forseti python package."
python3 setup.py install

# Export variables required by initialize_forseti_services.sh
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
echo "Number of rules enabled: `ls ${forseti_home}/rules/*.yaml &>/dev/null | wc -l`"

# Get Config Validator constraints
sudo mkdir -m 777 -p ${policy_library_home}
if [ "${policy_library_sync_enabled}" == "true" ]; then
  # Policy Library Sync
  echo "Forseti Startup - Policy Library sync is enabled."

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

# Attempt to download the initialize_forseti_services.sh script and run_forseti.sh script
sudo mkdir -m 777 -p ${forseti_scripts}
gsutil -m cp -r gs://${storage_bucket_name}/scripts/initialize_forseti_services.sh ${forseti_scripts}
gsutil -m cp -r gs://${storage_bucket_name}/scripts/run_forseti.sh ${forseti_scripts}

# Enable cloud-profiler in the initialize_forseti_services.sh script
if ${cloud_profiler_enabled}; then
  pip3 install google-cloud-profiler
  sed "/FORSETI_COMMAND+=\" --services/a FORSETI_COMMAND+=\" --enable_profiler\"" -i ${forseti_scripts}/initialize_forseti_services.sh
fi

# Install mailjet_rest library
if ${mailjet_enabled}; then
  echo "Forseti Startup - mailjet_rest library is enabled."
  pip3 install mailjet_rest
fi

# Start Forseti service depends on vars defined above.
echo "Forseti Startup - Starting services."
bash ${forseti_scripts}/initialize_forseti_services.sh
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

echo "Forseti Startup - Allow 'ubuntu' user to use crontab"
echo -e "root\n$USER" > /etc/cron.allow

# Use flock to prevent rerun of the same cron job when the previous job is still running.
# If the lock file does not exist under the tmp directory, it will create the file and put a lock on top of the file.
# When the previous cron job is not finished and the new one is trying to run, it will attempt to acquire the lock
# to the lock file and fail because the file is already locked by the previous process.
# The -n flag in flock will fail the process right away when the process is not able to acquire the lock so we won't
# queue up the jobs.
# If the cron job failed the acquire lock on the process, it will log a warning message to syslog.
chmod +x ${forseti_scripts}/run_forseti.sh
(echo "${forseti_run_frequency} (/usr/bin/flock -n ${forseti_home}/forseti_cron_runner.lock ${forseti_scripts}/run_forseti.sh || echo '[forseti-security] Warning: New Forseti cron job will not be started, because previous Forseti job is still running.') 2>&1 | logger") | crontab -u $USER -
echo "Forseti Startup - Added the run_forseti.sh to crontab under user $USER."
echo "Forseti Startup - Execution of startup script finished."
