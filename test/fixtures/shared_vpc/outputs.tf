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

output "project_id" {
  value = "${var.project_id}"
}

output "network_project" {
  value = "${var.network_project}"
}

output "network_self_link" {
  value = "${data.google_compute_network.shared-vpc-network.self_link}"
}

output "network_name" {
  value = "${var.network_name}"
}

output "subnetwork_self_link" {
  value = "${"projects/${var.network_project}/regions/${var.region}/subnetworks/${var.subnetwork}"}"
}

output "forseti-server-vm-ip" {
  value = "${module.forseti.forseti-server-vm-ip}"
}

output "forseti-server-vm-name" {
  value = "${module.forseti.forseti-server-vm-name}"
}

output "forseti-client-vm-ip" {
  value = "${module.forseti.forseti-client-vm-ip}"
}

output "forseti-client-vm-name" {
  value = "${module.forseti.forseti-client-vm-name}"
}

output "region" {
  value = "${var.region}"
}

output "credentials_path" {
  value = "${var.credentials_path}"
}