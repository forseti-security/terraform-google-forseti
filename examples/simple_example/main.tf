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
  network = "default"

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = "${var.project_id}"
}

module "cloud_nat" {
  source = "github.com/terraform-google-modules/terraform-google-cloud-nat"

  project_id = "${var.project_id}"
  region     = "${google_compute_router.main.region}"
  router     = "${google_compute_router.main.name}"

  name = "${random_pet.main.id}"
}

module "forseti-install-simple" {
  source                   = "../../"
  project_id               = "${var.project_id}"
  gsuite_admin_email       = "${var.gsuite_admin_email}"
  org_id                   = "${var.org_id}"
  domain                   = "${var.domain}"
  client_instance_metadata = "${var.instance_metadata}"
  server_instance_metadata = "${var.instance_metadata}"
  client_tags              = "${var.instance_tags}"
  server_tags              = "${var.instance_tags}"
  client_private           = "${var.private}"
  server_private           = "${var.private}"
  server_region            = "${module.cloud_nat.region}"
  client_region            = "${module.cloud_nat.region}"
  network                  = "${google_compute_router.main.network}"
}
