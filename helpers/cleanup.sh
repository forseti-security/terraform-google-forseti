#!/bin/bash
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

show_help() {
  cat <<EOF
Usage: ${0##*/} PROJECT_ID ORG_ID SERVICE_ACCOUNT_NAME

Clean up resources created by the Forseti setup script.

Arguments:

    PROJECT_ID            The project ID where Forseti resources will be deleted.
    ORG_ID                The organization ID to remove roles from the Forseti service account.
    SERVICE_ACCOUNT_NAME  The service account to remove from the project and organization IAM roles.

Examples:

    ${0##*/} forseti-235k 22592784945 cloud-foundation-forseti-28047

EOF
}

PROJECT_ID="$1"
ORG_ID="$2"
SERVICE_ACCOUNT_NAME="$3"

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
if ! gcloud projects get-iam-policy "$PROJECT_ID" 2>&- 1>&-; then
  echo "ERROR: Unable to fetch IAM policy on project $PROJECT_ID."
  exit 1
fi

# Ensure that we can fetch the IAM policy on the GCP organization.
if ! gcloud organizations get-iam-policy "$ORG_ID" 2>&- 1>&-; then
  echo "ERROR: Unable to fetch IAM policy on organization $ORG_ID."
  exit 1
fi

# Ensure that we can query the service account.
if ! gcloud iam service-accounts describe "$SERVICE_ACCOUNT_EMAIL" 2>&- 1>&-; then
  echo "ERROR: Unable to fetch service account $SERVICE_ACCOUNT_EMAIL."
  exit 1
fi

echo "Removing permissions from $SERVICE_ACCOUNT_EMAIL on organization $ORG_ID ..."

gcloud organizations remove-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/resourcemanager.organizationAdmin" \
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

gcloud iam service-accounts delete "${SERVICE_ACCOUNT_EMAIL}" \
    --quiet

rm -rf "$KEY_FILE"

echo "All done."
