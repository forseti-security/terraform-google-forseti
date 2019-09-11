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

variable "config_validator_enabled" {
  description = "Config Validator scanner enabled."
  type        = bool
  default     = false
}

variable "forseti_client_vm_ip" {
  description = "Forseti Client VM private IP address"
}

variable "forseti_client_service_account" {
  description = "Forseti Client service account"
}

variable "forseti_cloudsql_connection_name" {
  description = "Forseti CloudSQL Connection String"
}

variable "forseti_server_bucket" {
  description = "Forseti Server storage bucket"
}

variable "forseti_server_service_account" {
  description = "Forseti Server service account"
}

variable "git_sync_image" {
  description = "The container image used by the config-validator git-sync side-car"
  default     = "gcr.io/google-containers/git-sync"
}

variable "git_sync_image_tag" {
  description = "The container image tag used by the config-validator git-sync side-car"
  default     = "v3.1.2"
}

variable "git_sync_private_ssh_key_file" {
  description = "The file containing the private SSH key allowing the git-sync to clone the policy library repository."
  default     = ""
}

variable "git_sync_ssh" {
  description = "Use SSH for git-sync operations"
  type        = bool
  default     = true
}

variable "git_sync_wait" {
  description = "The time number of seconds between git-syncs"
  default     = 30
}

variable "gke_service_account" {
  description = "The name of the IAM service account attached to the GKE cluster node-pool"
}

variable "helm_repository_url" {
  description = "The Helm repository containing the 'forseti-security' Helm charts"
  default     = "https://forseti-security-charts.storage.googleapis.com/release/"
}

variable "k8s_config_validator_image" {
  description = "The container image used by the config-validator"
  default     = "gcr.io/forseti-containers/config-validator"
}

variable "k8s_config_validator_image_tag" {
  description = "The tag for the config-validator image."
  default     = "latest"
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
  default     = "none"
}

variable "network_policy" {
  description = "Apply pod network policies"
  type        = bool
  default     = false
}

variable "policy_library_repository_url" {
  description = "The git repository containing the policy-library."
}

variable "policy_library_repository_branch" {
  description = "The specific git branch containing the policies."
  default     = "master"
}

variable "production" {
  description = "Whether or not to deploy Forseti on GKE in a production configuration"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The ID of the GCP project where Forseti is currently deployed."
}

variable "recreate_pods" {
  description = "Instructs the helm_release resource to, on update, perform pod restarts for the resources if applicable."
  type        = bool
  default     = true
}

variable "server_log_level" {
  description = "The log level of the Forseti server container."
  default     = "info"
}
