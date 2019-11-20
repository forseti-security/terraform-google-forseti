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

module "bastion" {
  source = "../bastion"

  network    = var.network
  project_id = var.project_id
  subnetwork = var.subnetwork
  zone       = data.google_compute_zones.main.names[0]
  key_suffix = "_simple_example"
}

module "forseti-install-simple" {
  source = "../../../examples/simple_example"

  gsuite_admin_email = var.gsuite_admin_email
  project_id         = var.project_id
  org_id             = var.org_id
  domain             = var.domain
  region             = var.region
  network            = var.network
  subnetwork         = var.subnetwork
  forseti_version    = var.forseti_version

  instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

resource "null_resource" "ssh_server_iap_tunnel" {
  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command =  "nohup gcloud compute start-iap-tunnel ${module.forseti-install-simple.forseti-server-vm-name} 22 --local-host-port=localhost:2222 &",
  }

  depends_on = [
    module.forseti-install-simple.forseti-server-vm-ip
  ]
}

resource "null_resource" "ssh_client_iap_tunnel" {
  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = "nohup gcloud compute start-iap-tunnel ${module.forseti-install-simple.forseti-client-vm-name} 22 --local-host-port=localhost:2223 &",
  }

  depends_on = [
    module.forseti-install-simple.forseti-client-vm-ip
  ]
}

resource "null_resource" "wait_for_server" {
  triggers = {
    always_run = uuid()
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/wait-for-forseti.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = "localhost"
      port                = 2222
      private_key         = tls_private_key.main.private_key_pem
    }
  }

  depends_on = [
    null_resource.ssh_server_iap_tunnel,
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
      host                = "localhost"
      port                = 2223
      private_key         = tls_private_key.main.private_key_pem
    }
  }

  depends_on = [
    null_resource.ssh_client_iap_tunnel,
  ]
}
