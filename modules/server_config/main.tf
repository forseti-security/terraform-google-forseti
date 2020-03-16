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

#--------#
# Locals #
#--------#
locals {
  server_conf = file(
    "${path.module}/templates/configs/forseti_conf_server.yaml.tpl",
  )

  # Determine the root resource. If a composite root resource list is available
  # then it will take precedence, otherwise we'll fall back to a singular root
  # resource.

  # If composite root resources are present, set the root_resource_id to the empty string. This
  # mitigates issues in the Forseti explainer that requires `root_resource_id` to be of type `str`.
  root_resource_id         = "root_resource_id: ${length(var.composite_root_resources) > 0 ? "\"\"" : var.folder_id != "" ? "folders/${var.folder_id}" : "organizations/${var.org_id}"}"
  composite_root_resources = length(var.composite_root_resources) > 0 ? "composite_root_resources: [${join(", ", formatlist("\"%s\"", var.composite_root_resources))}]" : ""
  excluded_resources       = length(var.excluded_resources) > 0 ? "excluded_resources: [${join(", ", formatlist("\"%s\"", var.excluded_resources))}]" : ""

  missing_emails = ((var.sendgrid_api_key != "") && (var.forseti_email_sender == "" || var.forseti_email_recipient == "") ? 1 : 0)
}

#------------------#
# Input validation #
#------------------#
resource "null_resource" "missing_emails" {
  count = local.missing_emails
  provisioner "local-exec" {
    command     = "echo 'expected missing_emails to be 0 or false, got ${local.missing_emails}, sendgrid_api_key=${var.sendgrid_api_key} forseti_email_sender=${var.forseti_email_sender} forseti_email_recipient=${var.forseti_email_recipient}' >&2; false"
    interpreter = ["bash", "-c"]
  }
}

#-------------------#
# Forseti templates #
#-------------------#

