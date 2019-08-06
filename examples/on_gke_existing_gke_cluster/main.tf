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

//*****************************************
//  Setup Google providers
//*****************************************

provider "google" {
  version     = "~> 2.7.0"
  credentials = "${file(var.credentials_path)}"
}

//*****************************************
//  Setup the Kubernetes Provider
//*****************************************

data "google_client_config" "default" {}

data "google_container_cluster" "existing_cluster" {
  name     = "${var.gke_cluster_name}"
  location = "${var.gke_cluster_location}"
  project  = "${var.project_id}"
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${data.google_container_cluster.existing_cluster.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(data.google_container_cluster.existing_cluster.master_auth.0.cluster_ca_certificate)}"
}

//*****************************************
//  Setup Helm Provider
//*****************************************
provider "helm" {
  service_account = "${var.k8s_tiller_sa_name}"
  namespace       = "${var.k8s_forseti_namespace}-${var.suffix}"
  kubernetes {
    load_config_file       = false
    host                   = "https://${data.google_container_cluster.existing_cluster.endpoint}"
    token                  = "${data.google_client_config.default.access_token}"
    cluster_ca_certificate = "${base64decode(data.google_container_cluster.existing_cluster.master_auth.0.cluster_ca_certificate)}"
  }
  debug                           = true
  automount_service_account_token = true
  install_tiller                  = true
}

//*****************************************
//  Deploy Forseti on GKE
//*****************************************

module "forseti-on-gke" {
  source                             = "../../modules/on_gke"
  config_validator_enabled           = "${var.config_validator_enabled}"
  forseti_client_service_account     = "${var.forseti_client_service_account}"
  forseti_client_vm_ip               = "${var.forseti_client_vm_ip}"
  forseti_cloudsql_connection_name   = "${var.forseti_cloudsql_connection_name}"
  forseti_server_service_account     = "${var.forseti_server_service_account}"
  forseti_server_bucket              = "${var.forseti_server_storage_bucket}"
  gke_service_account                = "${var.gke_service_account}"
  k8s_config_validator_image         = "${var.k8s_config_validator_image}"
  k8s_config_validator_image_tag     = "${var.k8s_config_validator_image_tag}"
  k8s_forseti_namespace              = "${var.k8s_forseti_namespace}-${var.suffix}"
  k8s_forseti_orchestrator_image     = "${var.k8s_forseti_orchestrator_image}"
  k8s_forseti_orchestrator_image_tag = "${var.k8s_forseti_orchestrator_image_tag}"
  k8s_forseti_server_image           = "${var.k8s_forseti_server_image}"
  k8s_forseti_server_image_tag       = "${var.k8s_forseti_server_image_tag}"
  helm_repository_url                = "${var.helm_repository_url}"
  policy_library_repository_url      = "${var.policy_library_repository_url}"
  project_id                         = "${var.project_id}"
  load_balancer                      = "${var.load_balancer}"
  server_log_level                   = "${var.server_log_level}"
}
