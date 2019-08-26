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
//  Allow GKE Service Account to read GCS
//*****************************************

resource "google_project_iam_member" "cluster_service_account-storage_reader" {
  project = "${var.project_id}"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${var.gke_service_account}"
}

//*****************************************
//  Obtain Forseti Server Configiration
//*****************************************

data "google_storage_object_signed_url" "file_url" {
  bucket = "${var.forseti_server_bucket}"
  path   = "configs/forseti_conf_server.yaml"
}

data "http" "server_config_contents" {
  url        = "${data.google_storage_object_signed_url.file_url.signed_url}"
  depends_on = ["data.google_storage_object_signed_url.file_url"]
}

//*****************************************
//  Create Tiller Kubernetes Service Account
//*****************************************

resource "kubernetes_namespace" "forseti" {
  metadata {
    name = "${var.k8s_forseti_namespace}"
  }
}

//*****************************************
//  Create Tiller Kubernetes Service Account
//*****************************************

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "${var.k8s_tiller_sa_name}"
    namespace = "${var.k8s_forseti_namespace}"
  }
  depends_on = [
    "kubernetes_namespace.forseti"
  ]
}

//*****************************************
//  Create Tiller RBAC
//*****************************************

resource "kubernetes_role" "tiller" {
  metadata {
    name      = "tiller-manager"
    namespace = "${var.k8s_forseti_namespace}"
  }

  rule {
    api_groups = ["", "extensions", "apps", "batch/v1beta1", "batch", "networking.k8s.io"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "tiller" {
  metadata {
    name      = "tiller-binding"
    namespace = "${var.k8s_forseti_namespace}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${kubernetes_role.tiller.metadata.0.name}"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "${kubernetes_service_account.tiller.metadata.0.name}"
    namespace = "${var.k8s_forseti_namespace}"
  }
}

//*****************************************
//  Deploy Forseti on GKE via Helm
//*****************************************

resource "helm_release" "forseti-security" {
  name          = "forseti"
  namespace     = "${var.k8s_forseti_namespace}"
  repository    = "${var.helm_repository_url}"
  chart         = "forseti-security"
  recreate_pods = "${var.recreate_pods}"
  depends_on    = ["kubernetes_role_binding.tiller", "kubernetes_namespace.forseti"]

  set {
    name  = "cloudsqlConnection"
    value = "${var.forseti_cloudsql_connection_name}"
  }

  set {
    name  = "configValidator"
    value = "${var.config_validator_enabled}"
  }

  set {
    name  = "configValidatorImage"
    value = "${var.k8s_config_validator_image}"
  }

  set {
    name  = "configValidatorImageTag"
    value = "${var.k8s_config_validator_image_tag}"
  }

  set {
    name  = "loadBalancer"
    value = "${var.load_balancer}"
  }

  set {
    name  = "networkPolicyEnable"
    value = "${var.network_policy}"
  }

  set {
    name  = "orchestratorImage"
    value = "${var.k8s_forseti_orchestrator_image}"
  }

  set {
    name  = "orchestratorImageTag"
    value = "${var.k8s_forseti_orchestrator_image_tag}"
  }

  set_sensitive {
    name  = "orchestratorKeyContents"
    value = "${google_service_account_key.client_key.private_key}"
  }

  set {
    name  = "production"
    value = "${var.production}"
  }

  set {
    name  = "policyLibraryRepositoryURL"
    value = "${var.policy_library_repository_url}"

  }

  set {
    name  = "serverImage"
    value = "${var.k8s_forseti_server_image}"
  }

  set {
    name  = "serverImageTag"
    value = "${var.k8s_forseti_server_image_tag}"
  }

  set {
    name  = "serverBucket"
    value = "${var.forseti_server_bucket}"
  }

  set_string {
    name  = "serverConfigContents"
    value = "${base64encode(data.http.server_config_contents.body)}"
  }

  set_sensitive {
    name  = "serverKeyContents"
    value = "${google_service_account_key.server_key.private_key}"
  }

  set {
    name  = "serverLogLevel"
    value = "${var.server_log_level}"
  }

  values = [
    "networkPolicyIngressCidr: [${var.forseti_client_vm_ip}/32]"
  ]
}
