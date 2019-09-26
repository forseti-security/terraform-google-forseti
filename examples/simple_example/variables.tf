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

variable "credentials_path" {
  description = "Path to service account json"
  default     = "../../credentials.json"
}

variable "gsuite_admin_email" {
  description = "The email of a GSuite super admin, used for pulling user directory information *and* sending notifications."
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "region" {
  description = "Region where forseti subnetwork will be deployed"
  default     = "us-central1"
}

variable "network" {
  description = "Name of the shared VPC"
}

variable "subnetwork" {
  description = "Name of the subnetwork where forseti will be deployed"
}

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
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

variable "private" {
  description = "Private client and server instances (no public IPs)"
  default     = true
}

variable "sendgrid_api_key" {
  description = "Sendgrid API key."
  default     = ""
}

variable "forseti_email_sender" {
  description = "Forseti email sender."
  default     = ""
}

variable "forseti_email_recipient" {
  description = "Forseti email recipient."
  default     = ""
}
