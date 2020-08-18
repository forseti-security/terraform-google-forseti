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

variable "forseti_run_frequency" {
  description = "Schedule of running the Forseti scans"
  type        = string
  default     = null
}

variable "forseti_scripts" {
  description = "The local Forseti scripts directory"
  default     = "$USER_HOME/forseti-scripts"
}

#----------------#
# Forseti server #
#----------------#
variable "config_validator_image" {
  description = "The image of the Config Validator to use"
  default     = "gcr.io/forseti-containers/config-validator"
}

variable "config_validator_image_tag" {
  description = "The tag of the Config Validator image to use"
  default     = "e018e7c"
}

variable "server_type" {
  description = "GCE Forseti Server machine type"
  default     = "n1-standard-8"
}

variable "server_region" {
  description = "GCE Forseti Server region"
  default     = "us-central1"
}

variable "server_boot_image" {
  description = "GCE Forseti Server boot image - Currently only Ubuntu is supported"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "server_shielded_instance_config" {
  description = "Server instance 'shielded_instance_config' block if using shielded VM image"
  type        = map(string)
  default     = null
}

variable "server_boot_disk_size" {
  description = "Size of the GCE instance boot disk in GBs."
  default     = "100"
}

variable "server_boot_disk_type" {
  description = "GCE instance boot disk type, can be pd-standard or pd-ssd."
  default     = "pd-ssd"
}

variable "server_instance_metadata" {
  description = "Metadata key/value pairs to make available from within the server instance."
  type        = map(string)
  default     = {}
}

variable "server_tags" {
  description = "VM instance tags"
  type        = list(string)
  default     = []
}

variable "server_access_config" {
  description = "Server instance 'access_config' block"
  default     = {}
  type        = map(any)
}

variable "server_private" {
  description = "Enable private Forseti server VM (no public IP)"
  default     = "false"
}

variable "cloud_profiler_enabled" {
  description = "Enable the Cloud Profiler"
  default     = false
  type        = bool
}

variable "mailjet_enabled" {
  description = "Enable mailjet_rest library"
  default     = false
  type        = bool
}

variable "google_cloud_sdk_version" {
  description = "Version of the Google Cloud SDK to install"
  default     = "289.0.0-0"
  type        = string
}

##---------#
## Network #
##---------#
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
  default     = ""
}

variable "server_grpc_allow_ranges" {
  description = "List of CIDRs that will be allowed gRPC access to forseti server"
  type        = list(string)
  default     = []
}

variable "server_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "manage_firewall_rules" {
  description = "Create server firewall rules"
  type        = bool
  default     = true
}

variable "firewall_logging" {
  description = "Enable firewall logging"
  type        = bool
  default     = false
}

variable "server_labels" {
  description = "Server instance labels"
  type        = map(string)
  default     = {}
}

#--------#
# Config #
#--------#
variable "suffix" {
  description = "The random suffix to append to all Forseti resources"
}

variable "services" {
  description = "An artificial dependency to bypass #10462"
  type        = list(string)
  default     = []
}

#------------------------#
# Forseti policy-library #
#------------------------#

variable "policy_library_home" {
  description = "The local policy library directory."
  default     = "$USER_HOME/policy-library"
}

variable "policy_library_repository_branch" {
  description = "The specific git branch containing the policies."
  default     = "master"
}

variable "policy_library_repository_url" {
  description = "The git repository containing the policy-library."
  default     = ""
}

variable "policy_library_sync_enabled" {
  description = "Sync config validator policy library from private repository."
  default     = "false"
}

variable "policy_library_sync_gcs_directory_name" {
  description = "The directory name of the GCS folder used for the policy library sync config."
  default     = "policy_library_sync"
}

variable "policy_library_sync_git_sync_tag" {
  description = "Tag for the git-sync image."
  default     = "v3.1.2"
}

variable "policy_library_sync_ssh_known_hosts" {
  description = "List of authorized public keys for SSH host of the policy library repository."
  default     = ""
}

#------------#
# Forseti db #
#------------#

variable "cloudsql_module" {
  description = "The CloudSQL module"
}

variable "cloudsql_proxy_arch" {
  description = "CloudSQL Proxy architecture"
  default     = "linux.amd64"
}

#--------------------#
# Forseti client IAM #
#--------------------#

variable "server_iam_module" {
  description = "The Forseti Server IAM module"
}

#--------------------#
# Forseti server GCS #
#--------------------#

variable "server_gcs_module" {
  description = "The Forseti Server GCS module"
}

#----------------------#
# Forseti server Rules #
#----------------------#

variable "server_rules_module" {
  description = "The Forseti Server rules module"
}

#-----------------------#
# Forseti server config #
#-----------------------#

variable "server_config_module" {
  description = "The Forseti Server config module"
}

#--------------------#
# Forseti client IAM #
#--------------------#

variable "client_iam_module" {
  description = "The Forseti Client IAM module"
}
