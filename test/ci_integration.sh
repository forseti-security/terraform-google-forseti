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

# Always clean up.
DELETE_AT_EXIT="$(mktemp -d)"
finish() {
  local rv=$?
  echo 'BEGIN: finish() trap handler' >&2
  if [[ "${rv}" -ne 0 ]]; then
    echo 'BEGIN: .kitchen/logs/kitchen.log'
    cat .kitchen/logs/kitchen.log
    echo 'END: .kitchen/logs/kitchen.log'
    echo 'BEGIN: kitchen diagnose --all'
    kitchen diagnose --all
    echo 'END: kitchen diagnose --all'
  fi
  echo 'BEGIN: finish() trap handler' >&2
  set +e
  kitchen destroy "$SUITE"
  set -e
  [[ -d "${DELETE_AT_EXIT}" ]] && rm -rf "${DELETE_AT_EXIT}"
  echo 'END: finish() trap handler' >&2
  exit "${rv}"
}

# Map the input parameters provided by Concourse CI, or whatever mechanism is
# running the tests to Terraform input variables.  Also setup credentials for
# use with kitchen-terraform, inspec, and gcloud.
setup_environment() {
  local tmpfile
  tmpfile="$(mktemp)"
  echo "${SERVICE_ACCOUNT_JSON}" > "${tmpfile}"

  # gcloud variables
  export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="${tmpfile}"
  # Application default credentials (Terraform google provider and inspec-gcp)
  export GOOGLE_APPLICATION_CREDENTIALS="${tmpfile}"

  # Terraform variables
  export TF_VAR_project_id="${PROJECT_ID}"
  export TF_VAR_org_id="${ORG_ID}"
  export TF_VAR_domain="${DOMAIN}"
  export TF_VAR_gsuite_admin_email="${GSUITE_ADMIN_EMAIL}"
  export TF_VAR_credentials_path="${CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE}"

  # shared_vpc test suite
  export TF_VAR_network_project="${NETWORK_PROJECT}"
  export TF_VAR_network="${NETWORK}"
  export TF_VAR_subnetwork="${SUBNETWORK}"

  # real_time_enforcer test suite
  export TF_VAR_enforcer_project_id="${ENFORCER_PROJECT}"

  # real_time_enforcer_sinks test suite
  export TF_VAR_pubsub_project_id="${PROJECT_ID}"
  export TF_VAR_sink_project_id="${ENFORCER_PROJECT}"
}

main() {
  SUITE="${SUITE:-}"
  set -eu
  # Setup trap handler to auto-cleanup
  export TMPDIR="${DELETE_AT_EXIT}"
  trap finish EXIT

  # Setup environment variables
  setup_environment
  set -x

  # Execute the test lifecycle
  kitchen create "$SUITE"
  kitchen converge "$SUITE"
  kitchen verify "$SUITE"
}

# if script is being executed and not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
