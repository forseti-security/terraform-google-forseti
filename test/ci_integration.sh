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

set -e
set -x

if [ -z "${PROJECT_ID}" ]; then
	echo "The PROJECT_ID ENV variable must be set to proceed. Aborting."
	exit 1
fi

if [ -z "${ORG_ID}" ]; then
	echo "The ORG_ID ENV variable must be set to proceed. Aborting."
	exit 1
fi

if [ -z "${DOMAIN}" ]; then
	echo "The DOMAIN ENV variable must be set to proceed. Aborting."
	exit 1
fi

if [ -z "${GSUITE_ADMIN_EMAIL}" ]; then
	echo "The GSUITE_ADMIN_EMAIL ENV variable must be set to proceed. Aborting."
	exit 1
fi

set +x
if [ -z "${SERVICE_ACCOUNT_JSON}" ]; then
	echo "The SERVICE_ACCOUNT_JSON ENV variable must be set to proceed. Aborting."
	exit 1
fi
set -x

DELETE_AT_EXIT="$(mktemp -d)"
finish() {
	bundle exec kitchen destroy
	[[ -d "${DELETE_AT_EXIT}" ]] && rm -rf "${DELETE_AT_EXIT}"
}
trap finish EXIT
CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$(TMPDIR="${DELETE_AT_EXIT}" mktemp)"
set +x
echo "${SERVICE_ACCOUNT_JSON}" > "${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"
set -x
GOOGLE_APPLICATION_CREDENTIALS="${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"

export TF_VAR_project_id="${PROJECT_ID}"
export TF_VAR_org_id="${ORG_ID}"
export TF_VAR_domain="${DOMAIN}"
export TF_VAR_gsuite_admin_email="${GSUITE_ADMIN_EMAIL}"
export TF_VAR_credentials_path="${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"

declare -rx CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE GOOGLE_APPLICATION_CREDENTIALS

set -e
bundle install
bundle exec kitchen create
bundle exec kitchen converge
bundle exec kitchen verify
