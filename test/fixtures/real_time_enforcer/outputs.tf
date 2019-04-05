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

output "project_id" {
  description = "A forwarded copy of `project_id` for InSpec"
  value       = "${var.project_id}"
}

output "org_id" {
  description = "A forwarded copy of `org_id` for InSpec"
  value       = "${var.org_id}"
}

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = "${module.real_time_enforcer.suffix}"
}

output "enforcer_project_id" {
  description = "A forwarded copy of `enforcer_project_id` for InSpec"
  value       = "${var.enforcer_project_id}"
}

#--------------------------#
# Forseti enforcer outputs #
#--------------------------#

output "forseti-rt-enforcer-vm-name" {
  description = "Forseti Enforcer VM name"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-vm-name}"
}

output "forseti-rt-enforcer-vm-ip" {
  description = "Forseti Enforcer VM private IP address"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-vm-ip}"
}

output "forseti-rt-enforcer-vm-public-ip" {
  description = "Forseti Enforcer VM public IP address"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-vm-public-ip}"
}

output "forseti-rt-enforcer-service-account" {
  description = "Forseti Enforcer service account"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-service-account}"
}

output "forseti-rt-enforcer-storage-bucket" {
  description = "Forseti Enforcer storage bucket"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-storage-bucket}"
}

output "forseti-rt-enforcer-topic" {
  description = "The Forseti Enforcer events topic"
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-topic}"
}

output "forseti-rt-enforcer-viewer-role-id" {
  description = "The forseti real time enforcer viewer Role ID."
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-viewer-role-id}"
}

output "forseti-rt-enforcer-writer-role-id" {
  description = "The forseti real time enforcer writer Role ID."
  value       = "${module.real_time_enforcer.forseti-rt-enforcer-writer-role-id}"
}
