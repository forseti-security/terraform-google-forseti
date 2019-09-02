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
 * limitations under the License.``
 */


// Define a host project for the Forseti shared VPC test suite.

module "forseti-host-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name            = "ci-forseti-host-project"
  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  project_id      = "ci-forseti-host-project-${var.project_suffix}"

  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "pubsub.googleapis.com",
    "oslogin.googleapis.com",
  ]
}

// Define a shared VPC network within the Forseti host project.
module "forseti-host-network-01" {
  source  = "terraform-google-modules/network/google"
  version = "1.1.0"

  project_id      = "ci-forseti-service-${var.project_suffix}"
  network_name    = "forseti-network"
  shared_vpc_host = true

  secondary_ranges = {
    forseti-subnetwork = []
  }

  subnets = [
    {
      subnet_name   = "forseti-subnetwork"
      subnet_ip     = "10.128.0.0/20"
      subnet_region = "us-central1"
    },
  ]
}

resource "google_compute_router" "forseti_host" {
  name    = "forseti-host"
  network = module.forseti-host-network-01.network_self_link

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = module.forseti-host-project.project_id
}

resource "google_compute_router_nat" "forseti_host" {
  name                               = "forseti-host"
  router                             = google_compute_router.forseti_host.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = module.forseti-host-network-01.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = module.forseti-host-project.project_id
  region  = google_compute_router.forseti_host.region
}

module "forseti-service-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  name            = "ci-forseti-service"
  project_id      = "ci-forseti-service-${var.project_suffix}"

  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ]
  shared_vpc         = "ci-forseti-host-project-${var.project_suffix}"
  shared_vpc_subnets = ["projects/ci-forseti-host-project-${var.project_suffix}/regions/us-central1/subnetworks/forseti-subnetwork"]
}

module "forseti-service-network" {
  source  = "terraform-google-modules/network/google"
  version = "1.1.0"

  network_name = "forseti-network"
  project_id   = module.forseti-service-project.project_id

  secondary_ranges = {
    forseti-subnetwork = []
  }

  subnets = [
    {
      subnet_name   = "forseti-subnetwork"
      subnet_ip     = "10.129.0.0/20"
      subnet_region = "us-central1"
    },
  ]
}

resource "google_compute_router" "forseti_service" {
  name    = "forseti-service"
  network = module.forseti-service-network.network_self_link

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = module.forseti-service-project.project_id
}

resource "google_compute_router_nat" "forseti_service" {
  name                               = "forseti-service"
  router                             = google_compute_router.forseti_service.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = module.forseti-service-network.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = module.forseti-service-project.project_id
  region  = google_compute_router.forseti_service.region
}


module "forseti-enforcer-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name = "ci-forseti-enforcer"

  project_id      = "ci-forseti-enforcer-${var.project_suffix}"
  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account

  activate_apis = [
    "compute.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "pubsub.googleapis.com",
  ]
}

