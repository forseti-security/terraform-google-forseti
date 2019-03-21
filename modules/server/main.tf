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

#--------#
# Locals #
#--------#
locals {
  random_hash             = "${var.suffix}"
  root_resource_id        = "${var.folder_id != "" ? "folders/${var.folder_id}" : "organizations/${var.org_id}"}"
  network_project         = "${var.network_project != "" ? var.network_project : var.project_id}"
  server_zone             = "${var.server_region}-c"
  server_startup_script   = "${file("${path.module}/templates/scripts/forseti-server/forseti_server_startup_script.sh.tpl")}"
  server_environment      = "${file("${path.module}/templates/scripts/forseti-server/forseti_environment.sh.tpl")}"
  server_env              = "${file("${path.module}/templates/scripts/forseti-server/forseti_env.sh.tpl")}"
  server_conf             = "${file("${path.module}/templates/configs/forseti_conf_server.yaml.tpl")}"
  server_conf_path        = "${var.forseti_home}/configs/forseti_conf_server.yaml"
  server_name             = "forseti-server-vm-${local.random_hash}"
  server_sa_name          = "forseti-server-gcp-${local.random_hash}"
  cloudsql_name           = "forseti-server-db-${local.random_hash}"
  storage_bucket_name     = "forseti-server-${local.random_hash}"
  storage_cai_bucket_name = "forseti-cai-export-${local.random_hash}"
  server_bucket_name      = "forseti-server-${local.random_hash}"

  server_project_roles = [
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/cloudsql.client",
    "roles/cloudtrace.agent",
    "roles/logging.logWriter",
    "roles/iam.serviceAccountTokenCreator",
  ]

  server_write_roles = [
    "roles/compute.securityAdmin",
  ]

  server_read_roles = [
    "roles/appengine.appViewer",
    "roles/bigquery.dataViewer",
    "roles/bigquery.metadataViewer",
    "roles/browser",
    "roles/cloudasset.viewer",
    "roles/cloudsql.viewer",
    "roles/compute.networkViewer",
    "roles/iam.securityReviewer",
    "roles/orgpolicy.policyViewer",
    "roles/servicemanagement.quotaViewer",
    "roles/serviceusage.serviceUsageConsumer",
  ]

  server_bucket_roles = [
    "roles/storage.objectAdmin",
  ]
}

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_server_startup_script" {
  template = "${local.server_startup_script}"

  vars {
    forseti_environment          = "${data.template_file.forseti_server_environment.rendered}"
    forseti_env                  = "${data.template_file.forseti_server_env.rendered}"
    forseti_run_frequency        = "${var.forseti_run_frequency}"
    forseti_repo_url             = "${var.forseti_repo_url}"
    forseti_version              = "${var.forseti_version}"
    forseti_server_conf_path     = "${local.server_conf_path}"
    forseti_home                 = "${var.forseti_home}"
    cloudsql_proxy_arch          = "${var.cloudsql_proxy_arch}"
    storage_bucket_name          = "${local.server_bucket_name}"
    forseti_conf_server_checksum = "${base64sha256(data.template_file.forseti_server_config.rendered)}"
  }
}

data "template_file" "forseti_server_environment" {
  template = "${local.server_environment}"

  vars {
    forseti_home             = "${var.forseti_home}"
    forseti_server_conf_path = "${local.server_conf_path}"
    storage_bucket_name      = "${local.server_bucket_name}"
  }
}

data "template_file" "forseti_server_env" {
  template = "${local.server_env}"

  vars {
    project_id             = "${var.project_id}"
    cloudsql_db_name       = "${var.cloudsql_db_name}"
    cloudsql_db_port       = "${var.cloudsql_db_port}"
    cloudsql_region        = "${var.cloudsql_region}"
    cloudsql_instance_name = "${google_sql_database_instance.master.name}"
  }
}

