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

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

#----------------------------#
# Forseti real time enforcer #
#----------------------------#
variable "enforcer_type" {
  description = "Forseti real time enforcer instance type"
  default     = "n1-standard-2"
}

variable "client_region" {
  description = "Forseti real time enforcer region"
  default     = "us-central1"
}

variable "storage_bucket_location" {
  description = "GCS storage bucket location"
  default     = "us-central1"
}

variable "enforcer_boot_image" {
  description = "Forseti real time enforcer boot image"
  default     = "cos-cloud/cos-stable-72-11316-136-0"
}

variable "enforcer_region" {
  description = "GCE Forseti Client role region size"
  default     = "us-central1"
}

variable "network" {
  description = "The VPC where the Forseti real time enforcer will be created"
  default     = "default"
}

variable "subnetwork" {
  description = "The VPC subnetwork where the Forseti real time enforcer will be created"
  default     = "default"
}

variable "network_project" {
  description = "The project containing the VPC and subnetwork where the Forseti real time enforcer will be created"
  default     = ""
}

variable "enforcer_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti real time enforcer"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enforcer_instance_metadata" {
  description = "Metadata key/value pairs to make available from within the real time enforcer instance."
  type        = map(string)
  default     = {}
}

variable "enforcer_instance_access_config" {
  description = "Enforcer instance 'access_config' block"
  default     = {}
  type        = map(any)
}

variable "enforcer_instance_private" {
  description = "Enable enforcer instance private IP"
  default     = "false"
}

variable "suffix" {
  description = "The random suffix to append to all Forseti resources"
}

variable "enforcer_writer_role" {
  description = "An IAM role granting the enforcer service account the rights to enforce policy."
}

variable "enforcer_viewer_role" {
  description = "An IAM role granting the enforcer service account the rights to check for policy violations."
}

variable "topic" {
  description = "The pubsub topic receiving exported logs."
}

variable "manage_firewall_rules" {
  description = "Create enforcer firewall rules"
  type        = bool
  default     = true
}

