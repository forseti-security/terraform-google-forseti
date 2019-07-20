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

variable "credentials_path" {
  description = "Path to service account json"
}

variable "forseti_client_service_account" {
  description = "Forseti Client service account"
}

variable "forseti_client_vm_ip" {
  description = "Forseti Client VM private IP address"
}

variable "forseti_cloudsql_connection_name" {
  description = "The connection string to the CloudSQL instance"
}

variable "forseti_server_service_account" {
  description = "Forseti Server service account"
}

variable "forseti_server_storage_bucket" {
  description = "Forseti Server storage bucket"
}

variable "gke_cluster_location" {
  description = "The location of the GKE cluster on which to deploy Forseti"
}

variable "gke_cluster_name" {
  description = "The name of the GKE cluster on which to deploy Forseti"
}

variable "gke_service_account" {
  description = "The service account to run nodes as if not overridden in node_pools."
  default     = "create"
}

variable "helm_repository_url" {
  description = "The Helm repository containing the 'forseti-security' Helm charts"
  default     = "https://forseti-security-charts.storage.googleapis.com/release/"
}

variable "k8s_forseti_namespace" {
  description = "The Kubernetes namespace in which to deploy Forseti."
  default     = "forseti"
}

variable "k8s_tiller_sa_name" {
  description = "The Kubernetes Service Account used by Tiller"
  default     = "tiller"
}

variable "network_policy" {
  description = "Whether or not to apply Pod NetworkPolicies"
  default     = "false"
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "suffix" {
  description = "The random suffix appended to Forseti resources"
}