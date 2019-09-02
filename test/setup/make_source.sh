#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "#!/usr/bin/env bash" > ../source.sh

project_id=$(terraform output project_id)
echo "export TF_VAR_project_id='$project_id'" >> ../source.sh
echo "export TF_VAR_pubsub_project_id='$project_id'" >> ../source.sh

network_project=$(terraform output network_project)
echo "export TF_VAR_network_project='$network_project'" >> ../source.sh

enforcer_project_id=$(terraform output enforcer_project_id)
echo "export TF_VAR_enforcer_project_id='$enforcer_project_id'" >> ../source.sh
echo "export TF_VAR_sink_project_id='$enforcer_project_id'" >> ../source.sh
network="forseti-network"
echo "export TF_VAR_network='$network'" >> ../source.sh
subnetwork="forseti-subnetwork"
echo "export TF_VAR_subnetwork='$subnetwork'" >> ../source.sh
domain="phoogle.net"
echo "export TF_VAR_domain='$domain'" >> ../source.sh
region="us-central1"
echo "export TF_VAR_region='$region'" >> ../source.sh

gsuite_admin_email=$(terraform output gsuite_admin_email)
echo "export TF_VAR_gsuite_admin_email='$gsuite_admin_email'" >> ../source.sh

sa_json=$(terraform output sa_key)
# shellcheck disable=SC2086
echo "export SERVICE_ACCOUNT_JSON='$(echo $sa_json | base64 --decode)'" >> ../source.sh
