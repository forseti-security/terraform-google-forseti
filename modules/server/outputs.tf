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

output "forseti-server-vm-name" {
  description = "Forseti Server VM name"
  value       = google_compute_instance.forseti-server.name
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = google_compute_instance.forseti-server.network_interface[0].network_ip
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = google_service_account.forseti_server.email
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = google_storage_bucket.server_config.id
}

output "forseti-cloudsql-connection-name" {
  description = "The connection string to the CloudSQL instance"
  value       = google_sql_database_instance.master.connection_name
}

