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

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-p PROJECT_ID] [-f HOST_PROJECT] [-o ORG_ID]
Remove service account created by setup.sh script.

    -p PROJECT_ID         project id where service account will be created.
    -s SERVICE ACCOUNT    service account name.
    -f HOST_PROJECT       id of a project holding shared vpc.
    -o ORG_ID             organization id.
    -h                    this help.
Example: ./cleanup.sh -p test-project-1 -s cloud-foundation-forseti -o organization.com
EOF
}

# Initialize opt variables:
project_id=""
host_project=""
service_account_id=""
org=""

OPTIND=1
while getopts ":h:p:s:f:o:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        p)  project_id=$OPTARG
            ;;
        s)  service_account_id=$OPTARG
            ;;
        f)  host_project=$OPTARG
            ;;
        o)  org=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

if [[ $project_id == "" ]];
then
    echo "ERROR -p option is mandatory"
    exit 1
fi

if [[ $service_account_id == "" ]];
then
    echo "ERROR -s option is mandatory"
    exit 1
fi

PROJECT_ID="$(gcloud projects list --format="value(projectId)" --filter="${project_id}")"

if [[ $PROJECT_ID == "" ]];
then
    echo "ERROR The specified project wasn't found."
    exit 1;
fi

ORG_ID="$(gcloud projects describe "${PROJECT_ID}" --flatten=parent.id | grep -Eo "\d+")"
SERVICE_ACCOUNT_ID="$(gcloud iam service-accounts list --format="value(email)" --project="${PROJECT_ID}" | grep -Eo "${service_account_id}@${PROJECT_ID}.iam.gserviceaccount.com")"
KEY_FILE="${PWD}/credentials.json"

if [[ $SERVICE_ACCOUNT_ID == "" ]];
then
    echo "ERROR The specified service account wasn't found."
    exit 1;
fi

if [[ ${host_project} != "" ]];
then
    HOST_PROJECT_ID="$(gcloud projects list --format="value(projectId)" --filter="$host_project")"
    if [[ ${HOST_PROJECT_ID} == "" ]];
    then
        echo  "ERROR the specified host project wasn't found."
        exit 1
    fi
fi

echo "Removing permissions..."

gcloud organizations remove-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/resourcemanager.organizationAdmin" \
    --user-output-enabled false

gcloud organizations remove-iam-policy-binding "${ORG_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.securityReviewer" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.instanceAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.networkViewer" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/compute.securityAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.serviceAccountAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/serviceusage.serviceUsageAdmin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/iam.serviceAccountUser" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/storage.admin" \
    --user-output-enabled false

gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
    --role="roles/cloudsql.admin" \
    --user-output-enabled false

if [[ $HOST_PROJECT_ID != "" ]];
then
    gcloud projects remove-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
        --role="roles/compute.securityAdmin" \
        --user-output-enabled false

    gcloud projects remove-iam-policy-binding "${HOST_PROJECT_ID}" \
        --member="serviceAccount:${SERVICE_ACCOUNT_ID}" \
        --role="roles/compute.networkAdmin" \
        --user-output-enabled false
fi

gcloud iam service-accounts delete "${SERVICE_ACCOUNT_ID}" \
    --quiet
rm -rf "$KEY_FILE"

echo "All done."
