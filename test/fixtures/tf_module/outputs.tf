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

output "forseti-client-vm-name" {
  value = "${module.forseti-install-simple.forseti-client-vm-name}"
}

output "forseti-client-vm-ip" {
  value = "${module.forseti-install-simple.forseti-client-vm-ip}"
}

output "forseti-client-service-account" {
  value = "${module.forseti-install-simple.foseti-client-service-account}"
}

output "forseti-server-vm-name" {
  value = "${module.forseti-install-simple.forseti-server-vm-name}"
}

output "forseti-server-vm-ip" {
  value = "${module.forseti-install-simple.forseti-server-vm-ip}"
}

output "forseti-server-service-account" {
  value = "${module.forseti-install-simple.foseti-server-service-account}"
}