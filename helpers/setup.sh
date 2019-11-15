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
Usage: ${0##*/} -p PROJECT_ID -o ORG_ID [-e] [-f HOST_PROJECT]
       ${0##*/} -h
Generate or updates a service account with the IAM roles needed to run the Forseti Terraform module.
Options:
    -p PROJECT_ID       The project ID where Forseti resources will be created.
    -o ORG_ID           The organization ID that Forseti will be monitoring.
    -e                  Add additional IAM roles for running the real time policy enforcer.
    -k                  Add additional IAM roles for running Forseti on-GKE
    -f HOST_PROJECT_ID  ID of a project holding shared vpc.
    -s SERVICE_ACCOUNT  Specify a service account to create (if already exists will be updated)
Examples:
    ${0##*/} -p forseti-235k -o 22592784945
    ${0##*/} -p forseti-enforcer-99e4 -o 22592784945 -e
EOF
}

PROJECT_ID=""
ORG_ID=""
WITH_ENFORCER=""
HOST_PROJECT_ID=""
ON_GKE=""
SERVICE_ACCOUNT_NAME="cloud-foundation-forseti-${RANDOM}"
IS_UPDATE=0

OPTIND=1
while getopts ":hekf:s:p:o:" opt; do
  case "$opt" in
    h)
      show_help
      exit 0
      ;;
    e)
      WITH_ENFORCER=1
      ;;
    p)
      PROJECT_ID="$OPTARG"
      ;;
    f)
      HOST_PROJECT_ID="$OPTARG"
      ;;
    o)
      ORG_ID="$OPTARG"
      ;;
    k)
      ON_GKE=1
      ;;
    s)
      SERVICE_ACCOUNT_NAME="$OPTARG"
      ;;
    *)
      echo "Unhandled option: -$opt" >&2
      show_help >&2
      exit 1
      ;;
  esac
done

if [[ -z "$PROJECT_ID" ]]; then
  echo "ERROR: PROJECT_ID must be set."
  show_help >&2
  exit 1
fi

if [[ -z "$ORG_ID" ]]; then
  echo "ERROR: ORG_ID must be set."
  show_help >&2
  exit 1
fi

# Ensure that we can fetch the IAM policy on the Forseti project.
if ! gcloud projects get-iam-policy "$PROJECT_ID" 2>&- 1>&-; then
  echo "ERROR: Unable to fetch IAM policy on project $PROJECT_ID."
  exit 1
fi

# Ensure that we can fetch the IAM policy on the GCP organization.
if ! gcloud organizations get-iam-policy "$ORG_ID" 2>&- 1>&-; then
  echo "ERROR: Unable to fetch IAM policy on organization $ORG_ID."
  exit 1
fi


SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
STAGING_DIR="${PWD}"
KEY_FILE="${STAGING_DIR}/credentials.json"
COMMAND_CHECK="gcloud iam service-accounts --project ${PROJECT_ID} list --filter=disabled:"


for email in $("${COMMAND_CHECK}""False")
do
    if [[ "$email" == "${SERVICE_ACCOUNT_EMAIL}" ]]; then
        echo "${SERVICE_ACCOUNT_EMAIL} already exists and is enabled"
        IS_UPDATE=1
        break
    fi;
done
if [[ "$IS_UPDATE" == "0" ]]; then

    for email in $("${COMMAND_CHECK}""True")
    do
        if [[ "$email" == "${SERVICE_ACCOUNT_EMAIL}" ]]; then
            echo "${SERVICE_ACCOUNT_EMAIL} already exists and is disabled"
            IS_UPDATE=2
            echo "The service account must be enabled manually or deleted"
            exit 1
            break
        fi;
    done
fi;


echo "Enabling services"
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    serviceusage.googleapis.com \
    --project "${PROJECT_ID}"



if [[ "$IS_UPDATE" == "0" ]]; then

    # If is an update i don't create service accout and re-download credentials
    echo "Creating a new service account ${SERVICE_ACCOUNT_EMAIL} ..."
    gcloud iam service-accounts \
        --project "${PROJECT_ID}" create "${SERVICE_ACCOUNT_NAME}" \
        --display-name "${SERVICE_ACCOUNT_NAME}"

    echo "Downloading key to credentials.json..."

    gcloud iam service-accounts keys create "${KEY_FILE}" \
        --iam-account "${SERVICE_ACCOUNT_EMAIL}" \
        --user-output-enabled false
fi

echo "Applying permissions for org $ORG_ID and project $PROJECT_ID..."

gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/resourcemanager.organizationAdmin" \
    --user-output-enabled false

gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.securityReviewer" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.instanceAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.networkViewer" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.securityAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.serviceAccountAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/serviceusage.serviceUsageAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.serviceAccountUser" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/storage.admin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/cloudsql.admin" \
    --user-output-enabled false

if [[ -n "$WITH_ENFORCER" ]]; then
  org_roles=("roles/logging.configWriter" "roles/iam.organizationRoleAdmin")
  project_roles=("roles/pubsub.admin")

  echo "Granting real time policy enforcer roles on organization $ORG_ID..."
  for org_role in "${org_roles[@]}"; do
    gcloud organizations add-iam-policy-binding "${ORG_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="$org_role" \
        --user-output-enabled false
  done

  echo "Granting real time policy enforcer roles on project $PROJECT_ID..."
  for project_role in "${project_roles[@]}"; do
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="$project_role" \
        --user-output-enabled false
  done
fi

if [[ -n "$ON_GKE" ]]; then
  gke_roles=("roles/container.admin" "roles/compute.networkAdmin" "roles/resourcemanager.projectIamAdmin")

  echo "Granting on-GKE related roles on project $PROJECT_ID..."
  for gke_role in "${gke_roles[@]}"; do
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="$gke_role" \
        --user-output-enabled false
  done
fi

if [[ $HOST_PROJECT_ID != "" ]];
then
    echo "Enabling services on host project"
    gcloud services enable \
        cloudresourcemanager.googleapis.com \
        compute.googleapis.com \
        serviceusage.googleapis.com \
        --project "${HOST_PROJECT_ID}"

    gcloud projects add-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="roles/compute.securityAdmin" \
        --user-output-enabled false

    gcloud projects add-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="roles/compute.networkAdmin" \
        --user-output-enabled false
fi

echo "All done."
