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

output "network_project" {
  value = module.forseti-host-project.project_id
}

output "gsuite_admin_email" {
  value = google_service_account.int_test.email
}

output "project_id" {
  value = module.forseti-service-project.project_id
}

# Temporarily disabled due to issue #285
#output "enforcer_project_id" {
#  value = module.forseti-enforcer-project.project_id
#}

output "network" {
  value = module.forseti-host-network.network_name
}

output "subnetwork" {
  value = module.forseti-host-network.subnets_names[0]
}

output "sa_key" {
  value     = google_service_account_key.int_test.private_key
  sensitive = true
}

output "org_id" {
  value = var.org_id
}

output "folder_id" {
  value = var.folder_id
}

output "billing_account" {
  value = var.billing_account
}
