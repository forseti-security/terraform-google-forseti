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

output "forseti-cai-storage-bucket" {
  description = "Forseti CAI storage bucket"
  value       = module.server_gcs.forseti-cai-storage-bucket
}

output "forseti-client-service-account" {
  description = "Forseti Client service account"
  value       = module.client_iam.forseti-client-service-account
}

output "forseti-client-storage-bucket" {
  description = "Forseti Client storage bucket"
  value       = module.client_gcs.forseti-client-storage-bucket
}

output "forseti-client-vm-ip" {
  description = "Forseti Client VM private IP address"
  value       = module.client.forseti-client-vm-ip
}

output "forseti-client-vm-name" {
  description = "Forseti Client VM name"
  value       = module.client.forseti-client-vm-name
}

output "forseti-cloudsql-instance-ip" {
  description = "The IP of the master CloudSQL instance"
  value       = module.cloudsql.forseti-cloudsql-instance-ip
}

output "forseti-cloudsql-connection-name" {
  description = "Forseti CloudSQL Connection String"
  value       = module.cloudsql.forseti-cloudsql-connection-name
}

output "forseti-cloudsql-password" {
  description = "CloudSQL password"
  value       = module.cloudsql.forseti-cloudsql-password
  sensitive   = true
}

output "forseti-cloudsql-user" {
  description = "CloudSQL user"
  value       = module.cloudsql.forseti-cloudsql-user
}

output "forseti-server-git-public-key-openssh" {
  description = "The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository."
  value       = module.server.forseti-server-git-public-key-openssh
}

output "forseti-server-google-cloud-sdk-version" {
  description = "Version of the Google Cloud SDK installed on the Forseti server"
  value       = module.server.google-cloud-sdk-version
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.server_iam.forseti-server-service-account
}

output "forseti-server-storage-bucket" {
  description = "Forseti Server storage bucket"
  value       = module.server_gcs.forseti-server-storage-bucket
}

output "forseti-server-vm-internal-dns" {
  description = "Forseti Server internal DNS"
  value       = module.server.forseti-server-vm-internal-dns
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = module.server.forseti-server-vm-ip
}

output "forseti-server-vm-name" {
  description = "Forseti Server VM name"
  value       = module.server.forseti-server-vm-name
}

output "suffix" {
  description = "The random suffix appended to Forseti resources"
  value       = local.random_hash
}
