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

output "enforcer_topic" {
  description = "A test topic normally attached to the forseti policy enforcer"
  value       = "${google_pubsub_topic.main.name}"
}

output "pubsub_project_id" {
  description = "A forwarded copy of 'pubsub_project_id' for inspec"
  value       = "${var.pubsub_project_id}"
}

output "org_id" {
  description = "A forwarded copy of 'org_id' for inspec"
  value       = "${var.org_id}"
}

output "org_id_sink_name" {
  description = "The organization logging sink name"
  value = "${module.real_time_enforcer_organization_sink.sink_name}"
}
