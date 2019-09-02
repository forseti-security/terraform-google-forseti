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

locals {
  suffix = random_string.main.result
  int_required_roles = [
    "roles/owner"
  ]

  forseti_org_required_roles = [
    "roles/resourcemanager.organizationAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.organizationRoleAdmin", // Permissions to manage/test real-time-enforcer roles
    "roles/logging.configWriter",      // Permissions to create stackdriver log exports
  ]

  forseti_host_project_required_roles = [
    "roles/compute.admin",
    "roles/billing.projectManager",
    "roles/compute.networkAdmin",
    "roles/compute.networkViewer",
    "roles/compute.instanceAdmin",
    "roles/iam.serviceAccountCreator",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
  ]

  forseti_project_required_roles = [
    "roles/compute.instanceAdmin",
    "roles/compute.networkAdmin",
    "roles/compute.networkViewer",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
    "roles/cloudsql.admin",
    "roles/pubsub.admin",
    "roles/billing.projectManager",
  ]

  forseti_enforcer_project_required_roles = [
    "roles/storage.admin", // Permissions to create GCS buckets that the enforcer will manage
    "roles/billing.projectManager",
    "roles/pubsub.admin",
  ]
}

resource "random_string" "main" {
  upper   = "true"
  lower   = "true"
  number  = "false"
  special = "false"
  length  = 4
}

resource "google_service_account" "int_test" {
  project      = module.forseti-host-project.project_id
  account_id   = "ci-forseti"
  display_name = "ci-forseti"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

resource "google_organization_iam_member" "forseti" {
  count = length(local.forseti_org_required_roles)

  org_id = var.org_id
  role   = local.forseti_org_required_roles[count.index]
  member = "serviceAccount:${google_service_account.int_test.email}"
}

// Grant the forseti service account the rights to create GCE instances within
// the host project network.
resource "google_project_iam_member" "forseti-host" {
  count = length(local.forseti_host_project_required_roles)

  project = module.forseti-host-project.project_id
  role    = local.forseti_host_project_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

// Grant the forseti service account rights over the Forseti service project.
resource "google_project_iam_member" "forseti" {
  count = length(local.forseti_project_required_roles)

  project = module.forseti-service-project.project_id
  role    = local.forseti_project_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_project_iam_member" "forseti-enforcer" {
  count = length(local.forseti_enforcer_project_required_roles)

  project = module.forseti-enforcer-project.project_id
  role    = local.forseti_enforcer_project_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

