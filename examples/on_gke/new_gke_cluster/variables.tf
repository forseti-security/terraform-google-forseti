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

variable "credentials_path" {
  description = "Path to service account json"
<<<<<<< HEAD
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
=======
}

variable forseti_client_service_account {
  description = "Forseti Client service account"
}

variable forseti_client_vm_ip {
  description = "Forseti Client VM private IP address"
}

variable forseti_cloudsql_connection_name {
  description = "The connection string to the CloudSQL instance"
}

variable forseti_server_service_account {
  description = "Forseti Server service account"
}

variable forseti_server_storage_bucket {
  description = "Forseti Server storage bucket"
>>>>>>> Fixes per aaron-lane
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster"
<<<<<<< HEAD
  default     = "forseti-cluster"
=======
  default = "forseti-cluster"
>>>>>>> Fixes per aaron-lane
}

variable "gke_node_ip_range" {
  description = "The IP range for the GKE nodes."
<<<<<<< HEAD
  default     = "10.1.0.0/20"
=======
  default = "10.1.0.0/20"
>>>>>>> Fixes per aaron-lane
}

variable "gke_pod_ip_range" {
  description = "The IP range of the Kubernetes pods"
<<<<<<< HEAD
  default     = "10.2.0.0/20"
=======
  default = "10.2.0.0/20"
>>>>>>> Fixes per aaron-lane
}

variable "gke_service_account" {
  description = "The service account to run nodes as if not overridden in node_pools. The default value will cause a cluster-specific service account to be created."
<<<<<<< HEAD
  default     = "create"
=======
  default = "create"
>>>>>>> Fixes per aaron-lane
}

variable "gke_service_ip_range" {
  description = "The IP range of the Kubernetes services."
<<<<<<< HEAD
  default     = "10.3.0.0/20"
=======
  default = "10.3.0.0/20"
>>>>>>> Fixes per aaron-lane
}

variable "helm_repository_url" {
  description = "The Helm repository containing the 'forseti-security' Helm charts"
<<<<<<< HEAD
  default     = "https://forseti-security-charts.storage.googleapis.com/release/"
}

variable "k8s_forseti_namespace" {
  description = "The Kubernetes namespace in which to deploy Forseti."
  default     = "default"
}

variable "k8s_forseti_orchestrator_image" {
  description = "The container image for the Forseti orchestrator"
  default     = "gcr.io/forseti-containers/forseti"
=======
  default = "https://kubernetes-charts-incubator.storage.googleapis.com"
>>>>>>> Fixes per aaron-lane
}

variable "k8s_forseti_orchestrator_image_tag" {
  description = "The tag for the container image for the Forseti orchestrator"
  default     = "latest"
}

<<<<<<< HEAD
variable "k8s_forseti_server_image" {
  description = "The container image for the Forseti server"
  default     = "gcr.io/forseti-containers/forseti"
}

variable "k8s_forseti_server_image_tag" {
  description = "The tag for the container image for the Forseti server"
  default     = "latest"
=======
variable k8s_forseti_orchestrator_image {
  description = "The container image for the Forseti orchestrator"
  default = "gcr.io/forseti-security-containers/forseti:dev"
}

variable k8s_forseti_server_image {
  description = "The container image for the Forseti server"
  default = "gcr.io/forseti-security-containers/forseti:dev"
>>>>>>> Fixes per aaron-lane
}

variable "k8s_tiller_sa_name" {
  description = "The Kubernetes Service Account used by Tiller"
  default     = "tiller"
}

variable "network_name" {
  description = "The name of the VPC being created"
<<<<<<< HEAD
  default     = "gke-network"
}

variable "production" {
  description = "Whether or not to deploy Forseti on GKE in a production configuration"
  default     = "true"
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

=======
  default = "gke-network"
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

>>>>>>> Fixes per aaron-lane
variable "region" {
  description = "Region where forseti subnetwork will be deployed"
}

variable "sub_network_name" {
  description = "The names of the subnet being created"
<<<<<<< HEAD
  default     = "gke-sub-network"
}

variable "suffix" {
  description = "The random suffix appended to Forseti resources"
=======
  default = "gke-sub-network"
>>>>>>> Fixes per aaron-lane
}

variable "zones" {
  description = "The zones to host the cluster in (optional if regional cluster / required if zonal)"
<<<<<<< HEAD
  default     = []
=======
  default = []
>>>>>>> Fixes per aaron-lane
}













