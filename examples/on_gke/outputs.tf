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
  value       = module.forseti.forseti-client-service-account
}

output "forseti-client-storage-bucket" {
  description = "Forseti Client storage bucket"
  value       = module.forseti.forseti-client-storage-bucket
}

output "forseti-cloudsql-connection-name" {
  description = "Forseti CloudSQL Connection String"
  value       = module.forseti.forseti-cloudsql-connection-name
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = module.forseti.forseti-client-vm-ip
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = module.forseti.forseti-server-storage-bucket
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.forseti.forseti-server-service-account
}

output "kubernetes-forseti-namespace" {
  description = "The Kubernetes namespace in which Forseti is deployed"
  value       = module.forseti.kubernetes-forseti-namespace
}

output "kubernetes-forseti-tiller-sa-name" {
  description = "The name of the service account deploying Forseti"
  value       = module.forseti.kubernetes-forseti-tiller-sa-name
}

output "kubernetes-forseti-server-ingress" {
  description = "The loadbalancer ingress address of the forseti-server service in GKE"
  value       = module.forseti.kubernetes-forseti-server-ingress
}

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = module.forseti.suffix
}

output "config-validator-git-public-key-openssh" {
  description = "The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository."
  value       = module.forseti.config-validator-git-public-key-openssh
}
