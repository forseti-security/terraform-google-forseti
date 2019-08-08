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

output "forseti-cloudsql-connection-name" {
  description = "The connection string to the CloudSQL instance"
  value       = google_sql_database_instance.master.connection_name
}

output "forseti-cloudsql-instance-name" {
  description = "The name of the master CloudSQL instance"
  value       = google_sql_database_instance.master.name
}

output "forseti-cloudsql-region" {
  description = "CloudSQL region"
  value       = var.cloudsql_region
}

output "forseti-cloudsql-db-name" {
  description = "CloudSQL region"
  value       = var.cloudsql_db_name
}

output "forseti-clodusql-db-port" {
  description = "CloudSQL database port"
  value       = "3306"
}
