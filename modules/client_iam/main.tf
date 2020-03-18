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

#--------#
# Locals #
#--------#
locals {
  client_sa_name = "forseti-client-gcp-${var.suffix}"

  client_project_roles = [
    "roles/storage.objectViewer"
  ]

}

#-------------------------#
# Forseti service Account #
#-------------------------#
resource "google_service_account" "forseti_client" {
  count        = (var.client_enabled && var.client_service_account == "") ? 1 : 0
  account_id   = local.client_sa_name
  project      = var.project_id
  display_name = "Forseti Client Service Account"
}

#----------------------#
# Forseti client roles #
#----------------------#
resource "google_project_iam_member" "client_roles" {
  count   = var.client_enabled ? length(local.client_project_roles) : 0
  role    = local.client_project_roles[count.index]
  project = var.project_id
  member  = var.client_service_account == "" ? "serviceAccount:${google_service_account.forseti_client[0].email}" : "serviceAccount:${var.client_service_account}"
}
