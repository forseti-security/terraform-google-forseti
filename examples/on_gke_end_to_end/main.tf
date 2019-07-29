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
  credentials = "${file(var.credentials_path)}"
}

provider "google-beta" {
  credentials = "${file(var.credentials_path)}"
}

//*****************************************
//  Setup the Kubernetes Provider
//*****************************************

data "google_client_config" "default" {}

provider "kubernetes" {
  alias                  = "forseti"
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
}

//*****************************************
//  Setup Helm Provider
//*****************************************

provider "helm" {
  alias           = "forseti"
  service_account = "${var.k8s_tiller_sa_name}"
  namespace       = "${var.k8s_forseti_namespace}-${module.forseti.suffix}"
  kubernetes {
    load_config_file       = false
    host                   = "https://${module.gke.endpoint}"
    token                  = "${data.google_client_config.default.access_token}"
    cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
  }
  debug                           = true
  automount_service_account_token = true
  install_tiller                  = true
}

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "1.1.0"
  project_id              = "${var.project_id}"
  network_name            = "${var.network_name}"
  routing_mode            = "GLOBAL"
  description             = "${var.network_description}"
  auto_create_subnetworks = "${var.auto_create_subnetworks}"

  subnets = [{
    subnet_name   = "${var.sub_network_name}"
    subnet_ip     = "${var.gke_node_ip_range}"
    subnet_region = "${var.region}"
  }, ]

  secondary_ranges = {
    "${var.sub_network_name}" = [
      {
        range_name    = "gke-pod-ip-range"
        ip_cidr_range = "${var.gke_pod_ip_range}"
      },
      {
        range_name    = "gke-service-ip-range"
        ip_cidr_range = "${var.gke_service_ip_range}"
      },
    ]
  }
}

module "forseti" {
  source                  = "../../"
  gsuite_admin_email      = "${var.gsuite_admin_email}"
  domain                  = "${var.domain}"
  project_id              = "${var.project_id}"
  org_id                  = "${var.org_id}"
  network                 = "${module.vpc.network_name}"
  subnetwork              = "${var.sub_network_name}"
  client_private          = "${var.client_private}"
  server_private          = "${var.server_private}"
  storage_bucket_location = "${var.region}"
  server_region           = "${var.region}"
  client_region           = "${var.region}"
  cloudsql_region         = "${var.region}"
}

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google"
  project_id               = "${var.project_id}"
  name                     = "${var.gke_cluster_name}"
  regional                 = false
  region                   = "${var.region}"
  zones                    = "${var.zones}"
  network                  = "${module.vpc.network_name}"
  subnetwork               = "${module.vpc.subnets_names[0]}"
  ip_range_pods            = "gke-pod-ip-range"
  ip_range_services        = "gke-service-ip-range"
  service_account          = "${var.gke_service_account}"
  network_policy           = true
  remove_default_node_pool = true


  node_pools = [{
    name               = "default-node-pool"
    machine_type       = "n1-standard-2"
    min_count          = 1
    max_count          = 1
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    image_type         = "COS"
    auto_repair        = true
    auto_upgrade       = true
    preemptible        = false
    initial_node_count = 1
  }, ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

//*****************************************
//  Deploy Forseti on GKE
//*****************************************

module "forseti-on-gke" {
  providers = {
    kubernetes = "kubernetes.forseti"
    helm       = "helm.forseti"
  }
  source                             = "../../modules/on_gke"
  forseti_client_service_account     = "${module.forseti.forseti-client-service-account}"
  forseti_client_vm_ip               = "${module.forseti.forseti-client-vm-ip}"
  forseti_cloudsql_connection_name   = "${module.forseti.forseti-cloudsql-connection-name}"
  forseti_server_service_account     = "${module.forseti.forseti-server-service-account}"
  forseti_server_bucket              = "${module.forseti.forseti-server-storage-bucket}"
  gke_service_account                = "${module.gke.service_account}"
  k8s_forseti_namespace              = "${var.k8s_forseti_namespace}-${module.forseti.suffix}"
  k8s_forseti_orchestrator_image     = "${var.k8s_forseti_orchestrator_image}"
  k8s_forseti_orchestrator_image_tag = "${var.k8s_forseti_orchestrator_image_tag}"
  k8s_forseti_server_image           = "${var.k8s_forseti_server_image}"
  k8s_forseti_server_image_tag       = "${var.k8s_forseti_server_image_tag}"
  project_id                         = "${var.project_id}"
  network_policy                     = "${module.gke.network_policy_enabled}"
  load_balancer                      = "${var.load_balancer}"
  helm_repository_url                = "${var.helm_repository_url}"
}
