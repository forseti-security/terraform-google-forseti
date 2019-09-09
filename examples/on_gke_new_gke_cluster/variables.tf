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

variable "auto_create_subnetworks" {
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
  type        = bool
}

variable "credentials_path" {
  description = "Path to service account json"
}

variable "forseti_client_service_account" {
  description = "Forseti Client service account"
  default     = ""
}

variable "forseti_client_vm_ip" {
  description = "Forseti Client VM private IP address"
  default     = ""
}

variable "forseti_cloudsql_connection_name" {
  description = "The connection string to the CloudSQL instance"
  default     = ""
}

variable "forseti_server_service_account" {
  description = "Forseti Server service account"
  default     = ""
}

variable "forseti_server_storage_bucket" {
  description = "Forseti Server storage bucket"
  default     = ""
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster"
  default     = "forseti-cluster"
}

variable "gke_node_ip_range" {
  description = "The IP range for the GKE nodes."
  default     = "10.1.0.0/20"
}

variable "gke_pod_ip_range" {
  description = "The IP range of the Kubernetes pods"
  default     = "10.2.0.0/20"
}

variable "gke_service_account" {
  description = "The service account to run nodes as if not overridden in node_pools. The default value will cause a cluster-specific service account to be created."
  default     = "create"
}

variable "gke_service_ip_range" {
  description = "The IP range of the Kubernetes services."
  default     = "10.3.0.0/20"
}

variable "helm_repository_url" {
  description = "The Helm repository containing the 'forseti-security' Helm charts"
  default     = "https://forseti-security-charts.storage.googleapis.com/release/"
}

variable "k8s_forseti_namespace" {
  description = "The Kubernetes namespace in which to deploy Forseti."
  default     = "forseti"
}

variable "k8s_forseti_orchestrator_image" {
  description = "The container image for the Forseti orchestrator"
  default     = "gcr.io/forseti-containers/forseti"
}

variable "k8s_forseti_orchestrator_image_tag" {
  description = "The tag for the container image for the Forseti orchestrator"
  default     = "v2.20.0"
}

variable "k8s_forseti_server_image" {
  description = "The container image for the Forseti server"
  default     = "gcr.io/forseti-containers/forseti"
}

variable "k8s_forseti_server_image_tag" {
  description = "The tag for the container image for the Forseti server"
  default     = "v2.20.0"
}

variable "k8s_tiller_sa_name" {
  description = "The Kubernetes Service Account used by Tiller"
  default     = "tiller"
}

variable "load_balancer" {
  description = "The type of load balancer to deploy for the forseti-server if desired: none, external, internal"
  default     = "internal"
}

variable "network_name" {
  description = "The name of the VPC being created"
  default     = "gke-network"
}

variable "network_description" {
  type        = string
  description = "An optional description of the network. The resource must be recreated to modify this field."
  default     = ""
}

variable "production" {
  description = "Whether or not to deploy Forseti on GKE in a production configuration"
  default     = true
  type        = bool
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "region" {
  description = "Region where forseti subnetwork will be deployed"
  default     = "us-central1"
}

variable "sub_network_name" {
  description = "The names of the subnet being created"
  default     = "gke-sub-network"
}

variable "suffix" {
  description = "The random suffix appended to Forseti resources"
}

variable "zones" {
  description = "The zones to host the cluster in.  This is optional if the GKE cluster is regional.  It is required if the cluster is zonal."
  default     = ["us-central1-a"]
}

variable "server_log_level" {
  description = "The log level of the Forseti server container."
  default     = "info"
}