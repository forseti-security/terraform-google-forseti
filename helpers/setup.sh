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
Usage: ${0##*/} PROJECT_ID ORG_ID

Generate a service account with the IAM roles needed to run the Forseti Terraform module.

Arguments:

    PROJECT_ID    The project ID where Forseti resources will be created.
    ORG_ID        The organization ID that Forseti will be monitoring.

Examples:

    ${0##*/} forseti-235k 22592784945

EOF
}

PROJECT_ID="$1"
ORG_ID="$2"

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

SERVICE_ACCOUNT_NAME="cloud-foundation-forseti-${RANDOM}"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
STAGING_DIR="${PWD}"
KEY_FILE="${STAGING_DIR}/credentials.json"


gcloud iam service-accounts \
    --project "${PROJECT_ID}" create ${SERVICE_ACCOUNT_NAME} \
    --display-name "${SERVICE_ACCOUNT_NAME}"

echo "Downloading key to credentials.json..."

gcloud iam service-accounts keys create "${KEY_FILE}" \
    --iam-account "${SERVICE_ACCOUNT_EMAIL}" \
    --user-output-enabled false

echo "Applying permissions for org $ORG_ID and project $PROJECT_ID..."

gcloud organizations add-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/resourcemanager.organizationAdmin" \
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

echo "All done."
