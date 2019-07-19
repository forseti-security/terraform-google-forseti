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

output "forseti-rt-enforcer-vm-name" {
  description = "Forseti Enforcer VM name"
  value       = google_compute_instance.main.name
}

output "forseti-rt-enforcer-vm-ip" {
  description = "Forseti Enforcer VM private IP address"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "forseti-rt-enforcer-service-account" {
  description = "Forseti Enforcer service account"
  value       = google_service_account.main.email
}

output "forseti-rt-enforcer-storage-bucket" {
  description = "Forseti Enforcer storage bucket"
  value       = google_storage_bucket.main.name
}

