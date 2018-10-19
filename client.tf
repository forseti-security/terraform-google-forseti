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

locals {
  client_startup_script = "${file("${path.module}/scripts/forseti-client/forseti_client_startup_script.sh")}"
  client_env_script     = "${file("${path.module}/scripts/forseti-client/forseti_environment.sh")}"
  client_conf           = "${file("${path.module}/configs/forseti_conf_client.yaml")}"
  client_conf_path      = "${var.forseti_home}/configs/forseti_conf_client.yaml"
  client_sa_name        = "forseti-client-gcp-${local.random_hash}"
  client_name           = "forseti-client-vm-${local.random_hash}"
  client_zone           = "${var.client_region}-c"
}

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_client_startup_script" {
  template = "${local.client_startup_script}"

  vars {
    forseti_environment = "${data.template_file.forseti_client_environment.rendered}"
    forseti_repo_url    = "${var.forseti_repo_url}"
    forseti_version     = "${var.forseti_version}"
    forseti_home        = "${var.forseti_home}"
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
    forseti_server_ip = "${google_compute_instance.forseti-server.network_interface.0.access_config.0.assigned_nat_ip}"
  }
}

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
    subnetwork_project = "${var.project_id}"
    subnetwork         = "${var.vpc_host_subnetwork}"

    access_config {}
  }

  metadata_startup_script = "${data.template_file.forseti_client_startup_script.rendered}"

  service_account {
    email  = "${google_service_account.forseti_client.email}"
    scopes = ["cloud-platform"]
  }

  labels {
    goog-dm = "${local.client_name}"
  }

  depends_on = [
    "google_service_account.forseti_server",
    "google_project_service.activate_services",
  ]
}

#-------------------------#
# Forseti Service Account #
#-------------------------#
resource "google_service_account" "forseti_client" {
  account_id   = "${local.client_sa_name}"
  project      = "${var.project_id}"
  display_name = "Forseti Server Service Account"
}

#------------------------#
# Forseti Storage bucket #
#------------------------#
resource "google_storage_bucket" "client_config" {
  name          = "forseti-client-${local.random_hash}"
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