data "template_file" "forseti_server_config" {
  template = "${local.server_conf}"

  # The variable casing and naming used here is used to match the
  # upstream forseti templates more closely, reducing the amount
  # of modifications needed to convert the Python templates into
  # Terraform templates.
  vars {
    ROOT_RESOURCE_ID                                    = "${local.root_resource_id}"
    DOMAIN_SUPER_ADMIN_EMAIL                            = "${var.gsuite_admin_email}"
    CAI_ENABLED                                         = "${var.enable_cai_bucket ? "true" : "false"}"
    FORSETI_CAI_BUCKET                                  = "${google_storage_bucket.cai_export.name}"
    FORSETI_BUCKET                                      = "${local.server_bucket_name}"
    SENDGRID_API_KEY                                    = "${var.sendgrid_api_key}"
    EMAIL_SENDER                                        = "${var.forseti_email_sender}"
    EMAIL_RECIPIENT                                     = "${var.forseti_email_recipient}"
    STORAGE_DISABLE_POLLING                             = "${var.storage_disable_polling ? "true" : "false"}",
    SQLADMIN_PERIOD                                     = "${var.sqladmin_period}",
    SQLADMIN_MAX_CALLS                                  = "${var.sqladmin_max_calls}",
    SQLADMIN_DISABLE_POLLING                            = "${var.sqladmin_disable_polling ? "true" : "false"}",
    SERVICEMANAGEMENT_PERIOD                            = "${var.servicemanagement_period}",
    SERVICEMANAGEMENT_MAX_CALLS                         = "${var.servicemanagement_max_calls}",
    SERVICEMANAGEMENT_DISABLE_POLLING                   = "${var.servicemanagement_disable_polling ? "true" : "false"}",
    SECURITYCENTER_PERIOD                               = "${var.securitycenter_period}",
    SECURITYCENTER_MAX_CALLS                            = "${var.securitycenter_max_calls}",
    SECURITYCENTER_DISABLE_POLLING                      = "${var.securitycenter_disable_polling ? "true" : "false"}",
    LOGGING_PERIOD                                      = "${var.logging_period}",
    LOGGING_MAX_CALLS                                   = "${var.logging_max_calls}",
    LOGGING_DISABLE_POLLING                             = "${var.logging_disable_polling ? "true" : "false"}",
    IAM_PERIOD                                          = "${var.iam_period}",
    IAM_MAX_CALLS                                       = "${var.iam_max_calls}",
    IAM_DISABLE_POLLING                                 = "${var.iam_disable_polling ? "true" : "false"}",
    CRM_PERIOD                                          = "${var.crm_period}",
    CRM_MAX_CALLS                                       = "${var.crm_max_calls}",
    CRM_DISABLE_POLLING                                 = "${var.crm_disable_polling ? "true" : "false"}",
    CONTAINER_PERIOD                                    = "${var.container_period}",
    CONTAINER_MAX_CALLS                                 = "${var.container_max_calls}",
    CONTAINER_DISABLE_POLLING                           = "${var.container_disable_polling ? "true" : "false"}",
    COMPUTE_PERIOD                                      = "${var.compute_period}",
    COMPUTE_MAX_CALLS                                   = "${var.compute_max_calls}",
    COMPUTE_DISABLE_POLLING                             = "${var.compute_disable_polling ? "true" : "false"}",
    CLOUDBILLING_PERIOD                                 = "${var.cloudbilling_period}",
    CLOUDBILLING_MAX_CALLS                              = "${var.cloudbilling_max_calls}",
    CLOUDBILLING_DISABLE_POLLING                        = "${var.cloudbilling_disable_polling ? "true" : "false"}",
    CLOUDASSET_PERIOD                                   = "${var.cloudasset_period}",
    CLOUDASSET_MAX_CALLS                                = "${var.cloudasset_max_calls}",
    CLOUDASSET_DISABLE_POLLING                          = "${var.cloudasset_disable_polling ? "true" : "false"}",
    INVENTORY_RETENTION_DAYS                                  = "${var.inventory_retention_days}",
    CAI_API_TIMEOUT                                     = "${var.cai_api_timeout}",
    BIGQUERY_PERIOD                                     = "${var.bigquery_period}",
    BIGQUERY_MAX_CALLS                                  = "${var.bigquery_max_calls}",
    BIGQUERY_DISABLE_POLLING                            = "${var.bigquery_disable_polling ? "true" : "false"}",
    APPENGINE_PERIOD                                    = "${var.appengine_period}",
    APPENGINE_MAX_CALLS                                 = "${var.appengine_max_calls}",
    APPENGINE_DISABLE_POLLING                           = "${var.appengine_disable_polling ? "true" : "false"}",
    ADMIN_PERIOD                                        = "${var.admin_period}",
    ADMIN_MAX_CALLS                                     = "${var.admin_max_calls}",
    ADMIN_DISABLE_POLLING                               = "${var.admin_disable_polling ? "true" : "false"}",
    SERVICE_ACCOUNT_KEY_ENABLED                         = "${var.service_account_key_enabled ? "true" : "false"}",
    RESOURCE_ENABLED                                    = "${var.resource_enabled ? "true" : "false"}",
    LOG_SINK_ENABLED                                    = "${var.log_sink_enabled ? "true" : "false"}",
    LOCATION_ENABLED                                    = "${var.location_enabled ? "true" : "false"}",
    LIEN_ENABLED                                        = "${var.lien_enabled ? "true" : "false"}",
    KE_VERSION_SCANNER_ENABLED                          = "${var.ke_version_scanner_enabled ? "true" : "false"}",
    KMS_SCANNER_ENABLED                                 = "${var.kms_scanner_enabled ? "true" : "false"}",
    KE_SCANNER_ENABLED                                  = "${var.ke_scanner_enabled ? "true" : "false"}",
    INSTANCE_NETWORK_INTERFACE_ENABLED                  = "${var.instance_network_interface_enabled ? "true" : "false"}",
    IAP_ENABLED                                         = "${var.iap_enabled ? "true" : "false"}",
    IAM_POLICY_ENABLED                                  = "${var.iam_policy_enabled ? "true" : "false"}",
    GROUP_ENABLED                                       = "${var.group_enabled ? "true" : "false"}",
    FORWARDING_RULE_ENABLED                             = "${var.forwarding_rule_enabled ? "true" : "false"}",
    FIREWALL_RULE_ENABLED                               = "${var.firewall_rule_enabled ? "true" : "false"}",
    ENABLED_APIS_ENABLED                                = "${var.enabled_apis_enabled ? "true" : "false"}",
    CLOUDSQL_ACL_ENABLED                                = "${var.cloudsql_acl_enabled ? "true" : "false"}",
    BUCKET_ACL_ENABLED                                  = "${var.bucket_acl_enabled ? "true" : "false"}",
    BLACKLIST_ENABLED                                   = "${var.blacklist_enabled ? "true" : "false"}",
    BIGQUERY_ENABLED                                     = "${var.bigquery_enabled ? "true" : "false"}",
    AUDIT_LOGGING_ENABLED                               = "${var.audit_logging_enabled ? "true" : "false"}",
    SERVICE_ACCOUNT_KEY_VIOLATIONS_SHOULD_NOTIFY        = "${var.service_account_key_violations_should_notify ? "true" : "false"}",
    RESOURCE_VIOLATIONS_SHOULD_NOTIFY                   = "${var.resource_violations_should_notify ? "true" : "false"}",
    LOG_SINK_VIOLATIONS_SHOULD_NOTIFY                   = "${var.log_sink_violations_should_notify ? "true" : "false"}",
    LOCATION_VIOLATIONS_SHOULD_NOTIFY                   = "${var.location_violations_should_notify ? "true" : "false"}",
    LIEN_VIOLATIONS_SHOULD_NOTIFY                       = "${var.lien_violations_should_notify ? "true" : "false"}",
    KE_VIOLATIONS_SHOULD_NOTIFY                         = "${var.ke_violations_should_notify ? "true" : "false"}",
    KE_VERSION_VIOLATIONS_SHOULD_NOTIFY                 = "${var.ke_version_violations_should_notify ? "true" : "false"}",
    KMS_VIOLATIONS_SHOULD_NOTIFY                        = "${var.kms_violations_should_notify ? "true" : "false"}",
    KMS_VIOLATIONS_SLACK_WEBHOOK                        = "${var.kms_violations_slack_webhook}",
    INVENTORY_GCS_SUMMARY_ENABLED                       = "${var.inventory_gcs_summary_enabled ? "true" : "false"}",
    INVENTORY_EMAIL_SUMMARY_ENABLED                     = "${var.inventory_email_summary_enabled ? "true" : "false"}",
    INSTANCE_NETWORK_INTERFACE_VIOLATIONS_SHOULD_NOTIFY = "${var.instance_network_interface_violations_should_notify ? "true" : "false"}",
    IAP_VIOLATIONS_SHOULD_NOTIFY                        = "${var.iap_violations_should_notify ? "true" : "false"}",
    IAM_POLICY_VIOLATIONS_SHOULD_NOTIFY                 = "${var.iam_policy_violations_should_notify ? "true" : "false"}",
    IAM_POLICY_VIOLATIONS_SLACK_WEBHOOK                 = "${var.iam_policy_violations_slack_webhook}",
    GROUPS_VIOLATIONS_SHOULD_NOTIFY                     = "${var.groups_violations_should_notify ? "true" : "false"}",
    FORWARDING_RULE_VIOLATIONS_SHOULD_NOTIFY            = "${var.forwarding_rule_violations_should_notify ? "true" : "false"}",
    FIREWALL_RULE_VIOLATIONS_SHOULD_NOTIFY              = "${var.firewall_rule_violations_should_notify ? "true" : "false"}",
    EXTERNAL_PROJECT_ACCESS_VIOLATIONS_SHOULD_NOTIFY    = "${var.external_project_access_violations_should_notify ? "true" : "false"}",
    ENABLED_APIS_VIOLATIONS_SHOULD_NOTIFY               = "${var.enabled_apis_violations_should_notify ? "true" : "false"}",
    CSCC_VIOLATIONS_ENABLED                             = "${var.cscc_violations_enabled ? "true" : "false"}",
    CSCC_SOURCE_ID                                      = "${var.cscc_source_id}",
    CLOUDSQL_ACL_VIOLATIONS_SHOULD_NOTIFY               = "${var.cloudsql_acl_violations_should_notify ? "true" : "false"}",
    BUCKETS_ACL_VIOLATIONS_SHOULD_NOTIFY                = "${var.buckets_acl_violations_should_notify ? "true" : "false"}",
    BLACKLIST_VIOLATIONS_SHOULD_NOTIFY                  = "${var.blacklist_violations_should_notify ? "true" : "false"}",
    BIGQUERY_ACL_VIOLATIONS_SHOULD_NOTIFY               = "${var.bigquery_acl_violations_should_notify ? "true" : "false"}",
    AUDIT_LOGGING_VIOLATIONS_SHOULD_NOTIFY              = "${var.audit_logging_violations_should_notify ? "true" : "false"}"
  }
}

