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

//*****************************************
//  Setup Google providers
//*****************************************

provider "google" {
  version = "~> 2.7.0"
  credentials = "${file(var.gcp_credentials_file)}"
}
provider "google-beta" {
  version = "~> 2.7.0"
  credentials = "${file(var.gcp_credentials_file)}"
}

//*****************************************
//  Setup the VPC
//*****************************************

module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "0.6.0"

    project_id   = "${var.project_id}"
    network_name = "${var.network_name}"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "${var.sub_network_name}"
            subnet_ip             = "${var.gke_node_ip_range}"
            subnet_region         = "${var.region}"
        },
    ]

    secondary_ranges = {
        "${var.sub_network_name}" = [
            {
                range_name    = "gke-pod-ip-range"
                ip_cidr_range = "${var.gke_pod_ip_range}"
            },
        ]

        "${var.sub_network_name}" = [
            {
                range_name    = "gke-service-ip-range"
                ip_cidr_range = "${var.gke_service_ip_range}"
            },
        ]

    }
}

//*****************************************
//  Deploy GKE
//*****************************************

module "gke" {
  source            = "terraform-google-modules/kubernetes-engine/google"
  project_id        = "${var.project_id}"
  name              = "gke-test-1"
  regional          = false
  region            = "${var.region}"
  zones             = "${var.zones}"
  network           = "${module.vpc.network_name}"
  subnetwork        = "${var.sub_network_name}"
  ip_range_pods     = "gke-pod-ip-range"
  ip_range_services = "gke-service-ip-range"
  service_account   = "${var.gke_service_account}"
  network_policy    = true

  node_pools_oauth_scopes {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

//*****************************************
//  Deploy Forseti
//*****************************************

module "forseti" {
    source  = "./modules/terraform-google-forseti"
    version = "~> 1.6"

    gsuite_admin_email = "${var.gsuite_admin_email}"
    domain             = "${var.gsuite_domain}"
    project_id         = "${var.project_id}"
    org_id             = "${var.organization_id}"
    network            = "${var.network_name}"
    subnetwork         = "${var.sub_network_name}"
    server_region      = "${var.region}"
    client_region      = "${var.region}"
}

//*****************************************
//  Deploy Forseti on GKE
//*****************************************

module "forseti-on-gke" {
    source  = "../../modules/terraform-google-forseti/modules/gke"
    forseti_client_service_account   = "${module.forseti.forseti-client-service-account}"
    forseti_client_vm_ip             = "${module.forseti.forseti-client-vm-ip}"
    forseti_cloudsql_connection_name = "${module.forseti.forseti-cloudsql-connection-name}"
    forseti_server_service_account   = "${module.forseti.forseti-server-service-account}"
    forseti_server_bucket            = "${module.forseti.forseti-server-storage-bucket}"
    gke_service_account              = "${var.gke_service_account}"
    gke_service_account_name         = "${module.gke.service_account}"
    helm_repository_url              = "${var.helm_repository_url}"
    k8s_scheduler_image              = "${var.k8s_scheduler_image}"
    k8s_server_image                 = "${var.k8s_server_image}"
    k8s_endpoint                     = "${module.gke.endpoint}"
    k8s_ca_certificate               = "${module.gke.ca_certificate}"
    project_id                       = "${var.project_id}"
}








