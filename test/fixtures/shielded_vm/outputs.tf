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

output "project_id" {
  description = "A forwarded copy of `project_id` for InSpec"
  value       = var.project_id
}

output "forseti-server-shielded-vm-name" {
  description = "Forseti Server shielded VM name"
  value       = module.shielded-vm.forseti-server-vm-name
}

output "forseti-client-shielded-vm-name" {
  description = "Forseti Client shielded VM name"
  value       = module.shielded-vm.forseti-client-vm-name
}
