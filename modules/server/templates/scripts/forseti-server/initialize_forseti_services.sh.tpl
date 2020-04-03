#!/bin/bash
# Copyright 2020 The Forseti Security Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset

# Reference all required bash variables prior to running. Due to 'nounset', if
# a caller fails to export the following expected environmental variables, this
# script will fail immediately rather than partially succeeding.
echo "Cloud SQL Instance Connection string: ${cloudsql_connection_name}"
echo "SQL port: ${cloudsql_db_port}"
echo "Forseti DB name: ${cloudsql_db_name}"

if ! [[ -f ${forseti_server_conf_path} ]]; then
    echo "Could not find the configuration file: ${forseti_server_conf_path}." >&2
    exit 1
fi

SQL_SERVER_LOCAL_ADDRESS="mysql+pymysql://${cloudsql_db_user}:${cloudsql_db_password}@127.0.0.1:${cloudsql_db_port}"
FORSETI_SERVICES="explain inventory model scanner notifier"

FORSETI_COMMAND="$(which forseti_server) --endpoint '[::]:50051'"
FORSETI_COMMAND+=" --forseti_db $SQL_SERVER_LOCAL_ADDRESS/${cloudsql_db_name}?charset=utf8"
FORSETI_COMMAND+=" --config_file_path ${forseti_server_conf_path}"
FORSETI_COMMAND+=" --services $FORSETI_SERVICES"

CONFIG_VALIDATOR_COMMAND="$(which docker) run --rm -p 50052:50052 --name config-validator"
CONFIG_VALIDATOR_COMMAND+=" --log-driver=gcplogs"
CONFIG_VALIDATOR_COMMAND+=" --log-opt gcp-log-cmd=true"
CONFIG_VALIDATOR_COMMAND+=" --log-opt labels=config-validator"
CONFIG_VALIDATOR_COMMAND+=" -v ${policy_library_home}:${policy_library_home}"
CONFIG_VALIDATOR_COMMAND+=" ${config_validator_image}:${config_validator_image_tag}"
CONFIG_VALIDATOR_COMMAND+=" --policyPath='${policy_library_home}/policy-library/policies'"
CONFIG_VALIDATOR_COMMAND+=" --policyLibraryPath='${policy_library_home}/policy-library/lib'"
CONFIG_VALIDATOR_COMMAND+=" -port=50052 -v 7 -alsologtostderr"

if [ "${policy_library_sync_enabled}" == "true" ]; then
  POLICY_LIBRARY_SYNC_COMMAND="$(which docker) run -d"
  POLICY_LIBRARY_SYNC_COMMAND+=" --log-driver=gcplogs"
  POLICY_LIBRARY_SYNC_COMMAND+=" --log-opt gcp-log-cmd=true"
  POLICY_LIBRARY_SYNC_COMMAND+=" --log-opt labels=git-sync"
  POLICY_LIBRARY_SYNC_COMMAND+=" -v ${policy_library_home}:/tmp/git"
  POLICY_LIBRARY_SYNC_COMMAND+=" -v /etc/git-secret:/etc/git-secret"
  POLICY_LIBRARY_SYNC_COMMAND+=" k8s.gcr.io/git-sync:${policy_library_sync_git_sync_tag}"
  POLICY_LIBRARY_SYNC_COMMAND+=" --branch=${policy_library_repository_branch}"
  POLICY_LIBRARY_SYNC_COMMAND+=" --dest=policy-library"
  POLICY_LIBRARY_SYNC_COMMAND+=" --max-sync-failures=-1"
  POLICY_LIBRARY_SYNC_COMMAND+=" --repo=${policy_library_repository_url}"
  POLICY_LIBRARY_SYNC_COMMAND+=" --wait=30"

  # If the SSH file is present, tell git-sync to use SSH to connect to the repo
  if [ -e "/etc/git-secret/ssh" ]; then
    POLICY_LIBRARY_SYNC_COMMAND+=" --ssh"
  fi

  # If the known_hosts file is NOT present, tell git-sync to not check known hosts
  if ! [ -e "/etc/git-secret/known_hosts" ]; then
    POLICY_LIBRARY_SYNC_COMMAND+=" --ssh-known-hosts=false"
  fi
