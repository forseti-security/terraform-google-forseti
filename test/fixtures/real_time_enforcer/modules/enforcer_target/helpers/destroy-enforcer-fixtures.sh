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

destroy_enforcer_fixtures() {
  local enforcer_target_dir
  enforcer_target_dir="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

  cd "$enforcer_target_dir" || exit 1

  # The real time enforcer will be modifying resources while Terraform is
  # tearing down test fixtures, so we may need to make multiple attempts to
  # get a successful destroy.
  echo "Tearing down test fixtures for real-time-enforcer"
  terraform init || exit 1

  for attempt in {1..3}; do
    echo "Destroying test fixtures, attempt $attempt of 3"
    if terraform apply -auto-approve -input=false -no-color; then
      echo "Terraform applied successfully."
      exit 0
    fi
  done

  echo "Terraform was not able to destroy after 3 attempts!"
  exit 1
}

main() {
  set -u
  destroy_enforcer_fixtures
}

# if script is being executed and not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
