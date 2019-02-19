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
  description = "ID of the service project"
  value       = "${var.project_id}"
}

output "network_project" {
  description = "ID of the network project holding shared VPC"
  value       = "${var.network_project}"
}

output "network_name" {
  description = "Shared VPC name"
  value       = "${var.network_name}"
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = "${module.forseti.forseti-server-vm-ip}"
}

output "forseti-server-vm-name" {
  description = "Forseti Server VM name"
  value       = "${module.forseti.forseti-server-vm-name}"
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = "${module.forseti.forseti-client-vm-ip}"
}

output "forseti-client-vm-name" {
  description = "Forseti Client VM name"
  value       = "${module.forseti.forseti-client-vm-name}"
}

output "region" {
  description = "Region in which server and client will be deployed"
  value       = "${var.region}"
}