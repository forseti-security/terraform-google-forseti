#!/bin/bash
set -eu

# Env variables
USER=ubuntu
USER_HOME=/home/ubuntu

# forseti_conf_server digest: ${forseti_conf_server_checksum}
# This digest is included in the startup script to rebuild the Forseti server VM
# whenever the server configuration changes.

# Ubuntu update.
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get update -y
sudo apt-get --assume-yes install google-cloud-sdk git unzip

if ! [ -e "/usr/sbin/google-fluentd" ]; then
    cd $USER_HOME
    curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
    bash install-logging-agent.sh
fi

# Check whether Cloud SQL proxy is installed.
if [ -z "$(which cloud_sql_proxy)" ]; then
      cd $USER_HOME
      wget https://dl.google.com/cloudsql/cloud_sql_proxy.${cloudsql_proxy_arch}
      sudo mv cloud_sql_proxy.${cloudsql_proxy_arch} /usr/local/bin/cloud_sql_proxy
      chmod +x /usr/local/bin/cloud_sql_proxy
fi

# Install Forseti Security.
cd $USER_HOME
rm -rf *forseti*

# Download Forseti source code
git clone ${forseti_repo_url}
cd forseti-security
git fetch --all
git checkout ${forseti_version}

# Forseti host dependencies
sudo apt-get install -y $(cat install/dependencies/apt_packages.txt | grep -v "#" | xargs)

# Forseti dependencies
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
echo "Installing Forseti"
python3 setup.py install

# Export variables required by initialize_forseti_services.sh.
${forseti_env}

# Export variables required by run_forseti.sh
${forseti_environment}

# Store the variables in /etc/profile.d/forseti_environment.sh
# so all the users will have access to them
echo "${forseti_environment}" > /etc/profile.d/forseti_environment.sh | sudo sh

# Download server configuration from GCS
gsutil cp gs://${storage_bucket_name}/configs/forseti_conf_server.yaml ${forseti_server_conf_path}
gsutil cp -r gs://${storage_bucket_name}/rules ${forseti_home}/

# Download the Newest Config Validator constraints from GCS
rm -rf ${forseti_home}/policy-library

# Attempt to download the config-validator policy and gracefully handle the absence
# of policy files.  The config-validator is not required for the rest of Forseti
# and should not halt installation.
gsutil cp -r gs://${storage_bucket_name}/policy-library ${forseti_home}/ || echo "No policy available, continuing with Forseti installation"

# Start Forseti service depends on vars defined above.
bash ./install/gcp/scripts/initialize_forseti_services.sh
echo "Starting services."
systemctl start cloudsqlproxy
systemctl start config-validator
sleep 5

echo "Attempting to update database schema, if necessary."
python3 $USER_HOME/forseti-security/install/gcp/upgrade_tools/db_migrator.py

systemctl start forseti
echo "Success! The Forseti API server has been started."

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
echo "Added the run_forseti.sh to crontab under user $USER"
echo "Execution of startup script finished"
