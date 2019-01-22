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

resource "random_id" "random_hash_suffix" {
  byte_length = 4
}

#--------#
# Locals #
#--------#
locals {
  random_hash     = "${random_id.random_hash_suffix.hex}"
  network_project = "${var.network_project != "" ? var.network_project : var.project_id}"

  services_list = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "cloudtrace.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "logging.googleapis.com",
    "cloudasset.googleapis.com",
    "storage-api.googleapis.com",
  ]
}

#-------------------#
# Activate services #
#-------------------#
resource "google_project_service" "main" {
  count              = "${length(local.services_list)}"
  project            = "${var.project_id}"
  service            = "${local.services_list[count.index]}"
  disable_on_destroy = "false"
}

module "client" {
  source = "modules/client"

  project_id              = "${var.project_id}"
  client_boot_image       = "${var.client_boot_image}"
  server_address          = "${module.server.forseti-server-vm-ip}"
  subnetwork              = "${var.subnetwork}"
  forseti_home            = "${var.forseti_home}"
  storage_bucket_location = "${var.storage_bucket_location}"
  forseti_version         = "${var.forseti_version}"
  forseti_repo_url        = "${var.forseti_repo_url}"
  client_type             = "${var.client_type}"
  network_project         = "${local.network_project}"
  suffix                  = "${local.random_hash}"
  client_region           = "${var.client_region}"

  services = "${google_project_service.main.*.service}"
}

module "server" {
  source = "modules/server"

  enable_cai_bucket        = "${var.enable_cai_bucket}"
  project_id               = "${var.project_id}"
  gsuite_admin_email       = "${var.gsuite_admin_email}"
  forseti_version          = "${var.forseti_version}"
  forseti_repo_url         = "${var.forseti_repo_url}"
  forseti_email_recipient  = "${var.forseti_email_recipient}"
  forseti_email_sender     = "${var.forseti_email_sender}"
  forseti_home             = "${var.forseti_home}"
  forseti_run_frequency    = "${var.forseti_run_frequency}"
  server_type              = "${var.server_type}"
  server_region            = "${var.server_region}"
  server_boot_image        = "${var.server_boot_image}"
  cloudsql_region          = "${var.cloudsql_region}"
  cloudsql_db_name         = "${var.cloudsql_db_name}"
  cloudsql_db_port         = "${var.cloudsql_db_port}"
  cloudsql_proxy_arch      = "${var.cloudsql_proxy_arch}"
  cloudsql_type            = "${var.cloudsql_type}"
  storage_bucket_location  = "${var.storage_bucket_location}"
  bucket_cai_location      = "${var.bucket_cai_location}"
  bucket_cai_lifecycle_age = "${var.bucket_cai_lifecycle_age}"
  network                  = "${var.network}"
  subnetwork               = "${var.subnetwork}"
  network_project          = "${var.network_project}"
  enable_write             = "${var.enable_write}"
  org_id                   = "${var.org_id}"
  domain                   = "${var.domain}"
  folder_id                = "${var.folder_id}"
  sendgrid_api_key         = "${var.sendgrid_api_key}"
  suffix                   = "${local.random_hash}"

  services = "${google_project_service.main.*.service}"
}
