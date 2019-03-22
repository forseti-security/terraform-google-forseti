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

# Block until the Forseti startup script has finished running.

echo "Waiting for up to 300 seconds for Forseti to be ready."

for _ in {1..300}; do
  if [[ -f /etc/profile.d/forseti_environment.sh ]]; then
    #shellcheck source=/dev/null
    source /etc/profile.d/forseti_environment.sh
    if command forseti inventory list 1>/dev/null 2>&1; then
      echo "Forseti is ready."
      exit 0
    fi
  fi

  sleep 1
done

echo "Forseti was not ready after 300 seconds!"
exit 1
