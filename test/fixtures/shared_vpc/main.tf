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

provider "google-beta" {
  credentials = "${file(var.credentials_path)}"
  #version     = "~> 1.20"
}

module "vpc" {
  source          = "github.com/terraform-google-modules/terraform-google-network.git"
  network_name    = "forseti-shared-vpc"
  project_id      = "${var.shared_project_id}"
  shared_vpc_host = "true"

  subnets = [
    {
      subnet_name           = "forseti-subnet-01"
      subnet_ip             = "${var.subnet_cidr}"
      subnet_region         = "${var.region}"
      subnet_private_access = true
    }
  ]

  secondary_ranges = {
    forseti-subnet-01 = []
  }

}

module "service-project" {
  source              = "terraform-google-modules/project-factory/google"
  version             = "v1.0.0"
  group_name          = ""
  create_group        = false
  random_project_id   = "true"
  name                = "forseti-service"
  org_id              = "${var.org_id}"
  billing_account     = "${var.billing_account}"
  credentials_path    = "${var.credentials_path}"
  shared_vpc          = "${var.shared_project_id}"
  shared_vpc_subnets  = [
    "projects/${var.shared_project_id}/regions/${var.region}/subnetworks/forseti-subnet-01",
  ]
  activate_apis = [
    "storage-api.googleapis.com",
    "compute.googleapis.com",
    "sqladmin.googleapis.com"
  ]
}

module "forseti" {
  source              = "../../.."
  project_id          = "${module.service-project.project_id}"
  client_region       = "${var.region}"
  gsuite_admin_email  = "admin@example.com"
  network             = "${module.vpc.network_self_link}"
  subnetwork          = "forseti-subnet-01"
  network_project     = "${var.shared_project_id}"
  org_id              = "${var.org_id}"
  server_region       = "${var.region}"
}
