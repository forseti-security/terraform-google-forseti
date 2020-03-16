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
Usage: ${0##*/} -p PROJECT_ID -o ORG_ID -s SERVICE_ACCOUNT_NAME [-f HOST_PROJECT_ID] [-e]
       ${0##*/} -h

Clean up resources created by the Forseti setup script.

Options:

    -p PROJECT_ID           The project ID where Forseti resources will be deleted.
    -o ORG_ID               The organization ID to remove roles from the Forseti service account.
    -s SERVICE_ACCOUNT_NAME The service account to remove from the project and organization IAM roles.
    -e                      Remove additional IAM roles for running the real time policy enforcer.
    -k                      Remove additional IAM roles for running Forseti on-GKE
    -q                      Remove additional IAM roles for using private IPs with Cloud SQL
    -g                      Remove additional IAM roles for using private IPs with the GCE VM's
    -f HOST_PROJECT_ID      ID of a project holding shared VPC.

Examples:

    ${0##*/} -p forseti-235k -o 22592784945 -s cloud-foundation-forseti-28047
    ${0##*/} -p forseti-enforcer-99e4 -o 22592784945 -s cloud-foundation-forseti-28047 -e

EOF
}

PROJECT_ID=""
ORG_ID=""
SERVICE_ACCOUNT_NAME=$FORSETI_SETUP_SERVICE_ACCOUNT_NAME
WITH_ENFORCER=""
HOST_PROJECT_ID=""
ON_GKE=""
SQL_PRIVATE_IP=""
GCE_PRIVATE_IP=""

OPTIND=1
while getopts ":hekqgf:p:o:s:" opt; do
  case "$opt" in
    h)
      show_help
      exit 0
      ;;
    e)
      WITH_ENFORCER=1
      ;;
    f)
      HOST_PROJECT_ID=$OPTARG
      ;;
    p)
      PROJECT_ID="$OPTARG"
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
    q)
      SQL_PRIVATE_IP=1
      ;;
    g)
      GCE_PRIVATE_IP=1
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

if [[ -z "$SERVICE_ACCOUNT_NAME" ]]; then
  echo "ERROR: SERVICE_ACCOUNT_NAME must be set."
  show_help >&2
  exit 1
fi

SERVICE_ACCOUNT_EMAIL="$SERVICE_ACCOUNT_NAME@${PROJECT_ID}.iam.gserviceaccount.com"
KEY_FILE="${PWD}/credentials.json"

# Ensure that we can fetch the IAM policy on the Forseti project.
if ! gcloud projects get-iam-policy "$PROJECT_ID" &> /dev/null; then
  echo "ERROR: Unable to fetch IAM policy on project $PROJECT_ID."
  exit 1
fi

# Ensure that we can fetch the IAM policy on the GCP organization.
if ! gcloud organizations get-iam-policy "$ORG_ID" &> /dev/null; then
  echo "ERROR: Unable to fetch IAM policy on organization $ORG_ID."
  exit 1
fi

# Ensure that we can query the service account.
if ! gcloud iam service-accounts describe "$SERVICE_ACCOUNT_EMAIL" &> /dev/null; then
  echo "ERROR: Unable to fetch service account $SERVICE_ACCOUNT_EMAIL."
  exit 1
fi

echo "Removing permissions from $SERVICE_ACCOUNT_EMAIL on organization $ORG_ID ..."

gcloud organizations remove-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/resourcemanager.organizationAdmin" \
    --user-output-enabled false

gcloud organizations remove-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.securityReviewer" \
    --user-output-enabled false

echo "Removing permissions from $SERVICE_ACCOUNT_EMAIL on project $PROJECT_ID ..."

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.instanceAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.networkViewer" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.securityAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/serviceusage.serviceUsageAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.serviceAccountAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/iam.serviceAccountUser" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/storage.admin" \
    --user-output-enabled false

if [[ -n "$SQL_PRIVATE_IP" ]]; then
  echo "Removing roles to allow Private IPs with Cloud SQL on project ${PROJECT_ID}..."
  gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.networkAdmin" \
    --user-output-enabled false
fi

if [[ -n "$GCE_PRIVATE_IP" ]]; then
  echo "Granting roles to allow Private IPs with GCE VM's on project ${PROJECT_ID}..."
  gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/compute.networkAdmin" \
    --user-output-enabled false
fi

if [[ -n "$WITH_ENFORCER" ]]; then
  org_roles=("roles/logging.configWriter" "roles/iam.organizationRoleAdmin")
  project_roles=("roles/pubsub.admin")

  echo "Revoking real time policy enforcer roles on organization $ORG_ID..."
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

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/cloudsql.admin" \
    --user-output-enabled false

if [[ -n "$ON_GKE" ]]; then
  gke_roles=("roles/container.admin" "roles/compute.networkAdmin" "roles/resourcemanager.projectIamAdmin")

  echo "Removing on-GKE related roles on project $PROJECT_ID..."
  for gke_role in "${gke_roles[@]}"; do
    gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="$gke_role" \
        --user-output-enabled false
  done
fi

if [[ $HOST_PROJECT_ID != "" ]];
then
    gcloud projects remove-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="roles/compute.securityAdmin" \
        --user-output-enabled false

    gcloud projects remove-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
        --role="roles/compute.networkAdmin" \
        --user-output-enabled false
fi

gcloud iam service-accounts delete "${SERVICE_ACCOUNT_EMAIL}" \
    --quiet
rm -rf "$KEY_FILE"

echo "All done."
