/**
 * Copyright 2020 Google LLC
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

output "client_token" {
  description = "The bearer token for auth"
  sensitive   = true
  value       = module.forseti.client_token
}

output "ca_certificate" {
  description = "The cluster CA certificate"
  value       = module.forseti.ca_certificate
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = module.forseti.forseti-client-vm-ip
}

output "gke_cluster_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.forseti.gke_cluster_location
}

output "gke_cluster_name" {
  description = "The name of the GKE Cluster"
  value       = module.forseti.gke_cluster_name
}

output "gke_project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
  value       = var.gke_project_id
}

output "kubernetes_endpoint" {
  description = "The cluster endpoint"
  sensitive   = true
  value       = module.forseti.kubernetes_endpoint
}
