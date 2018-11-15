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

#--------#
# Locals #
#--------#
locals {
  random_hash             = "${random_id.random_project_id_suffix.hex}"
  root_resource_id        = "${var.org_id != "" ? "organizations/${var.org_id}" : var.folder_id != "" ? "folders/${var.folder_id}" : ""}"
  vpc_host_project_id     = "${var.vpc_host_project_id != "" ? var.vpc_host_project_id : var.project_id}"
  server_zone             = "${var.server_region}-c"
  server_startup_script   = "${file("${path.module}/scripts/forseti-server/forseti_server_startup_script.sh")}"
  server_environment      = "${file("${path.module}/scripts/forseti-server/forseti_environment.sh")}"
  server_env              = "${file("${path.module}/scripts/forseti-server/forseti_env.sh")}"
  server_conf             = "${file("${path.module}/configs/forseti_conf_server.yaml")}"
  server_conf_path        = "${var.forseti_home}/configs/forseti_conf_server.yaml"
  server_name             = "forseti-server-vm-${local.random_hash}"
  server_sa_name          = "forseti-server-gcp-${local.random_hash}"
  cloudsql_name           = "forseti-server-db-${local.random_hash}"
  storage_bucket_name     = "forseti-server-${local.random_hash}"
  storage_cai_bucket_name = "forseti-cai-export-${local.random_hash}"
  server_bucket_name     = "forseti-server-${local.random_hash}"

  client_startup_script = "${file("${path.module}/scripts/forseti-client/forseti_client_startup_script.sh")}"
  client_env_script     = "${file("${path.module}/scripts/forseti-client/forseti_environment.sh")}"
  client_conf           = "${file("${path.module}/configs/forseti_conf_client.yaml")}"
  client_conf_path      = "${var.forseti_home}/configs/forseti_conf_client.yaml"
  client_sa_name        = "forseti-client-gcp-${local.random_hash}"
  client_name           = "forseti-client-vm-${local.random_hash}"
  client_bucket_name     = "forseti-client-${local.random_hash}"
  client_zone           = "${var.client_region}-c"

  services_list = [
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudtrace.googleapis.com",
    "container.googleapis.com",
    "servicemanagement.googleapis.com",
    "logging.googleapis.com",
  ]

  server_project_roles = [
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/cloudsql.client",
    "roles/cloudtrace.agent",
    "roles/logging.logWriter",
    "roles/iam.serviceAccountTokenCreator",
  ]

  client_project_roles = [
    "roles/storage.objectViewer",
    "roles/cloudtrace.agent",
  ]

  server_write_roles = [
    "roles/compute.securityAdmin",
  ]

  server_read_roles = [
    "roles/appengine.appViewer",
    "roles/bigquery.dataViewer",
    "roles/browser",
    "roles/cloudasset.viewer",
    "roles/cloudsql.viewer",
    "roles/compute.networkViewer",
    "roles/iam.securityReviewer",
    "roles/servicemanagement.quotaViewer",
    "roles/serviceusage.serviceUsageConsumer",
  ]

  server_bucket_roles = [
    "roles/storage.objectAdmin",
  ]
}
