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

output "forseti-client-vm-name" {
  description = "Forseti Client VM name"
  value       = var.client_enabled ? google_compute_instance.forseti-client[0].name : null
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = var.client_enabled ? google_compute_instance.forseti-client[0].network_interface[0].network_ip : null
}

output "forseti-client-vm-zone" {
  description = "Forseti Client VM zone"
  value       = var.client_enabled ? google_compute_instance.forseti-client[0].zone : null
}

output "forseti-client-vm-self_link" {
  description = "Forseti Client VM self_link"
  value       = var.client_enabled ? google_compute_instance.forseti-client[0].self_link : null
}
