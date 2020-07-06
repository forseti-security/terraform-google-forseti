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

variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "v2.25.1"
}

variable "forseti_repo_url" {
  description = "Git repo for the Forseti installation"
  default     = "https://github.com/forseti-security/forseti-security"
}

variable "forseti_home" {
  description = "Forseti installation directory"
  default     = "$USER_HOME/forseti-security"
}

#----------------#
# Forseti client #
#----------------#
variable "client_enabled" {
  description = "Enable Client VM"
  default     = true
  type        = bool
}

variable "client_type" {
  description = "GCE Forseti Client machine type"
  default     = "n1-standard-2"
}

variable "client_boot_image" {
  description = "GCE Forseti Client boot image"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "client_shielded_instance_config" {
  description = "Client instance 'shielded_instance_config' block if using shielded VM image"
  type        = map(string)
  default     = null
}

variable "client_region" {
  description = "GCE Forseti Client region"
  default     = "us-central1"
}

variable "network" {
  description = "The VPC where the Forseti client and server will be created"
  default     = "default"
}

variable "subnetwork" {
  description = "The VPC subnetwork where the Forseti client and server will be created"
  default     = "default"
}

variable "network_project" {
  description = "The project containing the VPC and subnetwork where the Forseti client and server will be created"
}

variable "client_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "client_instance_metadata" {
  description = "Metadata key/value pairs to make available from within the client instance"
  type        = map(string)
  default     = {}
}

variable "client_tags" {
  description = "VM instance tags"
  type        = list(string)
  default     = []
}

variable "client_access_config" {
  description = "Client instance 'access_config' block"
  default     = {}
  type        = map(any)
}

variable "client_private" {
  description = "Enable private Forseti client VM (no public IP)"
  default     = "false"
}

variable "suffix" {
  description = "The random suffix to append to all Forseti resources"
}

variable "services" {
  description = "An artificial dependency to bypass #10462"
  type        = list(string)
  default     = []
}

variable "manage_firewall_rules" {
  description = "Create client firewall rules"
  default     = "true"
}

variable "google_cloud_sdk_version" {
  description = "Version of the Google Cloud SDK to install"
  default     = "289.0.0-0"
  type        = string
}

variable "firewall_logging" {
  description = "Enable firewall logging"
  type        = bool
  default     = false
}

variable "client_labels" {
  description = "Client instance labels"
  type        = map(string)
  default     = {}
}

#--------------------#
# Forseti client IAM #
#--------------------#
variable "client_iam_module" {
  description = "The Forseti Client IAM module"
}

#--------------------#
# Forseti client GCS #
#--------------------#
variable "client_gcs_module" {
  description = "The Forseti Client GCS module"
}

#-----------------------#
# Forseti client config #
#-----------------------#
variable "client_config_module" {
  description = "The Forseti Client config module"
}
