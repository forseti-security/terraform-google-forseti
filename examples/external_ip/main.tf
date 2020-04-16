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

provider "google" {
  credentials = file(var.credentials_path)
  version     = "~> 3.7"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "google_compute_address" "forseti_client_ip" {
  name         = "forseti-client-ip"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
}

resource "google_compute_address" "forseti_server_ip" {
  name         = "forseti-server-ip"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
}

module "forseti-install-simple" {
  source                   = "../../"
  project_id               = var.project_id
  gsuite_admin_email       = var.gsuite_admin_email
  org_id                   = var.org_id
  domain                   = var.domain
  client_instance_metadata = var.instance_metadata
  server_instance_metadata = var.instance_metadata
  client_tags              = var.instance_tags
  server_tags              = var.instance_tags
  client_private           = false # enable client public IP
  server_private           = false # enable server public IP

  # These optional blocks allow to override the default `access_config` block
  # (empty by default) for the client and server VMs.
  # This allows e.g: to customize the external IPs or assign DNS names to the
  # VMs.
  # If those blocks are omitted, external IPs will be automatically created
  # and assigned to the VMs.
  client_access_config = {
    nat_ip = google_compute_address.forseti_client_ip.address
  }

  server_access_config = {
    nat_ip                 = google_compute_address.forseti_server_ip.address
    public_ptr_domain_name = var.public_ptr_domain_name
  }
}

