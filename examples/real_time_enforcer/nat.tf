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

resource "random_pet" "main" {
  length    = "1"
  prefix    = "forseti-simple-example"
  separator = "-"
}

resource "google_compute_router" "main" {
  name    = "${random_pet.main.id}"
  network = "default"

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = "${var.project_id}"
}

data "google_compute_subnetwork" "main" {
  name    = "default"
  project = "${var.project_id}"
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

  project = "${var.project_id}"
  region  = "${google_compute_router.main.region}"
}
