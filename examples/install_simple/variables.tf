/**
 * Copyright 2020 Google LLC
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

variable "config_validator_enabled" {
  description = "Config Validator scanner enabled."
  type        = bool
  default     = false
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "forseti_email_recipient" {
  description = "Forseti email recipient."
  default     = ""
}

variable "forseti_email_sender" {
  description = "Forseti email sender."
  default     = ""
}

variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "v2.25.1"
}

variable "gsuite_admin_email" {
  description = "The email of a GSuite super admin, used for pulling user directory information *and* sending notifications."
}

variable "instance_metadata" {
  description = "Metadata key/value pairs to make available from within the client and server instances."
  type        = map(string)
  default     = {}
}

variable "instance_tags" {
  description = "Tags to assign the client and server instances."
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The VPC where the Forseti client and server will be created"
}

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "private" {
  description = "Private client and server instances (no public IPs)"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "region" {
  description = "The region where the Forseti GCE Instance VMs and CloudSQL Instances will be deployed"
}

variable "sendgrid_api_key" {
  description = "Sendgrid API key."
  default     = ""
}

variable "subnetwork" {
  description = "The VPC subnetwork where the Forseti client and server will be created"
}
