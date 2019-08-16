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

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = random_string.suffix.result
}

#--------------------------#
# Forseti enforcer outputs #
#--------------------------#

output "forseti-rt-enforcer-vm-name" {
  description = "Forseti Enforcer VM name"
  value       = module.real_time_enforcer.forseti-rt-enforcer-vm-name
}

output "forseti-rt-enforcer-vm-ip" {
  description = "Forseti Enforcer VM private IP address"
  value       = module.real_time_enforcer.forseti-rt-enforcer-vm-ip
}

output "forseti-rt-enforcer-service-account" {
  description = "Forseti Enforcer service account"
  value       = module.real_time_enforcer.forseti-rt-enforcer-service-account
}

output "forseti-rt-enforcer-storage-bucket" {
  description = "Forseti Enforcer storage bucket"
  value       = module.real_time_enforcer.forseti-rt-enforcer-storage-bucket
}

output "forseti-rt-enforcer-topic" {
  description = "The Forseti Enforcer events topic"
  value       = module.real_time_enforcer_project_sink.topic
}

output "forseti-rt-enforcer-viewer-role-id" {
  description = "The forseti real time enforcer viewer Role ID."
  value       = module.real_time_enforcer_roles.forseti-rt-enforcer-viewer-role-id
}

output "forseti-rt-enforcer-writer-role-id" {
  description = "The forseti real time enforcer writer Role ID."
  value       = module.real_time_enforcer_roles.forseti-rt-enforcer-writer-role-id
}