#-------------------------#
# Forseti Service Account #
#-------------------------#
resource "google_service_account" "forseti_server" {
  account_id   = "${local.server_sa_name}"
  project      = "${var.project_id}"
  display_name = "Forseti Server Service Account"
}

resource "google_project_iam_member" "server_roles" {
  count   = "${length(local.server_project_roles)}"
  role    = "${local.server_project_roles[count.index]}"
  project = "${var.project_id}"
  member  = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_organization_iam_member" "org_read" {
  count  = "${var.org_id != "" ? length(local.server_read_roles) : 0}"
  role   = "${local.server_read_roles[count.index]}"
  org_id = "${var.org_id}"
  member = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_folder_iam_member" "folder_read" {
  count  = "${var.folder_id != "" ? length(local.server_read_roles) : 0}"
  role   = "${local.server_read_roles[count.index]}"
  folder = "${var.folder_id}"
  member = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_organization_iam_member" "org_write" {
  count  = "${var.org_id != "" && var.enable_write ? length(local.server_write_roles) : 0}"
  role   = "${local.server_write_roles[count.index]}"
  org_id = "${var.org_id}"
  member = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_folder_iam_member" "folder_write" {
  count  = "${var.folder_id != "" && var.enable_write ? length(local.server_write_roles) : 0}"
  role   = "${local.server_write_roles[count.index]}"
  folder = "${var.folder_id}"
  member = "serviceAccount:${google_service_account.forseti_server.email}"
}

