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

variable "bigquery_enabled" {
  description = "Big Query scanner enabled."
  type        = bool
  default     = false
}

variable "cloudsql_acl_enabled" {
  description = "Cloud SQL scanner enabled."
  type        = bool
  default     = false
}

variable "config_validator_enabled" {
  description = "Config Validator scanner enabled."
  type        = bool
  default     = true
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "firewall_rule_enabled" {
  description = "Firewall rule scanner enabled."
  type        = bool
  default     = false
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

variable "iam_policy_enabled" {
  description = "IAM Policy scanner enabled."
  type        = bool
  default     = false
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

variable "kms_scanner_enabled" {
  description = "KMS scanner enabled."
  type        = bool
  default     = false
}

variable "network" {
  description = "The VPC where the Forseti client and server will be created"
}

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "policy_library_bundle" {
  description = "Policy Library bundle to use with Config Validator. For more info, visit: https://github.com/forseti-security/policy-library/blob/master/docs/index.md#policy-bundles"
  type        = string
  default     = "forseti-security"
}

variable "policy_library_repository_url" {
  description = "The git repository containing the policy-library."
  default     = "https://github.com/forseti-security/policy-library.git"
}

variable "policy_library_sync_gcs_enabled" {
  description = "Sync Config Validator policy library from GCS."
  type        = bool
  default     = false
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

variable "service_account_key_enabled" {
  description = "Service account key scanner enabled."
  type        = bool
  default     = false
}

variable "subnetwork" {
  description = "The VPC subnetwork where the Forseti client and server will be created"
}
