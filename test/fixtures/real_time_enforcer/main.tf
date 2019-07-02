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

provider "tls" {
  version = "~> 1.2"
}

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/sshkey"
}

module "bastion" {
  source = "../bastion"

  network    = "default"
  project_id = "${var.project_id}"
  subnetwork = "default"
  zone       = "us-central1-f"
}

module "real_time_enforcer" {
  source = "../../../examples/real_time_enforcer"

  project_id          = var.project_id
  org_id              = var.org_id
  enforcer_project_id = var.enforcer_project_id

  instance_metadata = {
    # This username is a little bit silly because the enforcer VM is COS, but for
    # the sake of consistency with the Forseti client and server we use the same
    # hostname.
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}
