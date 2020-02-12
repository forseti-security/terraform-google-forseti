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
}

module "real_time_enforcer" {
  source = "../../../examples/real_time_enforcer"

  project_id          = var.project_id
  org_id              = var.org_id
  enforcer_project_id = var.enforcer_project_id
  region              = var.region
  network             = var.network
  subnetwork          = var.subnetwork

  instance_metadata = {
    # This username is a little bit silly because the enforcer VM is COS, but for
    # the sake of consistency with the Forseti client and server we use the same
    # hostname.
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }
}