#------------------------#
# Forseti Firewall Rules #
#------------------------#
resource "google_compute_firewall" "forseti-server-deny-all" {
  name                    = "forseti-server-deny-all-${local.random_hash}"
  project                 = "${local.network_project}"
  network                 = "${var.network}"
  target_service_accounts = ["${google_service_account.forseti_server.email}"]
  source_ranges           = ["0.0.0.0/0"]
  priority                = "200"

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "udp"
  }

  deny {
    protocol = "tcp"
  }

  depends_on = ["null_resource.services-dependency"]
}

resource "google_compute_firewall" "forseti-server-ssh-external" {
  name                    = "forseti-server-ssh-external-${local.random_hash}"
  project                 = "${local.network_project}"
  network                 = "${var.network}"
  target_service_accounts = ["${google_service_account.forseti_server.email}"]
  source_ranges           = "${var.server_ssh_allow_ranges}"
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = ["null_resource.services-dependency"]
}

resource "google_compute_firewall" "forseti-server-allow-grpc" {
  name                    = "forseti-server-allow-grpc-${local.random_hash}"
  project                 = "${local.network_project}"
  network                 = "${var.network}"
  target_service_accounts = ["${google_service_account.forseti_server.email}"]
  source_ranges           = "${var.server_grpc_allow_ranges}"
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["50051"]
  }

  depends_on = ["null_resource.services-dependency"]
}

