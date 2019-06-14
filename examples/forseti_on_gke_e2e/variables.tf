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

variable "organization_id" {}

variable "project_id" {}

variable "region" {}

variable "zones" {
  default = []
}

variable "gcp_credentials_file" {}

variable "network_name" {
    default = "gke-network"
}

variable "sub_network_name" {
    default = "gke-sub-network"
}

variable "gke_node_ip_range" {
  default = "10.1.0.0/20"
}

variable "gke_pod_ip_range" {
  default = "10.2.0.0/20"
}

variable "gke_service_ip_range" {
  default = "10.3.0.0/20"
}

variable "gke_service_account" {
  default = "create"
}

variable "gsuite_domain" {}

variable "gsuite_admin_email" {}

variable "helm_repository_url" {
  default = "https://kubernetes-charts.storage.googleapis.com"
}

variable k8s_scheduler_image {
  default = "gcr.io/forseti-security-containers/forseti:dev"
}

variable k8s_server_image {
  default = "gcr.io/forseti-security-containers/forseti:dev"
}