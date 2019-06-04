#!/bin/bash
set -eu

# Env variables
USER=ubuntu
USER_HOME=/home/ubuntu

# Ubuntu update.
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get update -y
sudo apt-get --assume-yes install google-cloud-sdk git unzip

# Install fluentd if necessary.
if [ -e "/usr/sbin/google-fluentd" ]; then
    cd $USER_HOME
    curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh
    bash install-logging-agent.sh
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

# Install Forseti
echo "Installing Forseti"
python3 setup.py install

# Set ownership of the forseti project to $USER
chown -R $USER ${forseti_home}

# Store the variables in /etc/profile.d/forseti_environment.sh
# so all the users will have access to them
echo "${forseti_environment}" > /etc/profile.d/forseti_environment.sh | sudo sh

# Download client configuration from GCS
gsutil cp gs://${storage_bucket_name}/configs/forseti_conf_client.yaml ${forseti_client_conf_path}
gsutil cp -r gs://${storage_bucket_name}/rules ${forseti_home}/
