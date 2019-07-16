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

destroy_enforcer_fixtures() {
  local enforcer_target_dir
  enforcer_target_dir="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"

  cd "$enforcer_target_dir" || exit 1

  echo "Tearing down test fixtures for real-time-enforcer"
  terraform init
  terraform destroy -auto-approve -input=false -no-color
}

main() {
  set -eu
  destroy_enforcer_fixtures
}

# if script is being executed and not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
