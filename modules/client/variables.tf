/**
 * Copyright 2018 Google LLC
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
  default     = "v2.16.0"
}

variable "forseti_repo_url" {
  description = "Git repo for the Forseti installation"
  default     = "https://github.com/GoogleCloudPlatform/forseti-security"
}

variable "forseti_home" {
  description = "Forseti installation directory"
  default     = "$USER_HOME/forseti-security"
}

#----------------#
# Forseti client #
#----------------#
variable "client_type" {
  description = "GCE Forseti Client role instance size"
  default     = "n1-standard-2"
}

variable "client_boot_image" {
  description = "GCE Forseti Client role instance size"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "client_region" {
  description = "GCE Forseti Client role region size"
  default     = "us-central1"
}

variable "storage_bucket_location" {
  description = "GCS storage bucket location"
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

variable "server_address" {
  description = "The Forseti server address"
}

variable "client_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti server"
  type        = "list"
  default     = ["0.0.0.0/0"]
}

variable "client_instance_metadata" {
  description = "Metadata key/value pairs to make available from within the client instance"
  type        = "map"
  default     = {}
}

variable "client_tags" {
  description = "VM instance tags"
  type        = "list"
  default     = []
}

variable "client_access_config" {
  description = "Client instance 'access_config' block"
  type        = "map"
  default     = {}
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
  type        = "list"
  default     = []
}
