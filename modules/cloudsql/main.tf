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
  random_hash   = var.suffix
  cloudsql_name = "forseti-server-db-${local.random_hash}"
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
    disk_size         = "25"
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

    ip_configuration {
      ipv4_enabled = true
      require_ssl  = true
    }
  }

  depends_on = [null_resource.services-dependency]
}

resource "google_sql_database" "forseti-db" {
  name     = var.cloudsql_db_name
  project  = var.project_id
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.master.name
  project  = var.project_id
  host     = var.cloudsql_user_host
}

resource "null_resource" "services-dependency" {
  triggers = {
    services = jsonencode(var.services)
  }
}
