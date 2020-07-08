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

#--------#
# Locals #
#--------#
locals {
  cloudsql_name     = "forseti-server-db-${local.random_hash}"
  cloudsql_zone     = "${var.cloudsql_region}-c"
  network_project   = var.network_project != "" ? var.network_project : var.project_id
  cloudsql_password = var.cloudsql_password == "" ? random_password.password.result : var.cloudsql_password
  random_hash       = var.suffix
}

#------------------------------------#
# Forseti Private SQL Database Setup #
#------------------------------------#
data "google_compute_network" "cloudsql_private_network" {
  name    = var.network
  project = local.network_project
}

resource "google_project_service" "service_networking" {
  count              = var.cloudsql_private ? 1 : 0
  project            = var.project_id
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "service_networking_network_project" {
  count              = var.enable_service_networking && var.cloudsql_private && local.network_project != var.project_id ? 1 : 0
  project            = local.network_project
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_compute_global_address" "private_ip_address" {
  count         = var.cloudsql_private ? 1 : 0
  project       = local.network_project
  name          = "private-ip-address-${local.random_hash}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.cloudsql_private_network.self_link
  depends_on    = [google_project_service.service_networking]
}

resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.enable_service_networking && var.cloudsql_private ? 1 : 0
  network                 = data.google_compute_network.cloudsql_private_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address[count.index].name]
  depends_on = [
    google_compute_global_address.private_ip_address,
    google_project_service.service_networking_network_project,
  ]
}

#----------------------#
# Forseti SQL database #
#----------------------#
resource "google_sql_database_instance" "master" {
  name             = local.cloudsql_name
  project          = var.project_id
  region           = var.cloudsql_region
  database_version = "MYSQL_5_7"

  settings {
    tier              = var.cloudsql_type
    activation_policy = "ALWAYS"
    disk_size         = var.cloudsql_disk_size
    availability_type = var.cloudsql_availability_type
    user_labels       = var.cloudsql_labels

    database_flags {
      name  = "net_write_timeout"
      value = var.cloudsql_net_write_timeout
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

    ip_configuration {
      ipv4_enabled    = var.cloudsql_private ? false : true
      require_ssl     = true
      private_network = var.cloudsql_private ? data.google_compute_network.cloudsql_private_network.self_link : ""
    }

    location_preference {
      zone = local.cloudsql_zone
    }
  }

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
    ]
  }

  depends_on = [null_resource.services-dependency, google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "forseti-db" {
  name     = var.cloudsql_db_name
  project  = var.project_id
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "forseti_user" {
  name     = var.cloudsql_user
  instance = google_sql_database_instance.master.name
  project  = var.project_id
  host     = var.cloudsql_user_host
  password = local.cloudsql_password
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_"
}

resource "null_resource" "services-dependency" {
  triggers = {
    services = jsonencode(var.services)
  }
}
