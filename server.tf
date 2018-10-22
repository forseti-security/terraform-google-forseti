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

#------------------------------#
# Random string for deployment #
#------------------------------#
resource "random_id" "random_project_id_suffix" {
  byte_length = 4
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
    storage_bucket_name      = "${local.storage_bucket_name}"
  }
}

data "template_file" "forseti_server_environment" {
  template = "${local.server_environment}"

  vars {
    forseti_home             = "${var.forseti_home}"
    forseti_server_conf_path = "${local.server_conf_path}"
    storage_bucket_name      = "${local.storage_bucket_name}"
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

  vars {
    root_resource_id        = "${local.root_resource_id}"
    gsuite_admin_email      = "${var.gsuite_admin_email}"
    forseti_email_sender    = "${var.forseti_email_sender}"
    forseti_email_recipient = "${var.forseti_email_recipient}"
    storage_bucket_name     = "${local.storage_bucket_name}"
    sendgrid_api_key        = "${var.sendgrid_api_key}"
  }
}

#-------------------#
# Activate services #
#-------------------#
resource "google_project_service" "activate_services" {
  count              = "${length(local.services_list)}"
  project            = "${var.project_id}"
  service            = "${element(local.services_list, count.index)}"
  disable_on_destroy = "false"
}

#-------------------------#
# Forseti Service Account #
#-------------------------#
resource "google_service_account" "forseti_server" {
  account_id   = "${local.server_sa_name}"
  project      = "${var.project_id}"
  display_name = "Forseti Server Service Account"
}

resource "google_project_iam_member" "project" {
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

resource "google_organization_iam_member" "folder_read" {
  count     = "${var.folder_id != "" ? length(local.server_read_roles) : 0}"
  role      = "${local.server_read_roles[count.index]}"
  folder_id = "${var.folder_id}"
  member    = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_organization_iam_member" "org_write" {
  count  = "${var.org_id != "" && var.enable_write ? length(local.server_write_roles) : 0}"
  role   = "${local.server_write_roles[count.index]}"
  org_id = "${var.org_id}"
  member = "serviceAccount:${google_service_account.forseti_server.email}"
}

resource "google_organization_iam_member" "folder_write" {
  count     = "${var.folder_id != "" && var.enable_write ? length(local.server_write_roles) : 0}"
  role      = "${local.server_write_roles[count.index]}"
  folder_id = "${var.folder_id}"
  member    = "serviceAccount:${google_service_account.forseti_server.email}"
}

/*******************************************
  Forseti Firewall Rules
 *******************************************/
resource "google_compute_firewall" "forseti-server-deny-all" {
  name                    = "forseti-server-deny-all-${local.random_hash}"
  project                 = "${var.project_id}"
  network                 = "${var.vpc_host_network}"
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
}

resource "google_compute_firewall" "forseti-server-ssh-external" {
  name                    = "forseti-server-ssh-external-${local.random_hash}"
  project                 = "${var.project_id}"
  network                 = "${var.vpc_host_network}"
  target_service_accounts = ["${google_service_account.forseti_server.email}"]
  source_ranges           = ["0.0.0.0/0"]
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "forseti-server-allow-grpc" {
  name                    = "forseti-server-allow-grpc-${local.random_hash}"
  project                 = "${var.project_id}"
  network                 = "${var.vpc_host_network}"
  target_service_accounts = ["${google_service_account.forseti_server.email}"]
  source_ranges           = ["10.128.0.0/9"]
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["50051"]
  }
}

#------------------------#
# Forseti Storage bucket #
#------------------------#
resource "google_storage_bucket" "server_config" {
  name          = "forseti-server-${local.random_hash}"
  location      = "${var.storage_bucket_location}"
  project       = "${var.project_id}"
  force_destroy = "true"
}

resource "google_storage_bucket_object" "forseti_server_config" {
  name    = "configs/forseti_conf_server.yaml"
  bucket  = "${google_storage_bucket.server_config.name}"
  content = "${data.template_file.forseti_server_config.rendered}"
}

resource "google_storage_bucket" "cai_export" {
  count    = "${var.enable_cai_bucket == "true" ? 1 : 0}"
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
}

#-------------------------#
# Forseti server instance #
#-------------------------#
resource "google_compute_instance" "forseti-server" {
  name                      = "${local.server_name}"
  zone                      = "${local.server_zone}"
  project                   = "${var.project_id}"
  machine_type              = "${var.server_type}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.server_boot_image}"
    }
  }

  network_interface {
    subnetwork_project = "${var.project_id}"
    subnetwork         = "${var.vpc_host_subnetwork}"

    access_config {}
  }

  metadata_startup_script = "${data.template_file.forseti_server_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.forseti_server.email}"
    scopes = ["cloud-platform"]
  }

  labels {
    goog-dm = "${local.server_name}"
  }

  depends_on = [
    "google_service_account.forseti_server",
    "google_project_service.activate_services",
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

  depends_on = [
    "google_project_service.activate_services",
  ]
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
