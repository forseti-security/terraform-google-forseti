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


package gcp.sqladmin.instances.policy.backups

#####
# Resource metadata
#####

labels = input.settings.userLabels

#####
# Policy evaluation
#####

default valid=false

# Check if backups are enabled
valid = true {
  input.settings.backupConfiguration.enabled == true
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Copy the input object, omitting the settings key
remediate[key] = value {
 key != "settings"
 input[key]=value
}

# Add the settings key, as defined below
remediate[key] = value {
 key := "settings"
 value := _settings
}

# Copy the settings key, minus the backupConfiguration key
_settings[key]=value{
  key != "backupConfiguration"
  input.settings[key]=value
}

# Add the backupConfiguration key, as defined below
_settings[key]=value{
  key := "backupConfiguration"
  value := _backupConfiguration
}

# Copy the backupConfiguration, minus the enabled key
_backupConfiguration[key] = value {
  key != "enabled"
  input.settings.backupConfiguration[key] = value
}

# Add the enabled key
_backupConfiguration[key] = value {
  key := "enabled"
  value := true
}
