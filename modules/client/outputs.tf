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

output "forseti-client-vm-name" {
  description = "Forseti Client VM name"
  value       = "${google_compute_instance.forseti-client.name}"
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = "${google_compute_instance.forseti-client.network_interface.0.network_ip}"
}

output "forseti-client-service-account" {
  description = "Forseti Client service account"
  value       = "${google_service_account.forseti_client.email}"
}

output "forseti-client-storage-bucket" {
  description = "Forseti Client storage bucket"
  value       = "${google_storage_bucket.client_config.id}"
}