data "template_file" "forseti_server_config" {
  template = local.server_conf

  # The variable casing and naming used here is used to match the
  # upstream forseti templates more closely, reducing the amount
  # of modifications needed to convert the Python templates into
  # Terraform templates.
  vars = {
    RULES_PATH                                          = var.rules_path
    ROOT_RESOURCE_ID                                    = local.root_resource_id
    COMPOSITE_ROOT_RESOURCES                            = local.composite_root_resources
    DOMAIN_SUPER_ADMIN_EMAIL                            = var.gsuite_admin_email
    CAI_ENABLED                                         = var.server_gcs_module.forseti-cai-bucket-enabled
    FORSETI_CAI_BUCKET                                  = var.server_gcs_module.forseti-cai-storage-bucket
    FORSETI_BUCKET                                      = var.server_gcs_module.forseti-server-storage-bucket
    STORAGE_DISABLE_POLLING                             = var.storage_disable_polling
    SQLADMIN_PERIOD                                     = var.sqladmin_period
    SQLADMIN_MAX_CALLS                                  = var.sqladmin_max_calls
    SQLADMIN_DISABLE_POLLING                            = var.sqladmin_disable_polling
    SERVICEMANAGEMENT_PERIOD                            = var.servicemanagement_period
    SERVICEMANAGEMENT_MAX_CALLS                         = var.servicemanagement_max_calls
    SERVICEMANAGEMENT_DISABLE_POLLING                   = var.servicemanagement_disable_polling
    SERVICEUSAGE_PERIOD                                 = var.serviceusage_period
    SERVICEUSAGE_MAX_CALLS                              = var.serviceusage_max_calls
    SERVICEUSAGE_DISABLE_POLLING                        = var.serviceusage_disable_polling
    SECURITYCENTER_PERIOD                               = var.securitycenter_period
    SECURITYCENTER_MAX_CALLS                            = var.securitycenter_max_calls
    SECURITYCENTER_DISABLE_POLLING                      = var.securitycenter_disable_polling
    LOGGING_PERIOD                                      = var.logging_period
    LOGGING_MAX_CALLS                                   = var.logging_max_calls
    LOGGING_DISABLE_POLLING                             = var.logging_disable_polling
    IAM_PERIOD                                          = var.iam_period
    IAM_MAX_CALLS                                       = var.iam_max_calls
    IAM_DISABLE_POLLING                                 = var.iam_disable_polling
    CRM_PERIOD                                          = var.crm_period
    CRM_MAX_CALLS                                       = var.crm_max_calls
    CRM_DISABLE_POLLING                                 = var.crm_disable_polling
    CONTAINER_PERIOD                                    = var.container_period
    CONTAINER_MAX_CALLS                                 = var.container_max_calls
    CONTAINER_DISABLE_POLLING                           = var.container_disable_polling
    COMPUTE_PERIOD                                      = var.compute_period
    COMPUTE_MAX_CALLS                                   = var.compute_max_calls
    COMPUTE_DISABLE_POLLING                             = var.compute_disable_polling
    CLOUDBILLING_PERIOD                                 = var.cloudbilling_period
    CLOUDBILLING_MAX_CALLS                              = var.cloudbilling_max_calls
    CLOUDBILLING_DISABLE_POLLING                        = var.cloudbilling_disable_polling
    CLOUDASSET_PERIOD                                   = var.cloudasset_period
    CLOUDASSET_MAX_CALLS                                = var.cloudasset_max_calls
    CLOUDASSET_DISABLE_POLLING                          = var.cloudasset_disable_polling
    INVENTORY_RETENTION_DAYS                            = var.inventory_retention_days
    CAI_API_TIMEOUT                                     = var.cai_api_timeout
    BIGQUERY_PERIOD                                     = var.bigquery_period
    BIGQUERY_MAX_CALLS                                  = var.bigquery_max_calls
    BIGQUERY_DISABLE_POLLING                            = var.bigquery_disable_polling
    APPENGINE_PERIOD                                    = var.appengine_period
    APPENGINE_MAX_CALLS                                 = var.appengine_max_calls
    APPENGINE_DISABLE_POLLING                           = var.appengine_disable_polling
    ADMIN_PERIOD                                        = var.admin_period
    ADMIN_MAX_CALLS                                     = var.admin_max_calls
    ADMIN_DISABLE_POLLING                               = var.admin_disable_polling
    SERVICE_ACCOUNT_KEY_ENABLED                         = var.service_account_key_enabled
    ROLE_ENABLED                                        = var.role_enabled
    RETENTION_ENABLED                                   = var.retention_enabled
    RESOURCE_ENABLED                                    = var.resource_enabled
    LOG_SINK_ENABLED                                    = var.log_sink_enabled
    LOCATION_ENABLED                                    = var.location_enabled
    LIEN_ENABLED                                        = var.lien_enabled
    KE_VERSION_SCANNER_ENABLED                          = var.ke_version_scanner_enabled
    KMS_SCANNER_ENABLED                                 = var.kms_scanner_enabled
    KE_SCANNER_ENABLED                                  = var.ke_scanner_enabled
    INSTANCE_NETWORK_INTERFACE_ENABLED                  = var.instance_network_interface_enabled
    IAP_ENABLED                                         = var.iap_enabled
    IAM_POLICY_ENABLED                                  = var.iam_policy_enabled
    GROUP_ENABLED                                       = var.group_enabled
    FORWARDING_RULE_ENABLED                             = var.forwarding_rule_enabled
    FIREWALL_RULE_ENABLED                               = var.firewall_rule_enabled
    ENABLED_APIS_ENABLED                                = var.enabled_apis_enabled
    CLOUDSQL_ACL_ENABLED                                = var.cloudsql_acl_enabled
    CONFIG_VALIDATOR_ENABLED                            = var.config_validator_enabled
    BUCKET_ACL_ENABLED                                  = var.bucket_acl_enabled
    BLACKLIST_ENABLED                                   = var.blacklist_enabled
    BIGQUERY_ENABLED                                    = var.bigquery_enabled
    AUDIT_LOGGING_ENABLED                               = var.audit_logging_enabled
    SERVICE_ACCOUNT_KEY_VIOLATIONS_SHOULD_NOTIFY        = var.service_account_key_violations_should_notify
    ROLE_VIOLATIONS_SHOULD_NOTIFY                       = var.role_violations_should_notify
    ROLE_VIOLATIONS_SLACK_WEBHOOK                       = var.role_violations_slack_webhook
    RETENTION_VIOLATIONS_SHOULD_NOTIFY                  = var.retention_violations_should_notify
    RETENTION_VIOLATIONS_SLACK_WEBHOOK                  = var.retention_violations_slack_webhook
    RESOURCE_VIOLATIONS_SHOULD_NOTIFY                   = var.resource_violations_should_notify
    LOG_SINK_VIOLATIONS_SHOULD_NOTIFY                   = var.log_sink_violations_should_notify
    LOCATION_VIOLATIONS_SHOULD_NOTIFY                   = var.location_violations_should_notify
    LIEN_VIOLATIONS_SHOULD_NOTIFY                       = var.lien_violations_should_notify
    KE_VIOLATIONS_SHOULD_NOTIFY                         = var.ke_violations_should_notify
    KE_VERSION_VIOLATIONS_SHOULD_NOTIFY                 = var.ke_version_violations_should_notify
    KMS_VIOLATIONS_SHOULD_NOTIFY                        = var.kms_violations_should_notify
    KMS_VIOLATIONS_SLACK_WEBHOOK                        = var.kms_violations_slack_webhook
    INVENTORY_GCS_SUMMARY_ENABLED                       = var.inventory_gcs_summary_enabled
    INVENTORY_EMAIL_SUMMARY_ENABLED                     = var.inventory_email_summary_enabled
    INSTANCE_NETWORK_INTERFACE_VIOLATIONS_SHOULD_NOTIFY = var.instance_network_interface_violations_should_notify
    IAP_VIOLATIONS_SHOULD_NOTIFY                        = var.iap_violations_should_notify
    IAM_POLICY_VIOLATIONS_SHOULD_NOTIFY                 = var.iam_policy_violations_should_notify
    IAM_POLICY_VIOLATIONS_SLACK_WEBHOOK                 = var.iam_policy_violations_slack_webhook
    GROUPS_VIOLATIONS_SHOULD_NOTIFY                     = var.groups_violations_should_notify
    FORWARDING_RULE_VIOLATIONS_SHOULD_NOTIFY            = var.forwarding_rule_violations_should_notify
    FIREWALL_RULE_VIOLATIONS_SHOULD_NOTIFY              = var.firewall_rule_violations_should_notify
    EXTERNAL_PROJECT_ACCESS_VIOLATIONS_SHOULD_NOTIFY    = var.external_project_access_violations_should_notify
    ENABLED_APIS_VIOLATIONS_SHOULD_NOTIFY               = var.enabled_apis_violations_should_notify
    CLOUDSQL_ACL_VIOLATIONS_SHOULD_NOTIFY               = var.cloudsql_acl_violations_should_notify
    CONFIG_VALIDATOR_VIOLATIONS_SHOULD_NOTIFY           = var.config_validator_violations_should_notify
    BUCKETS_ACL_VIOLATIONS_SHOULD_NOTIFY                = var.buckets_acl_violations_should_notify
    BLACKLIST_VIOLATIONS_SHOULD_NOTIFY                  = var.blacklist_violations_should_notify
    BIGQUERY_ACL_VIOLATIONS_SHOULD_NOTIFY               = var.bigquery_acl_violations_should_notify
    AUDIT_LOGGING_VIOLATIONS_SHOULD_NOTIFY              = var.audit_logging_violations_should_notify
    VIOLATIONS_SLACK_WEBHOOK                            = var.violations_slack_webhook
    EXCLUDED_RESOURCES                                  = local.excluded_resources
    VERIFY_POLICY_LIBRARY                               = var.verify_policy_library

    # CSCC notifications
    CSCC_VIOLATIONS_ENABLED = var.cscc_violations_enabled
    CSCC_SOURCE_ID          = var.cscc_source_id
    # Email notifications
    EMAIL_SENDER     = var.forseti_email_sender
    EMAIL_RECIPIENT  = var.forseti_email_recipient
    SENDGRID_API_KEY = var.sendgrid_api_key
    # Group settings
    GROUPS_SETTINGS_MAX_CALLS                = var.groups_settings_max_calls
    GROUPS_SETTINGS_PERIOD                   = var.groups_settings_period
    GROUPS_SETTINGS_DISABLE_POLLING          = var.groups_settings_disable_polling
    GROUPS_SETTINGS_ENABLED                  = var.groups_settings_enabled
    GROUPS_SETTINGS_VIOLATIONS_SHOULD_NOTIFY = var.groups_settings_violations_should_notify
  }
}

#------------------------#
# Forseti Storage bucket #
#------------------------#

resource "google_storage_bucket_object" "forseti_server_config" {
  name    = "configs/forseti_conf_server.yaml"
  bucket  = var.server_gcs_module.forseti-server-storage-bucket
  content = data.template_file.forseti_server_config.rendered
}
