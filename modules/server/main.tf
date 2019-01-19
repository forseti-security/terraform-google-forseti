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

  services_list = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudtrace.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "logging.googleapis.com",
  ]

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
    "roles/browser",
    "roles/cloudasset.viewer",
    "roles/cloudsql.viewer",
    "roles/compute.networkViewer",
    "roles/iam.securityReviewer",
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
    forseti_environment      = "${data.template_file.forseti_server_environment.rendered}"
    forseti_env              = "${data.template_file.forseti_server_env.rendered}"
    forseti_run_frequency    = "${var.forseti_run_frequency}"
    forseti_repo_url         = "${var.forseti_repo_url}"
    forseti_version          = "${var.forseti_version}"
    forseti_server_conf_path = "${local.server_conf_path}"
    forseti_home             = "${var.forseti_home}"
    cloudsql_proxy_arch      = "${var.cloudsql_proxy_arch}"
    storage_bucket_name      = "${local.server_bucket_name}"
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
    ROOT_RESOURCE_ID         = "${local.root_resource_id}"
    DOMAIN_SUPER_ADMIN_EMAIL = "${var.gsuite_admin_email}"
    CAI_ENABLED              = "${var.enable_cai_bucket}"
    FORSETI_CAI_BUCKET       = "${google_storage_bucket.cai_export.name}"
    FORSETI_BUCKET           = "${local.server_bucket_name}"
    SENDGRID_API_KEY         = "${var.sendgrid_api_key}"
    EMAIL_SENDER             = "${var.forseti_email_sender}"
    EMAIL_RECIPIENT          = "${var.forseti_email_recipient}"
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
  source_ranges           = ["0.0.0.0/0"]
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
  source_ranges           = ["10.128.0.0/9"]
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
  count    = "${var.enable_cai_bucket ? 1 : 0}"
  name     = "${local.storage_cai_bucket_name}"
  location = "${var.bucket_cai_location}"
  project  = "${var.project_id}"

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
  instance = "${google_sql_database_instance.master.name}"
  project  = "${var.project_id}"
}

resource "null_resource" "services-dependency" {
  triggers {
    services = "${jsonencode(var.services)}"
  }
}
