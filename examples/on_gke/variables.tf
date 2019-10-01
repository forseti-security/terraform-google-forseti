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

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "gsuite_admin_email" {
  description = "G-Suite administrator email address to manage your Forseti installation"
}

variable "sendgrid_api_key" {
  description = "Sendgrid.com API key to enable email notifications"
  default     = ""
}

variable "forseti_email_recipient" {
  description = "Email address that receives Forseti notifications"
  default     = ""
}

variable "forseti_email_sender" {
  description = "Email address that sends the Forseti notifications"
  default     = ""
}

variable "gke_cluster_name" {
  description = "The name of the GKE Cluster"
}

variable "gke_cluster_location" {
  description = "The location of the GKE Cluster"
}

variable "gke_node_pool_name" {
  description = "The name of the GKE node-pool where Forseti is being deployed"
  default     = "default-pool"
}

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "k8s_tiller_sa_name" {
  description = "The Kubernetes Service Account used by Tiller"
  default     = "tiller"
}

#-------------#
# Helm config #
#-------------#

variable "git_sync_image" {
  description = "The container image used by the config-validator git-sync side-car"
  default     = "gcr.io/google-containers/git-sync"
}

variable "git_sync_private_ssh_key_file" {
  description = "The file containing the SSH key allowing the git-sync to clone the policy library repository."
  default     = null
}

variable "git_sync_wait" {
  description = "The time number of seconds between git-syncs"
  default     = 30
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
  default     = "v2.21.0"
}

variable "k8s_forseti_server_image" {
  description = "The container image for the Forseti server"
  default     = "gcr.io/forseti-containers/forseti"
}

variable "k8s_forseti_server_image_tag" {
  description = "The tag for the container image for the Forseti server"
  default     = "v2.21.0"
}

variable "policy_library_repository_url" {
  description = "The git repository containing the policy-library."
  default     = "https://github.com/forseti-security/policy-library.git"
}

variable "policy_library_repository_branch" {
  description = "The specific git branch containing the policies."
  default     = "master"
}

variable "server_log_level" {
  description = "The log level of the Forseti server container."
  default     = "info"
}