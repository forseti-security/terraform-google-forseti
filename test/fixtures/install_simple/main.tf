/**
 * Copyright 2020 Google LLC
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
  version = "~> 2.1"
}

locals {
  policy_library_files = [
    "policy-library/lib/constraints.rego",
    "policy-library/lib/util_test.rego",
    "policy-library/lib/util.rego",
    "policy-library/policies/constraints/sql_public_ip.yaml",
    "policy-library/policies/templates/gcp_sql_public_ip_v1.yaml"
  ]

  network    = "${var.network}-install-simple"
  subnetwork = "${var.subnetwork}-install-simple"
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

module "forseti-service-network-install-simple" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.1"

  network_name = local.network
  project_id   = var.project_id

  secondary_ranges = {
    forseti-subnetwork-install-simple = []
  }

  subnets = [
    {
      subnet_name   = local.subnetwork
      subnet_ip     = "10.130.0.0/20"
      subnet_region = var.region
    },
  ]
}

#-------------------------#
# Bastion Host
#-------------------------#
module "bastion" {
  source = "../bastion"

  network    = module.forseti-service-network-install-simple.network_self_link
  project_id = var.project_id
  subnetwork = module.forseti-service-network-install-simple.subnets_self_links[0]
  zone       = data.google_compute_zones.main.names[0]
  key_suffix = "_install_simple"
}

#-------------------------#
# Forseti
#-------------------------#
module "forseti-install-simple" {
  source = "../../../examples/install_simple"

  gsuite_admin_email = var.gsuite_admin_email
  project_id         = var.project_id
  org_id             = var.org_id
  domain             = var.domain
  region             = var.region
  network            = module.forseti-service-network-install-simple.network_name
  subnetwork         = module.forseti-service-network-install-simple.subnets_names[0]
  forseti_version    = var.forseti_version

  config_validator_enabled = var.config_validator_enabled

  instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

resource "google_compute_firewall" "forseti_bastion_to_vm" {
  name    = "forseti-bastion-to-vm-ssh-${module.forseti-install-simple.suffix}"
  project = var.project_id
  network = module.forseti-service-network-install-simple.network_self_link
  target_service_accounts = [module.forseti-install-simple.forseti-server-service-account,
  module.forseti-install-simple.forseti-client-service-account]

  source_ranges = ["${module.bastion.host-private-ip}/32"]
  direction     = "INGRESS"
  priority      = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}

#-------------------------#
# Wait for Forseti VMs to be ready for testing
#-------------------------#
resource "null_resource" "wait_for_server" {
  triggers = {
    always_run = uuid()
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/wait-for-forseti.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = module.forseti-install-simple.forseti-server-vm-ip
      private_key         = tls_private_key.main.private_key_pem
      bastion_host        = module.bastion.host
      bastion_port        = module.bastion.port
      bastion_private_key = module.bastion.private_key
      bastion_user        = module.bastion.user
    }
  }
  depends_on = [
    google_compute_firewall.forseti_bastion_to_vm
  ]
}

resource "null_resource" "wait_for_client" {
  triggers = {
    always_run = uuid()
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/wait-for-forseti.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = module.forseti-install-simple.forseti-client-vm-ip
      private_key         = tls_private_key.main.private_key_pem
      bastion_host        = module.bastion.host
      bastion_port        = module.bastion.port
      bastion_private_key = module.bastion.private_key
      bastion_user        = module.bastion.user
    }
  }

  depends_on = [
    google_compute_firewall.forseti_bastion_to_vm
  ]
}

#-------------------------#
# Policy Library
#-------------------------#
data "template_file" "policy_library_files" {
  count = length(local.policy_library_files)
  template = file(
    "${path.module}/${element(local.policy_library_files, count.index)}",
  )
}

resource "google_storage_bucket_object" "main" {
  count   = length(local.policy_library_files)
  name    = element(local.policy_library_files, count.index)
  content = element(data.template_file.policy_library_files.*.rendered, count.index)
  bucket  = module.forseti-install-simple.forseti-server-storage-bucket

  lifecycle {
    ignore_changes = [
      content,
      detect_md5hash,
    ]
  }
}
