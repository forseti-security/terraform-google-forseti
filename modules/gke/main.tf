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
 
resource "google_project_service" "gcr" {
  project            = "${var.project_id}"
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = "false"
}

//*****************************************
//  Create Keys for Forseti server and
//  client service accounts.
//*****************************************

resource "google_service_account_key" "server_key" {
  service_account_id = "${var.forseti_server_service_account}"
}

resource "google_service_account_key" "client_key" {
  service_account_id = "${var.forseti_client_service_account}"
}

//*****************************************
//  Create Keys for Forseti server and
//  client service accounts.
//*****************************************

resource "google_project_iam_member" "cluster_service_account-storage_reader" {
  count   = "${var.gke_service_account == "create" ? 1 : 0}"
  project = "${var.project_id}"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${var.gke_service_account_name}"
}

// get forseti server config contents
data "google_storage_object_signed_url" "file_url" {
  bucket = "${var.forseti_server_bucket}"
  path = "configs/forseti_conf_server.yaml"
}

data "http" "server_config_contents" {
  url        = "${data.google_storage_object_signed_url.file_url.signed_url}"
  depends_on = ["data.google_storage_object_signed_url.file_url"]
}

//*****************************************
//  Setup the Kubernetes Provider
//*****************************************

data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file = false

  host = "https://${var.k8s_endpoint}"
  token = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(var.k8s_ca_certificate)}"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "${var.k8s_tiller_sa_name}"
    namespace = "${var.k8s_forseti_namespace}"
  }
  
}

resource "kubernetes_role" "tiller" {
  metadata {
    name = "tiller-manager"
    namespace = "${var.k8s_forseti_namespace}"
  }

  rule {
    api_groups = ["", "batch", "extensions", "apps", "networking.k8s.io"]
    resources = ["pods"]
    resources = ["*"]
    verbs = ["*"]
  }
}

resource "kubernetes_role_binding" "tiller" {
    metadata {
        name = "tiller-binding"
        namespace = "${var.k8s_forseti_namespace}"
    }
    role_ref {
        api_group = "rbac.authorization.k8s.io"
        kind = "Role"
        name = "${kubernetes_role.tiller.metadata.0.name}"
    }
    subject {
        kind = "ServiceAccount"
        name = "${kubernetes_service_account.tiller.metadata.0.name}"
        namespace = "${var.k8s_forseti_namespace}"
    }
}


//*****************************************
//  Setup Helm Provider
//*****************************************
provider "helm" {
    service_account = "${var.k8s_tiller_sa_name}"
    namespace       = "${var.k8s_forseti_namespace}"
    kubernetes {
      load_config_file = false
      host = "https://${var.k8s_endpoint}"
      token = "${data.google_client_config.default.access_token}"
      cluster_ca_certificate = "${base64decode(var.k8s_ca_certificate)}"
    }
    debug = true
    automount_service_account_token = true
    install_tiller = true
}
//*****************************************
//  Deploy Forseti on GKE via Helm
//*****************************************

resource "helm_release" "forseti-security" {
  name          = "forseti-security"
  repository    = "${var.helm_repository_url}"
  chart         = "forseti-security"
  recreate_pods = true
  depends_on    = ["kubernetes_role_binding.tiller", "kubernetes_role_binding.tiller"]
  set {
      name = "cloudsqlConnection"
      value = "${var.forseti_cloudsql_connection_name}"
  }

  set {
    name = "orchestratorImage"
    value = "${var.k8s_forseti_orchestrator_image}"
  }

  set_sensitive  {
      name = "orchestratorKeyContents"
      value = "${google_service_account_key.client_key.private_key}"
  }

  set {
    name = "serverImage"
    value = "${var.k8s_forseti_server_image}"
  }

  set {
    name = "serverBucket"
    value = "${var.forseti_server_bucket}"
  }

  set_string {
    name = "serverConfigContents"
    value = "${base64encode(data.http.server_config_contents.body)}"
  }

  set_sensitive {
    name = "serverKeyContents"
    value = "${google_service_account_key.server_key.private_key}"
  }

  set {
    name = "serverLogLevel"
    value = "${var.server_log_level}"
  }

  set {
    name = "networkPolicyEnable"
    value = true
  }

  values = [
    "netowrkPolicyIngressCidr: [${var.forseti_client_vm_ip}/32]"
  ]
}
