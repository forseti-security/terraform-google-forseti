/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#--------------------#
# Forseti server GCS #
#--------------------#

variable "server_gcs_module" {
  description = "The Forseti Server GCS module"
}

variable "manage_rules_enabled" {
  description = "A toggle to enable or disable the management of rules"
  type        = bool
  default     = true
}

variable "org_id" {
  description = "The organization ID"
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}
