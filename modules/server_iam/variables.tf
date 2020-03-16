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

#----------------#
# Forseti config #
#----------------#
variable "project_id" {
  description = "Google Project ID that you want Forseti deployed into"
}

#--------#
# Config #
#--------#
variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "folder_id" {
  description = "GCP Folder that the Forseti project will be deployed into"
  default     = ""
}

variable "cloud_profiler_enabled" {
  description = "Enable the Cloud Profiler"
  default     = false
  type        = bool
}

#-------#
# Flags #
#-------#
variable "enable_write" {
  description = "Enabling/Disabling write actions"
  type        = bool
  default     = false
}

variable "suffix" {
  description = "The random suffix to append to all Forseti resources"
}

#-------------------------#
# Forseti config notifier #
#-------------------------#
variable "cscc_violations_enabled" {
  description = "Notify for CSCC violations"
  type        = bool
  default     = false
}

variable "server_service_account" {
  description = "Service account email to assign to the Server VM. If empty, a new Service Account will be created"
  default     = ""
}
