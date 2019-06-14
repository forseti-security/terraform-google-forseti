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

variable "forseti_client_service_account" {
  description = "Forseti Client service account"
}

variable "forseti_client_vm_ip" {
  description = "Forseti Client VM private IP address"
}

variable "forseti_cloudsql_connection_name" {
  description = "Forseti CloudSQL Connection String"
}

variable "forseti_server_service_account" {
  description = "Forseti Server service account"
}

variable forseti_server_bucket  {
  description = "Forseti Server storage bucket"
}

variable gke_service_account {
  description = "Set to 'create' if the GKE cluster node-pool was created with an IAM SA attached."
  default     = "nocreate"
}

variable "gke_service_account_name" {
  description = "The name of the IAM service account attached to the GKE cluster node-pool"
  default = ""
}

variable "helm_repository_url" {
  description = "The Helm repository containing the 'forseti-security' Helm charts"
  default = "https://kubernetes-charts.storage.googleapis.com"
}

variable "k8s_endpoint" {
  description = "The Kubernetes API endpoint."
}

variable "k8s_ca_certificate" {
  description = "Kubernetes API server CA certificate."
}

variable "k8s_forseti_namespace" {
  description = "The Kubernetes namespace in which to deploy Forseti."
  default = "default"
}

variable k8s_forseti_orchestrator_image {
  description = "The container image for the Forseti orchestrator"
  default = "gcr.io/forseti-security-containers/forseti:latest"
}

variable k8s_forseti_server_image {
  description = "The container image for the Forseti server"
  default = "gcr.io/forseti-security-containers/forseti:latest"
}

variable "k8s_tiller_sa_name" {
  description = "The Kubernetes Service Account used by Tiller"
  default = "tiller"
}

variable "project_id" {
  description = "The ID of the GCP project where Forseti is currently deployed."
}

variable server_log_level {
  description = "The log level of the Forseti server container."
  default = "info"
}