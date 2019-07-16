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
  version     = "~> 2.7"
}

provider "local" {
  version = "~> 1.3"
}

provider "null" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

provider "random" {
  version = "~> 2.0"
}

locals {
  # Fix for https://github.com/terraform-providers/terraform-provider-google/issues/3987
  network = "default"
}

resource "random_pet" "main" {
  length    = "1"
  prefix    = "forseti-simple-example"
  separator = "-"
}

resource "google_compute_router" "main" {
  name    = random_pet.main.id
  network = local.network

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = var.project_id
}

data "google_compute_subnetwork" "main" {
  name    = "default"
  project = var.project_id
  region  = google_compute_router.main.region
}

resource "google_compute_router_nat" "main" {
  name                               = random_pet.main.id
  router                             = google_compute_router.main.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = data.google_compute_subnetwork.main.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = var.project_id
  region  = google_compute_router.main.region
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
  client_private           = var.private
  server_private           = var.private
  server_region            = google_compute_router_nat.main.region
  client_region            = google_compute_router_nat.main.region
  network                  = local.network
  subnetwork               = data.google_compute_subnetwork.main.name
  sendgrid_api_key         = var.sendgrid_api_key
  forseti_email_sender     = var.forseti_email_sender
  forseti_email_recipient  = var.forseti_email_recipient
}