#------------------------#
# Forseti Storage bucket #
#------------------------#
resource "google_storage_bucket" "server_config" {
  name          = "${local.server_bucket_name}"
  location      = "${var.storage_bucket_location}"
  project       = "${var.project_id}"
  force_destroy = "true"

  depends_on = ["null_resource.services-dependency"]
}

resource "google_storage_bucket_object" "forseti_server_config" {
  name    = "configs/forseti_conf_server.yaml"
  bucket  = "${google_storage_bucket.server_config.name}"
  content = "${data.template_file.forseti_server_config.rendered}"
}

module "server_rules" {
  source = "../rules"
  bucket = "${google_storage_bucket.server_config.name}"
  org_id = "${var.org_id}"
  domain = "${var.domain}"
}

resource "google_storage_bucket" "cai_export" {
  count         = "${var.enable_cai_bucket ? 1 : 0}"
  name          = "${local.storage_cai_bucket_name}"
  location      = "${var.bucket_cai_location}"
  project       = "${var.project_id}"
  force_destroy = "true"

  lifecycle_rule = {
    action = {
      type = "Delete"
    }

    condition = {
      age = "${var.bucket_cai_lifecycle_age}"
    }
  }

  depends_on = ["null_resource.services-dependency"]
}

#-------------------------#
# Forseti server instance #
#-------------------------#
resource "google_compute_instance" "forseti-server" {
  name = "${local.server_name}"
  zone = "${local.server_zone}"

  project                   = "${var.project_id}"
  machine_type              = "${var.server_type}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.server_boot_image}"
    }
  }

  network_interface {
    subnetwork_project = "${local.network_project}"
    subnetwork         = "${var.subnetwork}"

    access_config {}
  }

  metadata = "${var.server_instance_metadata}"

  metadata_startup_script = "${data.template_file.forseti_server_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.forseti_server.email}"
    scopes = ["cloud-platform"]
  }

  depends_on = [
    "google_service_account.forseti_server",
    "module.server_rules",
    "null_resource.services-dependency",
  ]
}

#----------------------#
# Forseti SQL database #
#----------------------#
resource "google_sql_database_instance" "master" {
  name             = "${local.cloudsql_name}"
  project          = "${var.project_id}"
  region           = "${var.cloudsql_region}"
  database_version = "MYSQL_5_7"

  settings = {
    tier              = "${var.cloudsql_type}"
    activation_policy = "ALWAYS"
    disk_size         = "25"
    disk_type         = "PD_SSD"

    backup_configuration = {
      enabled            = true
      binary_log_enabled = true
    }

    ip_configuration = {
      ipv4_enabled        = true
      authorized_networks = []
      require_ssl         = true
    }
  }

  depends_on = ["null_resource.services-dependency"]
}

resource "google_sql_database" "forseti-db" {
  name     = "forseti_security"
  project  = "${var.project_id}"
  instance = "${google_sql_database_instance.master.name}"
}

resource "google_sql_user" "root" {
  name     = "root"
  host     = "${google_compute_instance.forseti-server.network_interface.0.network_ip}"
  instance = "${google_sql_database_instance.master.name}"
  project  = "${var.project_id}"
}

resource "null_resource" "services-dependency" {
  triggers {
    services = "${jsonencode(var.services)}"
  }
}
