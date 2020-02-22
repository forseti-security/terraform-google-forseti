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

output "forseti-client-service-account" {
  description = "Forseti Client service account"
  value       = module.client_iam.forseti-client-service-account
}

output "forseti-client-storage-bucket" {
  description = "Forseti Client storage bucket"
  value       = module.client_gcs.forseti-client-storage-bucket
}

output "forseti-cloudsql-connection-name" {
  description = "Forseti CloudSQL Connection String"
  value       = module.cloudsql.forseti-cloudsql-connection-name
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = module.client.forseti-client-vm-ip
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = module.server_gcs.forseti-server-storage-bucket
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.server_iam.forseti-server-service-account
}

output "kubernetes-forseti-namespace" {
  description = "The Kubernetes namespace in which Forseti is deployed"
  value       = local.kubernetes_namespace
}

output "kubernetes-forseti-server-ingress" {
  description = "The loadbalancer ingress address of the forseti-server service in GKE"
  value       = length(data.kubernetes_service.forseti_server.load_balancer_ingress) == 1 ? data.kubernetes_service.forseti_server.load_balancer_ingress[0].ip : ""
}

output "kubernetes-forseti-tiller-sa-name" {
  description = "The name of the service account deploying Forseti"
  value       = kubernetes_service_account.tiller.metadata[0].name
}

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = local.random_hash
}

output "config-validator-git-public-key-openssh" {
  description = "The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository."
  value       = local.git_sync_public_ssh_key
}
