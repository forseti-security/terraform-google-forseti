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

#------------------#
# Google Providers #
#------------------#

provider "google" {
  version = "~> 2.12.0"
  project = var.project_id
}

provider "google-beta" {
  version = "~> 2.12.0"
  project = var.project_id
}

//*****************************************
//  Setup the Kubernetes Provider
//*****************************************

data "google_client_config" "default" {}

provider "kubernetes" {
  alias                  = "forseti"
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = "${base64decode(module.gke.ca_certificate)}"
}

//*****************************************
//  Setup Helm Provider
//*****************************************

provider "helm" {
  alias           = "forseti"
  service_account = var.k8s_tiller_sa_name
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

#--------------------#
# Deploy Forseti VPC #
#--------------------#

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "1.1.0"
  project_id              = var.project_id
  network_name            = var.network
  routing_mode            = "GLOBAL"
  description             = var.network_description
  auto_create_subnetworks = var.auto_create_subnetworks

  subnets = [{
    subnet_name   = var.subnetwork
    subnet_ip     = var.gke_node_ip_range
    subnet_region = var.region
  }, ]

  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = var.gke_pod_ip_range_name
        ip_cidr_range = var.gke_pod_ip_range
      },
      {
        range_name    = var.gke_service_ip_range_name
        ip_cidr_range = var.gke_service_ip_range
      },
    ]
  }
}

#----------------------------#
# Deploy Forseti GKE Cluster #
#----------------------------#

module "gke" {
  source                   = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                  = "5.0.0"
  project_id               = var.project_id
  name                     = var.gke_cluster_name
  region                   = var.region
  network                  = module.vpc.network_name
  subnetwork               = module.vpc.subnets_names[0]
  ip_range_pods            = var.gke_pod_ip_range_name
  ip_range_services        = var.gke_service_ip_range_name
  service_account          = var.gke_service_account
  network_policy           = true
  remove_default_node_pool = true
  identity_namespace       = "${var.project_id}.svc.id.goog"
  node_metadata            = "GKE_METADATA_SERVER"
  kubernetes_version       = "1.13.11-gke.5"


  node_pools = [{
    name               = "default-node-pool"
    machine_type       = "n1-standard-2"
    min_count          = 1
    max_count          = 1
    disk_size_gb       = 100
    disk_type          = "pd-standard"
    image_type         = "COS"
    auto_repair        = true
    auto_upgrade       = false
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

#----------------------------------------#
#  Allow GKE Service Account to read GCS #
#----------------------------------------#

resource "google_project_iam_member" "cluster_service_account-storage_reader" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${module.gke.service_account}"
}

#-----------------------#
# Deploy Forseti on-GKE #
#-----------------------#

module "forseti" {
  providers = {
    kubernetes = "kubernetes.forseti"
    helm       = "helm.forseti"
  }
  source     = "../../modules/on_gke"
  domain     = var.domain
  org_id     = var.org_id
  project_id = var.project_id

  client_region   = var.region
  cloudsql_region = var.region
  network         = var.network
  subnetwork      = var.subnetwork

  network_policy     = module.gke.network_policy_enabled
  gke_node_pool_name = "default-node-pool"

  gsuite_admin_email      = var.gsuite_admin_email
  sendgrid_api_key        = var.sendgrid_api_key
  forseti_email_sender    = var.forseti_email_sender
  forseti_email_recipient = var.forseti_email_recipient
  cscc_violations_enabled = var.cscc_violations_enabled
  cscc_source_id          = var.cscc_source_id


  config_validator_enabled           = var.config_validator_enabled
  git_sync_private_ssh_key_file      = var.git_sync_private_ssh_key_file
  k8s_forseti_server_ingress_cidr    = module.vpc.subnets_ips[0]
  k8s_forseti_server_image_tag       = var.k8s_forseti_server_image_tag
  k8s_forseti_orchestrator_image_tag = var.k8s_forseti_orchestrator_image_tag
  helm_repository_url                = var.helm_repository_url
  policy_library_repository_url      = var.policy_library_repository_url
  policy_library_repository_branch   = var.policy_library_repository_branch
  policy_library_sync_enabled        = var.policy_library_sync_enabled
  server_log_level                   = var.server_log_level
}
