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
variable "project_id" {}

variable "gsuite_admin_email" {}

variable "forseti_version" {
  default = "master"
}

variable "forseti_repo_url" {
  default = "https://github.com/GoogleCloudPlatform/forseti-security"
}

variable "forseti_email_recipient" {
  default = ""
}

variable "forseti_email_sender" {
  default = ""
}

variable "forseti_home" {
  default = "$USER_HOME/forseti-security"
}

variable "forseti_run_frequency" {
  default = "* */2 * * *"
}

#----------------#
# Forseti server #
#----------------#
variable "server_type" {
  default = "n1-standard-2"
}

variable "server_region" {
  default = "us-central1"
}

variable "server_boot_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

#----------------#
# Forseti client #
#----------------#
variable "client_type" {
  default = "n1-standard-2"
}

variable "client_boot_image" {
  default = "ubuntu-os-cloud/ubuntu-1804-lts"
}

variable "client_region" {
  default = "us-central1"
}

#------------#
# Forseti db #
#------------#
variable "cloudsql_region" {
  default = "us-central1"
}

variable "cloudsql_db_name" {
  default = "forseti_security"
}

variable "cloudsql_db_port" {
  default = "3306"
}

variable "cloudsql_proxy_arch" {
  default = "linux.amd64"
}

variable "cloudsql_type" {
  default = "db-n1-standard-1"
}

#----------------#
# Forseti bucket #
#----------------#
variable "storage_bucket_location" {
  default = "us-central1"
}

variable "bucket_cai_location" {
  default = ""
}

#---------#
# Network #
#---------#
variable "vpc_host_network" {
  default = "default"
}

variable "vpc_host_subnetwork" {
  default = "default"
}

variable "vpc_host_project_id" {
  default = ""
}

#-------#
# Flags #
#-------#
variable "enable_write" {
  default = "false"
}

variable "enable_cai_bucket" {
  default = "false"
}

#--------#
# Config #
#--------#
variable "org_id" {
  default = ""
}

variable "folder_id" {
  default = ""
}

variable "sendgrid_api_key" {
  default = ""
}
