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
  credentials = "${file(var.credentials_path)}"
  version     = "~> 1.20"
}

provider "google-beta" {
  credentials = "${file(var.credentials_path)}"
  version     = "~> 1.20"
}

provider "local" {
  version = "~> 1.2"
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

resource "random_pet" "main" {
  length    = "1"
  prefix    = "forseti-simple-example"
  separator = "-"
}

resource "google_compute_router" "main" {
  name    = "${random_pet.main.id}"
  network = "${var.network}"

  bgp {
    asn = "64514"
  }

  region  = "${var.region}"
  project = "${var.network_project}"
}

data "google_compute_subnetwork" "main" {
  name    = "${var.subnetwork}"
  project = "${google_compute_router.main.project}"
  region  = "${google_compute_router.main.region}"
}

resource "google_compute_router_nat" "main" {
  name                               = "${random_pet.main.id}"
  router                             = "${google_compute_router.main.name}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "${data.google_compute_subnetwork.main.self_link}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = "${var.network_project}"
  region  = "${google_compute_router.main.region}"
}

module "forseti" {
  source                   = "../../"
  project_id               = "${var.project_id}"
  client_region            = "${google_compute_router_nat.main.region}"
  gsuite_admin_email       = "${var.gsuite_admin_email}"
  network                  = "${google_compute_router.main.network}"
  subnetwork               = "${data.google_compute_subnetwork.main.self_link}"
  network_project          = "${google_compute_router_nat.main.project}"
  org_id                   = "${var.org_id}"
  server_region            = "${google_compute_router_nat.main.region}"
  domain                   = "${var.domain}"
  client_instance_metadata = "${var.instance_metadata}"
  server_instance_metadata = "${var.instance_metadata}"
  client_private           = "true"
  server_private           = "true"
}
