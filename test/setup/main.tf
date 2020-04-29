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

resource "random_string" "project_suffix" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

# Temporarily disabled due to issue #285
#module "forseti-enforcer-project" {
#  source  = "terraform-google-modules/project-factory/google"
#  version = "~> 3.0"
#
#  name              = "ci-forseti-enforcer"
#  random_project_id = true
#  org_id            = var.org_id
#  folder_id         = var.folder_id
#  billing_account   = var.billing_account
#
#  activate_apis = [
#    "compute.googleapis.com",
#    "storage-api.googleapis.com",
#    "storage-component.googleapis.com",
#    "pubsub.googleapis.com",
#    "logging.googleapis.com",
#    "monitoring.googleapis.com",
#  ]
#}

module "forseti-host-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 3.0"

  name            = "ci-forseti-host-project"
  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  project_id      = "ci-forseti-host-${random_string.project_suffix.result}"

  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "pubsub.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
}

module "forseti-service-project" {
  source          = "terraform-google-modules/project-factory/google//modules/shared_vpc"
  version         = "~> 3.0"
  org_id          = var.org_id
  folder_id       = var.folder_id
  billing_account = var.billing_account
  name            = "ci-forseti-serv"
  project_id      = "ci-forseti-serv-${random_string.project_suffix.result}"

  activate_apis = [
    "compute.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
    "pubsub.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
  ]
  shared_vpc = module.forseti-host-project.project_id
}

// Define a shared VPC network within the Forseti host project.
module "forseti-host-network" {
  source  = "terraform-google-modules/network/google"
  version = "1.1.0"

  project_id   = module.forseti-host-project.project_id
  network_name = "forseti-network"

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
  network = module.forseti-host-network.network_self_link

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
    name                    = module.forseti-host-network.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = module.forseti-host-project.project_id
  region  = google_compute_router.forseti_host.region
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
