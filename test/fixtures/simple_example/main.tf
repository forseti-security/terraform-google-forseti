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

provider "google" {
  version = "~> 2.8.0"
}

provider "google-beta" {
  version = "~> 2.8.0"
}

provider "local" {
  version = "~> 1.2"
}

provider "null" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.1"
}

module "project" {
  source = "../project"

  providers {
    google      = "google"
    google-beta = "google-beta"
  }

  billing_account = "${var.billing_account}"
  folder_id       = "${var.folder_id}"
  org_id          = "${var.org_id}"
}

provider "google" {
  version = "~> 2.8"

  alias = "fixture"

  credentials = "${module.project.service_account_private_key}"
}

provider "google-beta" {
  version = "~> 2.8"

  alias = "fixture"

  credentials = "${module.project.service_account_private_key}"
}

provider "tls" {
  version = "~> 1.2"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = "${tls_private_key.main.private_key_pem}"
  filename = "${path.module}/sshkey"
}

module "bastion" {
  source = "../bastion"

  providers {
    google      = "google.fixture"
    google-beta = "google-beta.fixture"
  }

  network    = "${module.project.network}"
  project_id = "${module.project.project_id}"
  subnetwork = "${module.project.subnetwork}"
  zone       = "${module.project.zone}"
}

module "forseti-install-simple" {
  source = "../../../examples/simple_example"

  providers {
    google      = "google.fixture"
    google-beta = "google-beta.fixture"
  }

  gsuite_admin_email = "${var.gsuite_admin_email}"
  network            = "${module.project.network}"
  project_id         = "${module.project.project_id}"
  region             = "${module.project.region}"
  subnetwork         = "${module.project.subnetwork}"
  org_id             = "${var.org_id}"
  domain             = "${var.domain}"

  instance_metadata {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

resource "null_resource" "wait_for_server" {
  triggers = {
    always_run = "${uuid()}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/wait-for-forseti.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = "${module.forseti-install-simple.forseti-server-vm-ip}"
      private_key         = "${tls_private_key.main.private_key_pem}"
      bastion_host        = "${module.bastion.host}"
      bastion_port        = "${module.bastion.port}"
      bastion_private_key = "${module.bastion.private_key}"
      bastion_user        = "${module.bastion.user}"
    }
  }
}

resource "null_resource" "wait_for_client" {
  triggers = {
    always_run = "${uuid()}"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/wait-for-forseti.sh"

    connection {
      type                = "ssh"
      user                = "ubuntu"
      host                = "${module.forseti-install-simple.forseti-client-vm-ip}"
      private_key         = "${tls_private_key.main.private_key_pem}"
      bastion_host        = "${module.bastion.host}"
      bastion_port        = "${module.bastion.port}"
      bastion_private_key = "${module.bastion.private_key}"
      bastion_user        = "${module.bastion.user}"
    }
  }
}

