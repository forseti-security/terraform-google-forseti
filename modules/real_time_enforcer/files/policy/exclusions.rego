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


package exclusions

#
# Function to test if a resource label is present that marks the resource for exclusion
# Exclusion labels should be defined in _data.config.exclusion.labels_ in your config.yaml file
#
# Example config:
#
# ---
# config:
#   exclusions:
#     labels:
#       forseti-enforcer: disable

label_exclude(res_labels) = true {
  res_labels[key] == data.config.exclusions.labels[key]
}
