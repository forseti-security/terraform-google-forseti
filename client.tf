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

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_client_startup_script" {
  template = "${local.client_startup_script}"

  vars {
    forseti_environment      = "${data.template_file.forseti_client_environment.rendered}"
    forseti_repo_url         = "${var.forseti_repo_url}"
    forseti_version          = "${var.forseti_version}"
    forseti_home             = "${var.forseti_home}"
    forseti_client_conf_path = "${local.client_conf_path}"
    storage_bucket_name      = "${local.client_bucket_name}"
  }
}

data "template_file" "forseti_client_environment" {
  template = "${local.client_env_script}"

  vars {
    forseti_home             = "${var.forseti_home}"
    forseti_client_conf_path = "${local.client_conf_path}"
  }
}

data "template_file" "forseti_client_config" {
  template = "${local.client_conf}"

  vars {
    forseti_server_ip = "${google_compute_instance.forseti-server.network_interface.0.network_ip}"
  }
}

#-------------------#
# Forseti client VM #
#-------------------#
resource "google_compute_instance" "forseti-client" {
  name                      = "${local.client_name}"
  zone                      = "${local.client_zone}"
  project                   = "${var.project_id}"
  machine_type              = "${var.client_type}"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${var.client_boot_image}"
    }
  }

  network_interface {
    subnetwork_project = "${local.network_project}"
    subnetwork         = "${var.subnetwork}"

    access_config {}
  }

  metadata_startup_script = "${data.template_file.forseti_client_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.forseti_client.email}"
    scopes = ["cloud-platform"]
  }

  depends_on = [
    "google_service_account.forseti_server",
    "google_project_service.main",
  ]
}

#----------------------#
# Forseti client roles #
#----------------------#
resource "google_project_iam_member" "client_roles" {
  count   = "${length(local.client_project_roles)}"
  role    = "${local.client_project_roles[count.index]}"
  project = "${var.project_id}"
  member  = "serviceAccount:${google_service_account.forseti_client.email}"
}

#-------------------------#
# Forseti service Account #
#-------------------------#
resource "google_service_account" "forseti_client" {
  account_id   = "${local.client_sa_name}"
  project      = "${var.project_id}"
  display_name = "Forseti Server Service Account"
}

#------------------------#
# Forseti storage bucket #
#------------------------#
resource "google_storage_bucket" "client_config" {
  name          = "${local.client_bucket_name}"
  location      = "${var.storage_bucket_location}"
  project       = "${var.project_id}"
  force_destroy = "true"
}

resource "google_storage_bucket_object" "forseti_client_config" {
  name       = "configs/forseti_conf_client.yaml"
  bucket     = "${google_storage_bucket.client_config.name}"
  content    = "${data.template_file.forseti_client_config.rendered}"
  depends_on = ["google_compute_instance.forseti-client"]
}
