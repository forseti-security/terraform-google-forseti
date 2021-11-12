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

resource "random_id" "random_hash_suffix" {
  byte_length = 4
}

resource "null_resource" "org_id_and_folder_id_are_both_empty" {
  count = length(var.composite_root_resources) == 0 && var.org_id == "" && var.folder_id == "" ? 1 : 0

  provisioner "local-exec" {
    command     = "echo 'composite_root_resources=${join(",", var.composite_root_resources)} org_id=${var.org_id} folder_id=${var.org_id}' >&2; false"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "email_without_sendgrid_api_key" {
  count = var.inventory_email_summary_enabled == "true" && var.sendgrid_api_key == "" ? 1 : 0

  provisioner "local-exec" {
    command     = "echo 'inventory_email_summary_enabled=${var.inventory_email_summary_enabled} sendgrid_api_key=${var.sendgrid_api_key}' >&2; false"
    interpreter = ["bash", "-c"]
  }
}

#--------#
# Locals #
#--------#
locals {
  random_hash     = var.resource_name_suffix == null ? random_id.random_hash_suffix.hex : var.resource_name_suffix
  network_project = var.network_project != "" ? var.network_project : var.project_id

  services_list = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "bigquery.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "serviceusage.googleapis.com",
    "logging.googleapis.com",
    "cloudasset.googleapis.com",
    "storage-api.googleapis.com",
    "groupssettings.googleapis.com",
    "spanner.googleapis.com",
  ]

  cscc_violations_enabled_services_list = [
    "securitycenter.googleapis.com",
  ]

  cloud_profiler_enabled_services_list = [
    "cloudprofiler.googleapis.com"
  ]
}

#-------------------#
# Activate services #
#-------------------#
resource "google_project_service" "main" {
  count              = length(local.services_list)
  project            = var.project_id
  service            = local.services_list[count.index]
  disable_on_destroy = "false"
}

resource "google_project_service" "cscc_violations" {
  count              = var.cscc_violations_enabled ? length(local.cscc_violations_enabled_services_list) : 0
  project            = var.project_id
  service            = local.cscc_violations_enabled_services_list[count.index]
  disable_on_destroy = "false"
}

resource "google_project_service" "cloud_profiler" {
  count              = var.cloud_profiler_enabled ? length(local.cloud_profiler_enabled_services_list) : 0
  project            = var.project_id
  service            = local.cloud_profiler_enabled_services_list[count.index]
  disable_on_destroy = "false"
}

module "client" {
  source = "./modules/client"

  client_enabled                  = var.client_enabled
  project_id                      = var.project_id
  client_boot_image               = var.client_boot_image
  client_shielded_instance_config = var.client_shielded_instance_config
  subnetwork                      = var.subnetwork
  forseti_home                    = var.forseti_home
  forseti_version                 = var.forseti_version
  forseti_repo_url                = var.forseti_repo_url
  client_type                     = var.client_type
  client_labels                   = var.client_labels
  network_project                 = local.network_project
  network                         = var.network
  firewall_logging                = var.firewall_logging
  suffix                          = local.random_hash
  client_region                   = var.client_region
  client_instance_metadata        = var.client_instance_metadata
  client_ssh_allow_ranges         = var.client_ssh_allow_ranges
  client_tags                     = var.client_tags
  client_access_config            = var.client_access_config
  client_private                  = var.client_private
  manage_firewall_rules           = var.manage_firewall_rules
  client_iam_module               = module.client_iam
  client_gcs_module               = module.client_gcs
  client_config_module            = module.client_config
  google_cloud_sdk_version        = var.google_cloud_sdk_version

  services = google_project_service.main.*.service
}

module "server" {
  source = "./modules/server"

  project_id                      = var.project_id
  forseti_version                 = var.forseti_version
  forseti_repo_url                = var.forseti_repo_url
  forseti_home                    = var.forseti_home
  forseti_run_frequency           = var.forseti_run_frequency
  forseti_scripts                 = var.forseti_scripts
  server_type                     = var.server_type
  server_region                   = var.server_region
  server_boot_image               = var.server_boot_image
  server_boot_disk_size           = var.server_boot_disk_size
  server_boot_disk_type           = var.server_boot_disk_type
  server_shielded_instance_config = var.server_shielded_instance_config
  server_tags                     = var.server_tags
  server_labels                   = var.server_labels
  server_access_config            = var.server_access_config
  server_private                  = var.server_private
  cloudsql_proxy_arch             = var.cloudsql_proxy_arch
  cloud_profiler_enabled          = var.cloud_profiler_enabled
  config_validator_image          = var.config_validator_image
  config_validator_image_tag      = var.config_validator_image_tag
  mailjet_enabled                 = var.mailjet_enabled
  network                         = var.network
  network_project                 = local.network_project
  manage_firewall_rules           = var.manage_firewall_rules
  firewall_logging                = var.firewall_logging
  server_grpc_allow_ranges        = var.server_grpc_allow_ranges
  server_instance_metadata        = var.server_instance_metadata
  server_ssh_allow_ranges         = var.server_ssh_allow_ranges
  subnetwork                      = var.subnetwork
  suffix                          = local.random_hash
  google_cloud_sdk_version        = var.google_cloud_sdk_version

  policy_library_home                    = var.policy_library_home
  policy_library_repository_url          = var.policy_library_repository_url
  policy_library_repository_branch       = var.policy_library_repository_branch
  policy_library_sync_enabled            = var.policy_library_sync_enabled
  policy_library_sync_gcs_directory_name = var.policy_library_sync_gcs_directory_name
  policy_library_sync_git_sync_tag       = var.policy_library_sync_git_sync_tag
  policy_library_sync_ssh_known_hosts    = var.policy_library_sync_ssh_known_hosts

  client_iam_module    = module.client_iam
  cloudsql_module      = module.cloudsql
  server_config_module = module.server_config
  server_gcs_module    = module.server_gcs
  server_iam_module    = module.server_iam
  server_rules_module  = module.server_rules

  services = google_project_service.main.*.service

}

module "cloudsql" {
  source                     = "./modules/cloudsql"
  cloudsql_db_name           = var.cloudsql_db_name
  cloudsql_disk_size         = var.cloudsql_disk_size
  cloudsql_net_write_timeout = var.cloudsql_net_write_timeout
  cloudsql_password          = var.cloudsql_db_password
  cloudsql_private           = var.cloudsql_private
  cloudsql_region            = var.cloudsql_region
  cloudsql_availability_type = var.cloudsql_availability_type
  cloudsql_type              = var.cloudsql_type
  cloudsql_user              = var.cloudsql_db_user
  cloudsql_user_host         = var.cloudsql_user_host
  cloudsql_labels            = var.cloudsql_labels
  enable_service_networking  = var.enable_service_networking
  network                    = var.network
  network_project            = var.network_project
  project_id                 = var.project_id
  services                   = google_project_service.main.*.service
  suffix                     = local.random_hash
}

module "server_iam" {
  source                  = "./modules/server_iam"
  cscc_violations_enabled = var.cscc_violations_enabled
  cloud_profiler_enabled  = var.cloud_profiler_enabled
  enable_write            = var.enable_write
  folder_id               = var.folder_id
  org_id                  = var.org_id
  project_id              = var.project_id
  suffix                  = local.random_hash
  server_service_account  = var.server_service_account
}

module "server_gcs" {
  source                   = "./modules/server_gcs"
  project_id               = var.project_id
  bucket_cai_location      = var.bucket_cai_location
  bucket_cai_lifecycle_age = var.bucket_cai_lifecycle_age
  enable_cai_bucket        = var.enable_cai_bucket
  storage_bucket_location  = var.storage_bucket_location
  storage_bucket_class     = var.storage_bucket_class
  services                 = google_project_service.main.*.service
  suffix                   = local.random_hash
  gcs_labels               = var.gcs_labels
}

module "server_rules" {
  source               = "./modules/rules"
  server_gcs_module    = module.server_gcs
  org_id               = var.org_id
  domain               = var.domain
  manage_rules_enabled = var.manage_rules_enabled
}

module "server_config" {
  source                                              = "./modules/server_config"
  composite_root_resources                            = var.composite_root_resources
  server_gcs_module                                   = module.server_gcs
  forseti_email_recipient                             = var.forseti_email_recipient
  forseti_email_sender                                = var.forseti_email_sender
  sendgrid_api_key                                    = var.sendgrid_api_key
  org_id                                              = var.org_id
  folder_id                                           = var.folder_id
  domain                                              = var.domain
  gsuite_admin_email                                  = var.gsuite_admin_email
  storage_disable_polling                             = var.storage_disable_polling
  sqladmin_period                                     = var.sqladmin_period
  sqladmin_max_calls                                  = var.sqladmin_max_calls
  sqladmin_disable_polling                            = var.sqladmin_disable_polling
  servicemanagement_period                            = var.servicemanagement_period
  servicemanagement_max_calls                         = var.servicemanagement_max_calls
  servicemanagement_disable_polling                   = var.servicemanagement_disable_polling
  serviceusage_period                                 = var.serviceusage_period
  serviceusage_max_calls                              = var.serviceusage_max_calls
  serviceusage_disable_polling                        = var.serviceusage_disable_polling
  securitycenter_period                               = var.securitycenter_period
  securitycenter_max_calls                            = var.securitycenter_max_calls
  logging_period                                      = var.logging_period
  logging_max_calls                                   = var.logging_max_calls
  logging_disable_polling                             = var.logging_disable_polling
  iam_period                                          = var.iam_period
  iam_max_calls                                       = var.iam_max_calls
  iam_disable_polling                                 = var.iam_disable_polling
  crm_period                                          = var.crm_period
  crm_max_calls                                       = var.crm_max_calls
  crm_disable_polling                                 = var.crm_disable_polling
  container_period                                    = var.container_period
  container_max_calls                                 = var.container_max_calls
  container_disable_polling                           = var.container_disable_polling
  compute_period                                      = var.compute_period
  compute_max_calls                                   = var.compute_max_calls
  compute_disable_polling                             = var.compute_disable_polling
  cloudbilling_period                                 = var.cloudbilling_period
  cloudbilling_max_calls                              = var.cloudbilling_max_calls
  cloudbilling_disable_polling                        = var.cloudbilling_disable_polling
  cloudasset_period                                   = var.cloudasset_period
  cloudasset_max_calls                                = var.cloudasset_max_calls
  cloudasset_disable_polling                          = var.cloudasset_disable_polling
  inventory_retention_days                            = var.inventory_retention_days
  cai_api_timeout                                     = var.cai_api_timeout
  bigquery_period                                     = var.bigquery_period
  bigquery_max_calls                                  = var.bigquery_max_calls
  bigquery_disable_polling                            = var.bigquery_disable_polling
  appengine_period                                    = var.appengine_period
  appengine_max_calls                                 = var.appengine_max_calls
  appengine_disable_polling                           = var.appengine_disable_polling
  admin_period                                        = var.admin_period
  admin_max_calls                                     = var.admin_max_calls
  admin_disable_polling                               = var.admin_disable_polling
  service_account_key_enabled                         = var.service_account_key_enabled
  role_enabled                                        = var.role_enabled
  retention_enabled                                   = var.retention_enabled
  resource_enabled                                    = var.resource_enabled
  log_sink_enabled                                    = var.log_sink_enabled
  location_enabled                                    = var.location_enabled
  lien_enabled                                        = var.lien_enabled
  ke_version_scanner_enabled                          = var.ke_version_scanner_enabled
  kms_scanner_enabled                                 = var.kms_scanner_enabled
  ke_scanner_enabled                                  = var.ke_scanner_enabled
  instance_network_interface_enabled                  = var.instance_network_interface_enabled
  iap_enabled                                         = var.iap_enabled
  iam_policy_enabled                                  = var.iam_policy_enabled
  group_enabled                                       = var.group_enabled
  forwarding_rule_enabled                             = var.forwarding_rule_enabled
  firewall_rule_enabled                               = var.firewall_rule_enabled
  enabled_apis_enabled                                = var.enabled_apis_enabled
  cloudsql_acl_enabled                                = var.cloudsql_acl_enabled
  config_validator_enabled                            = var.config_validator_enabled
  bucket_acl_enabled                                  = var.bucket_acl_enabled
  blacklist_enabled                                   = var.blacklist_enabled
  bigquery_enabled                                    = var.bigquery_enabled
  audit_logging_enabled                               = var.audit_logging_enabled
  service_account_key_violations_should_notify        = var.service_account_key_violations_should_notify
  role_violations_should_notify                       = var.role_violations_should_notify
  role_violations_slack_webhook                       = var.role_violations_slack_webhook
  retention_violations_should_notify                  = var.retention_violations_should_notify
  retention_violations_slack_webhook                  = var.retention_violations_slack_webhook
  resource_violations_should_notify                   = var.resource_violations_should_notify
  log_sink_violations_should_notify                   = var.log_sink_violations_should_notify
  location_violations_should_notify                   = var.location_violations_should_notify
  lien_violations_should_notify                       = var.lien_violations_should_notify
  ke_violations_should_notify                         = var.ke_violations_should_notify
  ke_version_violations_should_notify                 = var.ke_version_violations_should_notify
  kms_violations_should_notify                        = var.kms_violations_should_notify
  kms_violations_slack_webhook                        = var.kms_violations_slack_webhook
  inventory_gcs_summary_enabled                       = var.inventory_gcs_summary_enabled
  inventory_email_summary_enabled                     = var.inventory_email_summary_enabled
  instance_network_interface_violations_should_notify = var.instance_network_interface_violations_should_notify
  iap_violations_should_notify                        = var.iap_violations_should_notify
  iam_policy_violations_should_notify                 = var.iam_policy_violations_should_notify
  iam_policy_violations_slack_webhook                 = var.iam_policy_violations_slack_webhook
  groups_violations_should_notify                     = var.groups_violations_should_notify
  forwarding_rule_violations_should_notify            = var.forwarding_rule_violations_should_notify
  firewall_rule_violations_should_notify              = var.firewall_rule_violations_should_notify
  external_project_access_violations_should_notify    = var.external_project_access_violations_should_notify
  enabled_apis_violations_should_notify               = var.enabled_apis_violations_should_notify
  cloudsql_acl_violations_should_notify               = var.cloudsql_acl_violations_should_notify
  config_validator_violations_should_notify           = var.config_validator_violations_should_notify
  buckets_acl_violations_should_notify                = var.buckets_acl_violations_should_notify
  blacklist_violations_should_notify                  = var.blacklist_violations_should_notify
  bigquery_acl_violations_should_notify               = var.bigquery_acl_violations_should_notify
  audit_logging_violations_should_notify              = var.audit_logging_violations_should_notify
  excluded_resources                                  = var.excluded_resources
  violations_slack_webhook                            = var.violations_slack_webhook
  cscc_violations_enabled                             = var.cscc_violations_enabled
  cscc_source_id                                      = var.cscc_source_id
  rules_path                                          = var.rules_path
  verify_policy_library                               = var.verify_policy_library

  groups_settings_max_calls                = var.groups_settings_max_calls
  groups_settings_period                   = var.groups_settings_period
  groups_settings_disable_polling          = var.groups_settings_disable_polling
  groups_settings_enabled                  = var.groups_settings_enabled
  groups_settings_violations_should_notify = var.groups_settings_violations_should_notify
}

module "client_iam" {
  source                 = "./modules/client_iam"
  client_enabled         = var.client_enabled
  project_id             = var.project_id
  suffix                 = local.random_hash
  client_service_account = var.client_service_account
}

module "client_gcs" {
  source                  = "./modules/client_gcs"
  client_enabled          = var.client_enabled
  project_id              = var.project_id
  storage_bucket_location = var.storage_bucket_location
  storage_bucket_class    = var.storage_bucket_class
  suffix                  = local.random_hash
  gcs_labels              = var.gcs_labels

  services = google_project_service.main.*.service
}

module "client_config" {
  source            = "./modules/client_config"
  client_enabled    = var.client_enabled
  client_gcs_module = module.client_gcs
  server_address    = module.server.forseti-server-vm-internal-dns
}
