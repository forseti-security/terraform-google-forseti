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

provider "tls" {
  version = "~> 2.0"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/sshkey"
}

data "google_compute_zones" "main" {
  project = var.project_id
  region  = var.region
  status  = "UP"
}

#-------------------------#
# Bastion Host
#-------------------------#
module "bastion" {
  source = "../bastion"

  network    = var.network
  project_id = var.project_id
  subnetwork = var.subnetwork
  zone       = data.google_compute_zones.main.names[0]
  key_suffix = "_install_simple"
}

#-------------------------#
# Forseti
#-------------------------#
// using default unshielded VM image for both client and server VMs
module "unshielded-vm" {
  source = "../../.."

  gsuite_admin_email      = var.gsuite_admin_email
  project_id              = var.project_id
  org_id                  = var.org_id
  domain                  = var.domain
  network                 = var.network
  subnetwork              = var.subnetwork
  forseti_version         = var.forseti_version
  server_region           = var.region
  client_region           = var.region
  cloudsql_region         = var.region
  storage_bucket_location = var.region
  bucket_cai_location     = var.region
  client_instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
  server_instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

// using shielded VM image for both client and server VMs
module "shielded-vm" {
  source = "../../.."

  gsuite_admin_email      = var.gsuite_admin_email
  project_id              = var.project_id
  org_id                  = var.org_id
  domain                  = var.domain
  network                 = var.network
  subnetwork              = var.subnetwork
  forseti_version         = var.forseti_version
  server_region           = var.region
  client_region           = var.region
  cloudsql_region         = var.region
  storage_bucket_location = var.region
  bucket_cai_location     = var.region
  client_instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
  server_instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }

  server_boot_image = "gce-uefi-images/ubuntu-1804-lts"
  client_boot_image = "gce-uefi-images/ubuntu-1804-lts"
  server_shielded_instance_config = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  client_shielded_instance_config = {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

resource "google_compute_firewall" "forseti_bastion_to_unshielded_vm" {
  name    = "forseti-bastion-to-vm-ssh-${module.unshielded-vm.suffix}"
  project = var.project_id
  network = var.network
  target_service_accounts = [module.unshielded-vm.forseti-server-service-account,
  module.unshielded-vm.forseti-client-service-account]

  source_ranges = ["${module.bastion.host-private-ip}/32"]
  direction     = "INGRESS"
  priority      = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "forseti_bastion_to_shielded_vm" {
  name    = "forseti-bastion-to-vm-ssh-${module.shielded-vm.suffix}"
  project = var.project_id
  network = var.network
  target_service_accounts = [module.shielded-vm.forseti-server-service-account,
  module.shielded-vm.forseti-client-service-account]

  source_ranges = ["${module.bastion.host-private-ip}/32"]
  direction     = "INGRESS"
  priority      = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
