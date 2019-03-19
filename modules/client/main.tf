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
  client_startup_script = "${file("${path.module}/templates/scripts/forseti-client/forseti_client_startup_script.sh.tpl")}"
  client_env_script     = "${file("${path.module}/templates/scripts/forseti-client/forseti_environment.sh.tpl")}"
  client_conf           = "${file("${path.module}/templates/configs/forseti_conf_client.yaml.tpl")}"
  client_conf_path      = "${var.forseti_home}/configs/forseti_conf_client.yaml"
  client_sa_name        = "forseti-client-gcp-${var.suffix}"
  client_name           = "forseti-client-vm-${var.suffix}"
  client_bucket_name    = "forseti-client-${var.suffix}"
  client_zone           = "${var.client_region}-c"

  client_project_roles = [
    "roles/storage.objectViewer",
    "roles/cloudtrace.agent",
  ]

  network_project = "${var.network_project != "" ? var.network_project : var.project_id}"

  network_interface_base = {
    private = [{
      subnetwork_project = "${local.network_project}"
      subnetwork         = "${var.subnetwork}"
    }]

    public = [{
      subnetwork_project = "${local.network_project}"
      subnetwork         = "${var.subnetwork}"
      access_config      = ["${var.client_access_config}"]
    }]
  }

  network_interface = "${local.network_interface_base[var.client_private ? "private" : "public"]}"
}

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
    forseti_server_ip = "${var.server_address}"
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
  tags                      = "${var.client_tags}"
  allow_stopping_for_update = true
  metadata                  = "${var.client_instance_metadata}"
  metadata_startup_script   = "${data.template_file.forseti_client_startup_script.rendered}"
  network_interface         = ["${local.network_interface}"]

  boot_disk {
    initialize_params {
      image = "${var.client_boot_image}"
    }
  }

  service_account {
    email  = "${google_service_account.forseti_client.email}"
    scopes = ["cloud-platform"]
  }

  depends_on = [
    "null_resource.services-dependency",
    "google_storage_bucket_object.forseti_client_config",
  ]
}

#------------------------#
# Forseti firewall rules #
#------------------------#
resource "google_compute_firewall" "forseti-client-deny-all" {
  name                    = "forseti-client-deny-all-${var.suffix}"
  project                 = "${var.network_project}"
  network                 = "${var.network}"
  target_service_accounts = ["${google_service_account.forseti_client.email}"]
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

resource "google_compute_firewall" "forseti-client-ssh-external" {
  name                    = "forseti-client-ssh-external-${var.suffix}"
  project                 = "${var.network_project}"
  network                 = "${var.network}"
  target_service_accounts = ["${google_service_account.forseti_client.email}"]
  source_ranges           = "${var.client_ssh_allow_ranges}"
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = ["null_resource.services-dependency"]
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
  display_name = "Forseti Client Service Account"
}

#------------------------#
# Forseti storage bucket #
#------------------------#
resource "google_storage_bucket" "client_config" {
  name          = "${local.client_bucket_name}"
  location      = "${var.storage_bucket_location}"
  project       = "${var.project_id}"
  force_destroy = "true"

  depends_on = ["null_resource.services-dependency"]
}

resource "google_storage_bucket_object" "forseti_client_config" {
  name    = "configs/forseti_conf_client.yaml"
  bucket  = "${google_storage_bucket.client_config.name}"
  content = "${data.template_file.forseti_client_config.rendered}"
}

resource "null_resource" "services-dependency" {
  triggers {
    services = "${jsonencode(var.services)}"
  }
}
