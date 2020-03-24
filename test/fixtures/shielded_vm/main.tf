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

module "shielded-vm" {
  source = "../../.."

  project_id       = var.project_id
  org_id           = var.org_id
  domain           = var.domain
  network          = var.network
  subnetwork       = var.subnetwork
  server_private   = true
  client_private   = true
  cloudsql_private = true
  forseti_version  = var.forseti_version

  // using shielded VM image for both client and server VMs
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
