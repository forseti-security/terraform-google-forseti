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


PROJECT_ID="$(gcloud projects list --format="value(projectId)" --filter="$1")"

if [[ $PROJECT_ID == "" ]];
then
    echo "ERROR The specified project wasn't found."
    exit 1;
fi

ORG_ID="$(gcloud organizations list --format="value(ID)" --filter="$2")"

if [[ $ORG_ID == "" ]];
then
    echo "ERROR the specified organization id wasn't found."
    exit 1;
fi

SERVICE_ACCOUNT_NAME="cloud-foundation-forseti-${RANDOM}"
SERVICE_ACCOUNT_ID="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
STAGING_DIR="${PWD}"
KEY_FILE="${STAGING_DIR}/credentials.json"


gcloud iam service-accounts \
    --project ${PROJECT_ID} create ${SERVICE_ACCOUNT_NAME} \
    --display-name ${SERVICE_ACCOUNT_NAME}

echo "Downloading key to credentials.json..."

gcloud iam service-accounts keys create ${KEY_FILE} \
    --iam-account ${SERVICE_ACCOUNT_ID} \
    --user-output-enabled false

echo "Applying permissions for org $ORG_ID and project $PROJECT_ID..."

gcloud organizations add-iam-policy-binding ${ORG_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/resourcemanager.organizationAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.instanceAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.networkViewer" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.securityAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/deploymentmanager.editor" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.serviceAccountAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/serviceusage.serviceUsageAdmin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.serviceAccountUser" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/storage.admin" \
    --user-output-enabled false

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/cloudsql.admin" \
    --user-output-enabled false

echo "All done."
