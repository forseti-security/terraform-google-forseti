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

resource "google_organization_iam_custom_role" "forseti-enforcer-viewer" {
  org_id      = var.org_id
  role_id     = "forseti.enforcerViewer${var.suffix}"
  title       = "Forseti real time enforcer viewer"
  description = "Read-only access to check for policy violations with the Forseti real time enforcer."

  permissions = [
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "bigquery.datasets.get",
    "bigquery.datasets.getIamPolicy",
    "cloudsql.instances.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
  ]
}

resource "google_organization_iam_custom_role" "forseti-enforcer-writer" {
  org_id      = var.org_id
  role_id     = "forseti.enforcerWriter${var.suffix}"
  title       = "Forseti real time enforcer writer"
  description = "Write access to remediate policy violations with the Forseti real time enforcer."

  permissions = [
    "storage.buckets.setIamPolicy",
    "storage.buckets.update",
    "bigquery.datasets.setIamPolicy",
    "bigquery.datasets.update",
    "cloudsql.instances.update",
    "resourcemanager.projects.setIamPolicy",
    "serviceusage.services.use",
  ]
}

