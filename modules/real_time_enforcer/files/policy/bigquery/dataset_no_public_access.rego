# Copyright 2019 The micromanager Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


package gcp.bigquery.datasets.policy.no_public_access

#####
# Resource metadata
#####

labels = input.labels

#####
# Policy evaluation
#####

default valid = true

valid = false {
  # Check for bad acl
  input.access[_].iamMember == "allUsers"

  # Just in case labels are not in the input
  not labels
} else = false {
  # Check for bad acl
  input.access[_].iamMember == "allUsers"

  # Also, this must be false
  not data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Copy of the input, omitting the acls
remediate[key] = value {
 key != "access"
 input[key]=value
}

# Add the acls, as defined below
remediate[key] = value {
  key := "access"
  value := _access
}

# Return only valid acls using the function below
_access= [acl | acl := input.access[_]
  _valid_acl(acl)
]

_valid_acl(acl) = true {
  # If the iamMember is anything other than "allUsers"
  acl.iamMember != "allUsers"
}{
  # Or if there is no iamMember key
  not acl["iamMember"]
}
