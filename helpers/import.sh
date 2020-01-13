#!/bin/bash
# Copyright 2019 Google LLC
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

show_help() {
  cat <<EOF
Usage:

    ${0##*/} -m MODULE_LOCAL_NAME -o ORG_ID -p PROJECT_ID -s RESOURCE_NAME_SUFFIX -z GCE_ZONE [-n NETWORK_PROJECT_ID]
    ${0##*/} -h

Import to Terraform a Forseti deployment created with the deprecated Python
Installer. This script must be executed in the same directory as the target
Terraform configuration.

Required parameters:

    -m MODULE_LOCAL_NAME    The local name given to the instance of the Forseti
                            module in the Terraform configuration.
    -o ORG_ID               The ID of the organization where Forseti is deployed.
    -p PROJECT_ID           The ID of the project where Forseti is deployed.
    -s RESOURCE_NAME_SUFFIX The suffix appended to the names of the Forseti
                            resources; likely a 7 digit number.
    -z GCE_ZONE             The GCE zone where the Forseti Client/Server VMs are deployed.

Optional parameters:

    -n NETWORK_PROJECT_ID   The ID of the project where the network is deployed.

Example of usage:

    ${0##*/} -m forseti -o 12345678901 -p forseti-235k -s a1b2c3d -n forseti-network-235k -z us-central1-c

Example of required Terraform configuration:

    module "forseti" {
      source = "terraform-google-modules/forseti/google"
      version = "~> 4.2"

      domain               = "example.com"
      project_id           = "forseti-235k"
      resource_name_suffix = "a1b2c3d"
      org_id               = "12345678901"
      client_region        = "us-central1"
      server_region        = "us-central1"

      network         = "forseti"
      network_project = "forseti-network-235k"
      subnetwork      = "forseti"

      client_instance_metadata = {
        enable-oslogin = "TRUE"
      }
      enable_write         = true
      manage_rules_enabled = false
    }

EOF
}

if [[ ! $* =~ ^\-.+ ]]
then
  show_help
  exit 0
fi
GCE_ZONE=""
MODULE_LOCAL_NAME=""
NETWORK_PROJECT_ID=""
ORG_ID=""
PROJECT_ID=""
RESOURCE_NAME_SUFFIX=""
while getopts ":hm:n:o:p:s:z:" opt; do
  case ${opt} in
    h )
      show_help
      exit 0
      ;;
    m )
      MODULE_LOCAL_NAME="$OPTARG"
      ;;
    n )
      NETWORK_PROJECT_ID="$OPTARG"
      ;;
    o )
      ORG_ID="$OPTARG"
      ;;
    p )
      PROJECT_ID="$OPTARG"
      ;;
    s )
      RESOURCE_NAME_SUFFIX="$OPTARG"
      ;;
    z )
      GCE_ZONE="$OPTARG"
      ;;
    \? )
      echo "Invalid option: -$OPTARG; run ${0##*/} -h for more information" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument; run ${0##*/} -h for more information" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [[ -z "$MODULE_LOCAL_NAME" ]]; then
  echo "Missing required parameter: MODULE_LOCAL_NAME; run ${0##*/} -h for more information" 1>&2
  exit 1
fi

if [[ -z "$PROJECT_ID" ]]; then
  echo "Missing required parameter: PROJECT_ID; run ${0##*/} -h for more information" 1>&2
  exit 1
fi

if [[ -z "$NETWORK_PROJECT_ID" ]]; then
  echo "Missing optional parameter: NETWORK_PROJECT_ID; assuming equal to PROJECT_ID"
  NETWORK_PROJECT_ID="$PROJECT_ID"
fi

if [[ -z "$ORG_ID" ]]; then
  echo "Missing required parameter: ORG_ID; run ${0##*/} -h for more information" 1>&2
  exit 1
fi

if [[ -z "$RESOURCE_NAME_SUFFIX" ]]; then
  echo "Missing required parameter: RESOURCE_NAME_SUFFIX; run ${0##*/} -h for more information" 1>&2
  exit 1
fi

if [[ -z "$GCE_ZONE" ]]; then
  echo "Missing required parameter: GCE_ZONE; run ${0##*/} -h for more information" 1>&2
  exit 1
fi

printf "\nStarting import of Forseti resources to Terraform\n\n"

terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[0]" "$PROJECT_ID/admin.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[1]" "$PROJECT_ID/appengine.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[2]" "$PROJECT_ID/bigquery.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[3]" "$PROJECT_ID/cloudbilling.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[4]" "$PROJECT_ID/cloudresourcemanager.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[5]" "$PROJECT_ID/sql-component.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[6]" "$PROJECT_ID/sqladmin.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[7]" "$PROJECT_ID/compute.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[8]" "$PROJECT_ID/iam.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[9]" "$PROJECT_ID/container.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[10]" "$PROJECT_ID/servicemanagement.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[11]" "$PROJECT_ID/serviceusage.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[12]" "$PROJECT_ID/logging.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[13]" "$PROJECT_ID/cloudasset.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[14]" "$PROJECT_ID/storage-api.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.google_project_service.main[15]" "$PROJECT_ID/groupssettings.googleapis.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_cscc[0]" "$ORG_ID roles/securitycenter.findingsEditor serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_write[0]" "$ORG_ID roles/compute.securityAdmin serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[0]" "$ORG_ID roles/appengine.appViewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[1]" "$ORG_ID roles/bigquery.metadataViewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[2]" "$ORG_ID roles/browser serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[3]" "$ORG_ID roles/cloudasset.viewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[4]" "$ORG_ID roles/cloudsql.viewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[5]" "$ORG_ID roles/compute.networkViewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[6]" "$ORG_ID roles/iam.securityReviewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[7]" "$ORG_ID roles/orgpolicy.policyViewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[8]" "$ORG_ID roles/servicemanagement.quotaViewer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_organization_iam_member.org_read[9]" "$ORG_ID roles/serviceusage.serviceUsageConsumer serviceAccount:forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.client.google_compute_instance.forseti-client" "$PROJECT_ID/$GCE_ZONE/forseti-client-vm-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.client.google_compute_firewall.forseti-client-deny-all" "$NETWORK_PROJECT_ID/forseti-client-deny-all-$RESOURCE_NAME_SUFFIX"
if ! terraform import "module.$MODULE_LOCAL_NAME.module.client.google_compute_firewall.forseti-client-ssh-external" "$NETWORK_PROJECT_ID/forseti-client-allow-ssh-external-$RESOURCE_NAME_SUFFIX"
then
  terraform import "module.$MODULE_LOCAL_NAME.module.client.google_compute_firewall.forseti-client-ssh-external" "$NETWORK_PROJECT_ID/forseti-client-ssh-external-$RESOURCE_NAME_SUFFIX"
fi
terraform import "module.$MODULE_LOCAL_NAME.module.client_iam.google_service_account.forseti_client" "$PROJECT_ID/forseti-client-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.client_gcs.google_storage_bucket.client_config" "$PROJECT_ID/forseti-client-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.server_iam.google_service_account.forseti_server" "$PROJECT_ID/forseti-server-gcp-$RESOURCE_NAME_SUFFIX@$PROJECT_ID.iam.gserviceaccount.com"
terraform import "module.$MODULE_LOCAL_NAME.module.server.google_compute_firewall.forseti-server-deny-all" "$NETWORK_PROJECT_ID/forseti-server-deny-all-$RESOURCE_NAME_SUFFIX"
if ! terraform import "module.$MODULE_LOCAL_NAME.module.server.google_compute_firewall.forseti-server-ssh-external" "$NETWORK_PROJECT_ID/forseti-server-allow-ssh-external-$RESOURCE_NAME_SUFFIX"
then
  terraform import "module.$MODULE_LOCAL_NAME.module.server.google_compute_firewall.forseti-server-ssh-external" "$NETWORK_PROJECT_ID/forseti-server-ssh-external-$RESOURCE_NAME_SUFFIX"
fi
terraform import "module.$MODULE_LOCAL_NAME.module.server.google_compute_firewall.forseti-server-allow-grpc" "$NETWORK_PROJECT_ID/forseti-server-allow-grpc-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.server_gcs.google_storage_bucket.server_config" "$PROJECT_ID/forseti-server-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.server_gcs.google_storage_bucket.cai_export" "$PROJECT_ID/forseti-cai-export-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.server.google_compute_instance.forseti-server" "$PROJECT_ID/$GCE_ZONE/forseti-server-vm-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.cloudsql.google_sql_database_instance.master" "$PROJECT_ID/forseti-server-db-$RESOURCE_NAME_SUFFIX"
terraform import "module.$MODULE_LOCAL_NAME.module.cloudsql.google_sql_database.forseti-db" "$PROJECT_ID/forseti-server-db-$RESOURCE_NAME_SUFFIX/forseti_security"
terraform import "module.$MODULE_LOCAL_NAME.module.cloudsql.google_sql_user.root" "$PROJECT_ID/forseti-server-db-$RESOURCE_NAME_SUFFIX/%/root"

printf "\n\nFinished import of Forseti resources to Terraform\n"
