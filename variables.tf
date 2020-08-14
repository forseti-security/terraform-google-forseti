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

variable "gsuite_admin_email" {
  description = "G-Suite administrator email address to manage your Forseti installation"
  default     = ""
}

variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "v2.25.1"
}

variable "forseti_repo_url" {
  description = "Git repo for the Forseti installation"
  default     = "https://github.com/forseti-security/forseti-security"
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
  type        = string
  default     = null
}

variable "forseti_scripts" {
  description = "The local Forseti scripts directory"
  default     = "$USER_HOME/forseti-scripts"
}

variable "resource_name_suffix" {
  default     = null
  description = "A suffix which will be appended to resource names."
  type        = string
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

variable "server_grpc_allow_ranges" {
  description = "List of CIDRs that will be allowed gRPC access to forseti server"
  type        = list(string)
  default     = ["10.128.0.0/9"]
}

variable "server_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "server_tags" {
  description = "GCE Forseti Server VM Tags"
  type        = list(string)
  default     = []
}

variable "server_access_config" {
  description = "Server instance 'access_config' block"
  default     = {}
  type        = map(any)
}

variable "server_private" {
  description = "Private GCE Forseti Server VM (no public IP)"
  default     = false
  type        = bool
}

variable "server_service_account" {
  description = "Service account email to assign to the Server VM. If empty, a new Service Account will be created"
  default     = ""
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

variable "server_labels" {
  description = "Server instance labels"
  type        = map(string)
  default     = {}
}

#---------------------------------#
# Forseti server config inventory #
#---------------------------------#
variable "admin_max_calls" {
  description = "Maximum calls that can be made to Admin API"
  default     = "14"
}

variable "admin_period" {
  description = "The period of max calls for the Admin API (in seconds)"
  default     = "1.0"
}

variable "admin_disable_polling" {
  description = "Whether to disable polling for Admin API"
  type        = bool
  default     = false
}

variable "appengine_max_calls" {
  description = "Maximum calls that can be made to App Engine API"
  default     = "18"
}

variable "appengine_period" {
  description = "The period of max calls for the App Engine API (in seconds)"
  default     = "1.0"
}

variable "appengine_disable_polling" {
  description = "Whether to disable polling for App Engine API"
  type        = bool
  default     = false
}

variable "bigquery_max_calls" {
  description = "Maximum calls that can be made to Big Query API"
  default     = "160"
}

variable "bigquery_period" {
  description = "The period of max calls for the Big Query API (in seconds)"
  default     = "1.0"
}

variable "bigquery_disable_polling" {
  description = "Whether to disable polling for Big Query API"
  type        = bool
  default     = false
}

variable "cloudasset_max_calls" {
  description = "Maximum calls that can be made to Cloud Asset API"
  default     = "1"
}

variable "cloudasset_period" {
  description = "The period of max calls for the Cloud Asset API (in seconds)"
  default     = "1.0"
}

variable "cloudasset_disable_polling" {
  description = "Whether to disable polling for Cloud Asset API"
  type        = bool
  default     = false
}

variable "cloudbilling_max_calls" {
  description = "Maximum calls that can be made to Cloud Billing API"
  default     = "5"
}

variable "cloudbilling_period" {
  description = "The period of max calls for the Cloud Billing API (in seconds)"
  default     = "1.2"
}

variable "cloudbilling_disable_polling" {
  description = "Whether to disable polling for Cloud Billing API"
  type        = bool
  default     = false
}

variable "compute_max_calls" {
  description = "Maximum calls that can be made to Compute API"
  default     = "18"
}

variable "compute_period" {
  description = "The period of max calls for the Compute API (in seconds)"
  default     = "1.0"
}

variable "compute_disable_polling" {
  description = "Whether to disable polling for Compute API"
  type        = bool
  default     = false
}

variable "container_max_calls" {
  description = "Maximum calls that can be made to Container API"
  default     = "9"
}

variable "container_period" {
  description = "The period of max calls for the Container API (in seconds)"
  default     = "1.0"
}

variable "container_disable_polling" {
  description = "Whether to disable polling for Container API"
  type        = bool
  default     = false
}

variable "crm_max_calls" {
  description = "Maximum calls that can be made to CRN API"
  default     = "4"
}

variable "crm_period" {
  description = "The period of max calls for the CRM  API (in seconds)"
  default     = "1.2"
}

variable "crm_disable_polling" {
  description = "Whether to disable polling for CRM API"
  type        = bool
  default     = false
}

variable "excluded_resources" {
  description = "A list of resources to exclude during the inventory phase."
  type        = list(string)
  default     = []
}

variable "iam_max_calls" {
  description = "Maximum calls that can be made to IAM API"
  default     = "90"
}

variable "iam_period" {
  description = "The period of max calls for the IAM API (in seconds)"
  default     = "1.0"
}

variable "iam_disable_polling" {
  description = "Whether to disable polling for IAM API"
  type        = bool
  default     = false
}

variable "logging_max_calls" {
  description = "Maximum calls that can be made to Logging API"
  default     = "9"
}

variable "logging_period" {
  description = "The period of max calls for the Logging API (in seconds)"
  default     = "1.0"
}

variable "logging_disable_polling" {
  description = "Whether to disable polling for Logging API"
  type        = bool
  default     = false
}

variable "securitycenter_max_calls" {
  description = "Maximum calls that can be made to Security Center API"
  default     = "14"
}

variable "securitycenter_period" {
  description = "The period of max calls for the Security Center API (in seconds)"
  default     = "1.0"
}

variable "servicemanagement_max_calls" {
  description = "Maximum calls that can be made to Service Management API"
  default     = "2"
}

variable "servicemanagement_period" {
  description = "The period of max calls for the Service Management API (in seconds)"
  default     = "1.1"
}

variable "servicemanagement_disable_polling" {
  description = "Whether to disable polling for Service Management API"
  type        = bool
  default     = false
}

variable "serviceusage_max_calls" {
  description = "Maximum calls that can be made to Service Usage API"
  default     = "4"
}

variable "serviceusage_period" {
  description = "The period of max calls for the Service Usage API (in seconds)"
  default     = "1.1"
}

variable "serviceusage_disable_polling" {
  description = "Whether to disable polling for Service Usage API"
  type        = bool
  default     = false
}

variable "sqladmin_max_calls" {
  description = "Maximum calls that can be made to SQL Admin API"
  default     = "1"
}

variable "sqladmin_period" {
  description = "The period of max calls for the SQL Admin API (in seconds)"
  default     = "1.1"
}

variable "sqladmin_disable_polling" {
  description = "Whether to disable polling for SQL Admin API"
  type        = bool
  default     = false
}

variable "storage_disable_polling" {
  description = "Whether to disable polling for Storage API"
  type        = bool
  default     = false
}

variable "cai_api_timeout" {
  description = "Timeout in seconds to wait for the exportAssets API to return success."
  default     = "3600"
}

variable "inventory_retention_days" {
  description = "Number of days to retain inventory data."
  default     = "-1"
}

#-------------------------------#
# Forseti server config scanner #
#-------------------------------#
variable "audit_logging_enabled" {
  description = "Audit Logging scanner enabled."
  type        = bool
  default     = false
}

variable "bigquery_enabled" {
  description = "Big Query scanner enabled."
  type        = bool
  default     = true
}

variable "blacklist_enabled" {
  description = "Blacklist scanner enabled."
  type        = bool
  default     = true
}

variable "bucket_acl_enabled" {
  description = "Bucket ACL scanner enabled."
  type        = bool
  default     = true
}

variable "cloudsql_acl_enabled" {
  description = "Cloud SQL scanner enabled."
  type        = bool
  default     = true
}

variable "config_validator_enabled" {
  description = "Config Validator scanner enabled."
  type        = bool
  default     = false
}

variable "enabled_apis_enabled" {
  description = "Enabled APIs scanner enabled."
  type        = bool
  default     = false
}

variable "firewall_rule_enabled" {
  description = "Firewall rule scanner enabled."
  type        = bool
  default     = true
}

variable "forwarding_rule_enabled" {
  description = "Forwarding rule scanner enabled."
  type        = bool
  default     = false
}

variable "group_enabled" {
  description = "Group scanner enabled."
  type        = bool
  default     = true
}

variable "iam_policy_enabled" {
  description = "IAM Policy scanner enabled."
  type        = bool
  default     = true
}

variable "iap_enabled" {
  description = "IAP scanner enabled."
  type        = bool
  default     = true
}

variable "instance_network_interface_enabled" {
  description = "Instance network interface scanner enabled."
  type        = bool
  default     = false
}

variable "ke_scanner_enabled" {
  description = "KE scanner enabled."
  type        = bool
  default     = false
}

variable "ke_version_scanner_enabled" {
  description = "KE version scanner enabled."
  type        = bool
  default     = true
}

variable "kms_scanner_enabled" {
  description = "KMS scanner enabled."
  type        = bool
  default     = true
}

variable "lien_enabled" {
  description = "Lien scanner enabled."
  type        = bool
  default     = true
}

variable "location_enabled" {
  description = "Location scanner enabled."
  type        = bool
  default     = true
}

variable "log_sink_enabled" {
  description = "Log sink scanner enabled."
  type        = bool
  default     = true
}

variable "manage_rules_enabled" {
  description = "A toggle to enable or disable the management of rules"
  type        = bool
  default     = true
}

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
  type        = bool
  default     = false
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

variable "resource_enabled" {
  description = "Resource scanner enabled."
  type        = bool
  default     = true
}

variable "retention_enabled" {
  description = "Retention scanner enabled."
  type        = bool
  default     = false
}

variable "role_enabled" {
  description = "Role scanner enabled."
  type        = bool
  default     = false
}

variable "service_account_key_enabled" {
  description = "Service account key scanner enabled."
  type        = bool
  default     = true
}

variable "rules_path" {
  description = "Path for Scanner Rules config files; if GCS, should be gs://bucket-name/path"
  type        = string
  default     = "/home/ubuntu/forseti-security/rules"
}

variable "verify_policy_library" {
  description = "Verify the Policy Library is setup correctly for the Config Validator scanner"
  type        = bool
  default     = true
}

#--------------------------------#
# Forseti server config notifier #
#--------------------------------#
variable "violations_slack_webhook" {
  description = "Slack webhook for any violation. Will apply to all scanner violation notifiers."
  default     = ""
}

variable "iam_policy_violations_should_notify" {
  description = "Notify for IAM Policy violations"
  type        = bool
  default     = true
}

variable "iam_policy_violations_slack_webhook" {
  description = "Slack webhook for IAM Policy violations"
  default     = ""
}

variable "audit_logging_violations_should_notify" {
  description = "Notify for Audit logging violations"
  type        = bool
  default     = true
}

variable "blacklist_violations_should_notify" {
  description = "Notify for Blacklist violations"
  type        = bool
  default     = true
}

variable "bigquery_acl_violations_should_notify" {
  description = "Notify for BigQuery ACL violations"
  type        = bool
  default     = true
}

variable "buckets_acl_violations_should_notify" {
  description = "Notify for Buckets ACL violations"
  type        = bool
  default     = true
}

variable "cloudsql_acl_violations_should_notify" {
  description = "Notify for CloudSQL ACL violations"
  type        = bool
  default     = true
}

variable "config_validator_violations_should_notify" {
  description = "Notify for Config Validator violations."
  type        = bool
  default     = true
}

variable "enabled_apis_violations_should_notify" {
  description = "Notify for enabled APIs violations"
  type        = bool
  default     = true
}

variable "firewall_rule_violations_should_notify" {
  description = "Notify for Firewall rule violations"
  type        = bool
  default     = true
}

variable "forwarding_rule_violations_should_notify" {
  description = "Notify for forwarding rule violations"
  type        = bool
  default     = true
}

variable "ke_version_violations_should_notify" {
  description = "Notify for KE version violations"
  type        = bool
  default     = true
}

variable "ke_violations_should_notify" {
  description = "Notify for KE violations"
  type        = bool
  default     = true
}

variable "kms_violations_should_notify" {
  description = "Notify for KMS violations"
  type        = bool
  default     = true
}

variable "kms_violations_slack_webhook" {
  description = "Slack webhook for KMS violations"
  default     = ""
}

variable "groups_violations_should_notify" {
  description = "Notify for Groups violations"
  type        = bool
  default     = true
}

variable "instance_network_interface_violations_should_notify" {
  description = "Notify for instance network interface violations"
  type        = bool
  default     = true
}

variable "iap_violations_should_notify" {
  description = "Notify for IAP violations"
  type        = bool
  default     = true
}

variable "lien_violations_should_notify" {
  description = "Notify for lien violations"
  type        = bool
  default     = true
}

variable "location_violations_should_notify" {
  description = "Notify for location violations"
  type        = bool
  default     = true
}

variable "log_sink_violations_should_notify" {
  description = "Notify for log sink violations"
  type        = bool
  default     = true
}

variable "resource_violations_should_notify" {
  description = "Notify for resource violations"
  type        = bool
  default     = true
}

variable "retention_violations_should_notify" {
  description = "Notify for retention violations"
  type        = bool
  default     = true
}

variable "retention_violations_slack_webhook" {
  description = "Slack webhook for retention violations"
  default     = ""
}

variable "role_violations_should_notify" {
  description = "Notify for role violations"
  type        = bool
  default     = true
}

variable "role_violations_slack_webhook" {
  description = "Slack webhook for role violations"
  default     = ""
}

variable "service_account_key_violations_should_notify" {
  description = "Notify for service account key violations"
  type        = bool
  default     = true
}

variable "external_project_access_violations_should_notify" {
  description = "Notify for External Project Access violations"
  type        = bool
  default     = true
}

variable "cscc_violations_enabled" {
  description = "Notify for CSCC violations"
  type        = bool
  default     = false
}

variable "cscc_source_id" {
  description = "Source ID for CSCC Beta API"
  default     = ""
}

variable "inventory_gcs_summary_enabled" {
  description = "GCS summary for inventory enabled"
  type        = bool
  default     = true
}

variable "inventory_email_summary_enabled" {
  description = "Email summary for inventory enabled"
  type        = bool
  default     = false
}

#---------------------------------------#
# Groups Settings scanner configuration #
#---------------------------------------#

variable "groups_settings_max_calls" {
  description = "Maximum calls that can be made to the G Suite Groups API"
  default     = "5"
}

variable "groups_settings_period" {
  description = "the period of max calls to the G Suite Groups API"
  default     = "1.1"
}

variable "groups_settings_disable_polling" {
  description = "Whether to disable polling for the G Suite Groups API"
  type        = bool
  default     = false
}

variable "groups_settings_enabled" {
  description = "Groups settings scanner enabled."
  type        = bool
  default     = true
}

variable "groups_settings_violations_should_notify" {
  description = "Notify for groups settings violations"
  type        = bool
  default     = true
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

variable "client_instance_metadata" {
  description = "Metadata key/value pairs to make available from within the client instance."
  type        = map(string)
  default     = {}
}

variable "client_ssh_allow_ranges" {
  description = "List of CIDRs that will be allowed ssh access to forseti client"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "client_tags" {
  description = "GCE Forseti Client VM Tags"
  type        = list(string)
  default     = []
}

variable "client_access_config" {
  description = "Client instance 'access_config' block"
  default     = {}
  type        = map(any)
}

variable "client_private" {
  description = "Private GCE Forseti Client VM (no public IP)"
  default     = false
  type        = bool
}

variable "client_service_account" {
  description = "Service account email to assign to the Client VM. If empty, a new Service Account will be created"
  default     = ""
}

variable "client_labels" {
  description = "Client instance labels"
  type        = map(string)
  default     = {}
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

variable "cloudsql_disk_size" {
  description = "The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
  default     = "25"
}

variable "cloudsql_availability_type" {
  description = "Whether instance should be set up for high availability (REGIONAL) or single zone (ZONAL)."
  default     = null
}

variable "cloudsql_private" {
  description = "Whether to enable private network and not to create public IP for CloudSQL Instance"
  default     = false
  type        = bool
}

variable "cloudsql_proxy_arch" {
  description = "CloudSQL Proxy architecture"
  default     = "linux.amd64"
}

variable "cloudsql_type" {
  description = "CloudSQL Instance size"
  default     = "db-n1-standard-4"
}

variable "cloudsql_user_host" {
  description = "The host the user can connect from.  Can be an IP address or IP address range. Changing this forces a new resource to be created."
  default     = "%"
}

variable "cloudsql_net_write_timeout" {
  description = "See MySQL documentation: https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_net_write_timeout"
  default     = "240"
}

variable "cloudsql_db_user" {
  description = "CloudSQL database user"
  default     = "forseti_security_user"
}

variable "cloudsql_db_password" {
  description = "CloudSQL database password"
  default     = ""
}

variable "cloudsql_labels" {
  description = "CloudSQL instance labels"
  type        = map(string)
  default     = {}
}

#----------------#
# Forseti bucket #
#----------------#
variable "storage_bucket_location" {
  description = "GCS storage bucket location"
  default     = "us-central1"
}

variable "storage_bucket_class" {
  description = "GCS storage bucket storage class. Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE"
  default     = "STANDARD"
}

variable "bucket_cai_location" {
  description = "GCS CAI storage bucket location"
  default     = "us-central1"
}

variable "bucket_cai_lifecycle_age" {
  description = "GCS CAI lifecycle age value"
  default     = "14"
}

variable "gcs_labels" {
  description = "GCS bucket labels"
  type        = map(string)
  default     = {}
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

variable "enable_service_networking" {
  description = "Create a global service networking peering connection at the VPC level"
  type        = bool
  default     = true
}

variable "manage_firewall_rules" {
  description = "Create client firewall rules"
  default     = true
}

variable "firewall_logging" {
  description = "Enable firewall logging"
  type        = bool
  default     = false
}
#-------#
# Flags #
#-------#
variable "enable_write" {
  description = "Enabling/Disabling write actions"
  type        = bool
  default     = false
}

variable "enable_cai_bucket" {
  description = "Create a GCS bucket for CAI exports"
  type        = bool
  default     = true
}

#--------#
# Config #
#--------#
variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
  default     = ""
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "folder_id" {
  description = "GCP Folder that the Forseti project will be deployed into"
  default     = ""
}

variable "composite_root_resources" {
  description = "A list of root resources that Forseti will monitor. This supersedes the root_resource_id when set."
  type        = list(string)
  default     = []
}

variable "sendgrid_api_key" {
  description = "Sendgrid.com API key to enable email notifications"
  default     = ""
}