fi

SQL_PROXY_COMMAND="$(which cloud_sql_proxy)"
SQL_PROXY_COMMAND+=" -instances=${cloudsql_connection_name}=tcp:${cloudsql_db_port}"

# Cannot use "read -d" since it returns a nonzero exit status.
API_SERVICE="$(cat << EOF
[Unit]
Description=Forseti API Server
Wants=cloudsqlproxy.service
[Service]
User=ubuntu
Restart=always
RestartSec=3
ExecStart=$FORSETI_COMMAND
Environment="POLICY_LIBRARY_HOME=${policy_library_home}"
[Install]
WantedBy=multi-user.target
EOF
)"
echo "$API_SERVICE" > /tmp/forseti.service
sudo mv /tmp/forseti.service /lib/systemd/system/forseti.service

# Config Validator Service.
CONFIG_VALIDATOR_SERVICE="$(cat << EOF
[Unit]
Description=Config Validator API Server
[Service]
TimeoutStartSec=15s
Environment="GOGC=1000"
ExecStart=$CONFIG_VALIDATOR_COMMAND
ExecStop=$(which docker) kill config-validator
[Install]
WantedBy=multi-user.target
EOF
)"
echo "$CONFIG_VALIDATOR_SERVICE" > /tmp/config_validator.service
sudo mv /tmp/config_validator.service /lib/systemd/system/config-validator.service

# By default, Systemd starts the executable stated in ExecStart= as root.
# See github issue #1761 for why this neds to be run as root.
SQL_PROXY_SERVICE="$(cat << EOF
[Unit]
Description=Cloud SQL Proxy
[Service]
Restart=always
RestartSec=3
ExecStart=$SQL_PROXY_COMMAND
[Install]
WantedBy=forseti.service
EOF
)"
echo "$SQL_PROXY_SERVICE" > /tmp/cloudsqlproxy.service
sudo mv /tmp/cloudsqlproxy.service /lib/systemd/system/cloudsqlproxy.service

# Policy Library Sync Service
if [ "${policy_library_sync_enabled}" == "true" ]; then
  POLICY_LIBRARY_SYNC_SERVICE="$(cat << EOF
[Unit]
Description=Policy Library Sync
[Service]
ExecStart=$POLICY_LIBRARY_SYNC_COMMAND
[Install]
WantedBy=multi-user.target
EOF
  )"
  echo "$POLICY_LIBRARY_SYNC_SERVICE" > /tmp/policy-library-sync.service
  sudo mv /tmp/policy-library-sync.service /lib/systemd/system/policy-library-sync.service
fi

# Define a foreground runner. This runner will start the CloudSQL
# proxy and block on the Forseti API server.
FOREGROUND_RUNNER="$(cat << EOF
$SQL_PROXY_COMMAND &&
$CONFIG_VALIDATOR_COMMAND &&
$FORSETI_COMMAND
EOF
)"
echo "$FOREGROUND_RUNNER" > /tmp/forseti-foreground.sh
chmod 755 /tmp/forseti-foreground.sh
sudo mv /tmp/forseti-foreground.sh /usr/bin/forseti-foreground.sh


echo "Forseti services are now registered with systemd. Services can be started"
echo "immediately by running the following:"
echo ""
echo "    systemctl start cloudsqlproxy"
echo "    systemctl start forseti"
echo "    systemctl start policy-library-sync"
echo "    systemctl start config-validator"
echo ""
echo "Additionally, the Forseti server can be run in the foreground by using"
echo "the foreground runner script: /usr/bin/forseti-foreground.sh"
