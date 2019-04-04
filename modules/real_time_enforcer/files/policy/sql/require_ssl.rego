# Copyright 2019 The resource-policy-evaluation library Authors. All rights reserved.
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


package gcp.sqladmin.instances.policy.require_ssl

#####
# Policy evaluation
#####

default valid=false

# Check if non-ssl connections are allowed
valid = true {
  input.settings.ipConfiguration.requireSsl == true
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(input.settings.userLabels)
}

#####
# Remediation
#####

remediate[key] = value {
 key != "settings"
 input[key]=value
}

remediate[key] = value {
 key := "settings"
 value := _settings
}

_settings[key]=value{
  key != "ipConfiguration"
  input.settings[key]=value
}

_settings[key]=value{
  key := "ipConfiguration"
  value := _ipConfiguration
}

_ipConfiguration[key]=value{
  key != "requireSsl"
  input.settings.ipConfiguration[key]=value
}

_ipConfiguration[key]=value{
  key := "requireSsl"
  value := true
}
