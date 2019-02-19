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

module "forseti-shared-vpc" {
  source              = "../../../examples/shared_vpc"
  credentials_path    = "${var.credentials_path}"
  project_id          = "${var.project_id}"
  region              = "${var.region}"
  gsuite_admin_email  = "${var.gsuite_admin_email}"
  network             = "${var.network}"
  subnetwork          = "${var.subnetwork}"
  network_project     = "${var.network_project}"
  org_id              = "${var.org_id}"
  domain              = "${var.domain}"
}
