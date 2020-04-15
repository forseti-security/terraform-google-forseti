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

output "bastion_host" {
  value = module.bastion.host
}

output "project_id" {
  description = "ID of the service project"
  value       = var.project_id
}

output "forseti-server-vm-internal-dns" {
  description = "Forseti Server internal DNS"
  value       = module.forseti-private-connection.forseti-server-vm-internal-dns
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = module.forseti-private-connection.forseti-server-vm-ip
}

output "forseti-server-vm-name" {
  description = "Forseti Server VM name"
  value       = module.forseti-private-connection.forseti-server-vm-name
}

output "region" {
  description = "Region in which server and client will be deployed"
  value       = var.region
}

output "subnetwork" {
  description = "Subnetwork where server and client will be deployed"
  value       = module.forseti-private-connection.subnetwork
}

output "network" {
  description = "Network where server and client will be deployed"
  value       = module.forseti-private-connection.network
}

output "org_id" {
  description = "A forwarded copy of `org_id` for InSpec"
  value       = var.org_id
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = module.forseti-private-connection.forseti-server-storage-bucket
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.forseti-private-connection.forseti-server-service-account
}

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = module.forseti-private-connection.suffix
}

