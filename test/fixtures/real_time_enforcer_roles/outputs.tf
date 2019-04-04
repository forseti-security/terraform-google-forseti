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

output "org_id" {
  description = "The organization ID where the custom Forseti roles will be created."
  value       = "${var.org_id}"
}

output "forseti-rt-enforcer-viewer-role-id" {
  description = "The forseti real time enforcer viewer Role ID."
  value       = "${module.real_time_enforcer_roles.forseti-rt-enforcer-viewer-role-id}"
}

output "forseti-rt-enforcer-writer-role-id" {
  description = "The forseti real time enforcer writer Role ID."
  value       = "${module.real_time_enforcer_roles.forseti-rt-enforcer-writer-role-id}"
}
