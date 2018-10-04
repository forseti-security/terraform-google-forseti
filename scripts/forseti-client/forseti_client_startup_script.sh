#!/bin/bash
exec > /tmp/deployment.log
exec 2>&1

# Ubuntu update.
sudo apt-get update -y
sudo apt-get upgrade -y

# Forseti setup.
sudo apt-get install -y git unzip

# Forseti dependencies
sudo apt-get install -y libffi-dev libssl-dev libmysqlclient-dev python-pip python-dev build-essential

USER=ubuntu
USER_HOME=/home/ubuntu

# Install fluentd if necessary.
FLUENTD=$(ls /usr/sbin/google-fluentd)
if [ -z "$FLUENTD" ]; then
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

# Forseti dependencies
pip install --upgrade pip==9.0.3
pip install -q --upgrade setuptools wheel

# Install tracing libraries
pip install .[tracing]

# Install Forseti
python setup.py install

# Set ownership of the forseti project to $USER
chown -R $USER ${forseti_home}

# Store the variables in /etc/profile.d/forseti_environment.sh
# so all the users will have access to them
echo ${forseti_environment} > /etc/profile.d/forseti_environment.sh | sudo sh
