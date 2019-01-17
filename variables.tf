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

variable "gsuite_admin_email" {
  description = "G-Suite administrator email address to manage your Forseti installation"
}

variable "forseti_version" {
  description = "Forseti software revision that you want "
  default     = "stable"
}

variable "forseti_repo_url" {
  description = "Git repo for the Forseti installation"
  default     = "https://github.com/GoogleCloudPlatform/forseti-security"
}

variable "forseti_email_recipient" {
  description = "Email address that receives Forseti notifications"
  default     = ""
}

variable "forseti_email_sender" {
  description = "Email address that sends the Forseti notifications"
  default     = ""
}

variable "forseti_home" {
  description = "Forseti installation directory"
  default     = "$USER_HOME/forseti-security"
}

variable "forseti_run_frequency" {
  description = "Schedule of running the Forseti scans"
  default     = "* */2 * * *"
}

#----------------#
# Forseti server #
#----------------#
variable "server_type" {
  description = "GCE Forseti Server role instance size"
  default     = "n1-standard-2"
}

variable "server_region" {
  description = "GCP region where Forseti will be deployed"
  default     = "us-central1"
}

variable "server_boot_image" {
  description = "GCE instance image that is being used, currently Debian only support is available"
  default     = "ubuntu-os-cloud/ubuntu-1804-lts"
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

#------------#
# Forseti db #
#------------#
variable "cloudsql_region" {
  description = "CloudSQL region"
  default     = "us-central1"
}

variable "cloudsql_db_name" {
  description = "CloudSQL database name"
  default     = "forseti_security"
}

variable "cloudsql_db_port" {
  description = "CloudSQL database port"
  default     = "3306"
}

variable "cloudsql_proxy_arch" {
  description = "CloudSQL Proxy architecture"
  default     = "linux.amd64"
}

variable "cloudsql_type" {
  description = "CloudSQL Instance size"
  default     = "db-n1-standard-1"
}

#----------------#
# Forseti bucket #
#----------------#
variable "storage_bucket_location" {
  description = "GCS storage bucket location"
  default     = "us-central1"
}

variable "bucket_cai_location" {
  description = "GCS CAI storage bucket location"
  default     = "us-central1"
}

variable "bucket_cai_lifecycle_age" {
  description = "GCS CAI lifecycle age value"
  default     = "14"
}

#---------#
# Network #
#---------#
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

#-------#
# Flags #
#-------#
variable "enable_write" {
  description = "Enabling/Disabling write actions"
  default     = "false"
}

variable "enable_cai_bucket" {
  description = "Create a GCS bucket for CAI exports"
  default     = "true"
}

#--------#
# Config #
#--------#
variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "folder_id" {
  description = "GCP Folder that the Forseti project will be deployed into"
  default     = ""
}

variable "sendgrid_api_key" {
  description = "Sendgrid.com API key to enable email notifications"
  default     = ""
}
