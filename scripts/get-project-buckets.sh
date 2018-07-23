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


set -x

# Get path to credentials
CREDENTIALS="$1"

# Export environment variable to ensure gsutil execution
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="$CREDENTIALS"

# Get the buckets list
BUCKETS_LIST=$(gsutil ls)
OUTPUT=" "

# Convert buckets list to array
IFS=$'\n' read -d ' ' -a BUCKETS_ARRAY <<< "$BUCKETS_LIST"

for BUCKET in "${BUCKETS_ARRAY[@]}"
do
  # Put each bucket in one line
  OUTPUT=$(printf "%s %s" "$BUCKET" "$OUTPUT")
done

jq -n --arg output "$OUTPUT" '{buckets_list:$output}'
