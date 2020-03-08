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

output "bastion_host" {
  value = module.bastion.host
}

output "forseti-server-vm-ip" {
  description = "Forseti Server VM private IP address"
  value       = module.forseti-server-monitoring-enabled.forseti-server-vm-ip
}

output "forseti-server-service-account" {
  description = "Forseti Server service account"
  value       = module.forseti-server-monitoring-enabled.forseti-server-service-account
}

output "project_id" {
  description = "A forwarded copy of `project_id` for InSpec"
  value       = var.project_id
}