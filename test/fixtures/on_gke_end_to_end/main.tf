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

resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "gce-keypair-pk" {
  content  = tls_private_key.main.private_key_pem
  filename = "${path.module}/sshkey"
}

#-------------------------#
# Forseti
#-------------------------#
module "forseti" {
  source = "../../../examples/on_gke_end_to_end"

  # Forseti
  config_validator_enabled = var.config_validator_enabled
  domain                   = var.domain
  gsuite_admin_email       = var.gsuite_admin_email

  # Forseti Client
  client_instance_metadata = {
    sshKeys = "ubuntu:${tls_private_key.main.public_key_openssh}"
  }

  # GCP
  org_id     = var.org_id
  project_id = var.gke_project_id

  # GKE
  k8s_forseti_orchestrator_image_tag = var.k8s_forseti_orchestrator_image_tag
  k8s_forseti_server_image_tag       = var.k8s_forseti_server_image_tag
  network_description                = var.network_description
}
