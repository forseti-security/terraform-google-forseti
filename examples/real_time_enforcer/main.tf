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

provider "google" {
  credentials = "${file(var.credentials_path)}"
  version     = "~> 1.20"
}

provider "null" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

provider "random" {
  version = "~> 2.0"
}

module "forseti" {
  source                   = "../../"
  project_id               = "${var.project_id}"
  gsuite_admin_email       = "${var.gsuite_admin_email}"
  org_id                   = "${var.org_id}"
  domain                   = "${var.domain}"
  client_instance_metadata = "${var.instance_metadata}"
  server_instance_metadata = "${var.instance_metadata}"
}

module "real_time_enforcer_roles" {
  source = "../../modules/real_time_enforcer_roles"

  org_id = "${var.org_id}"
  suffix = "${module.forseti.suffix}"
}

module "real_time_enforcer_project_sink" {
  source = "../../modules/real_time_enforcer_project_sink"

  pubsub_project_id = "${var.project_id}"
  sink_project_id   = "${var.enforcer_project_id}"
}

module "real_time_enforcer" {
  source = "../../modules/real_time_enforcer"

  project_id                 = "${var.project_id}"
  org_id                     = "${var.org_id}"
  enforcer_instance_metadata = "${var.instance_metadata}"
  topic                      = "${module.real_time_enforcer_project_sink.topic}"

  enforcer_viewer_role = "${module.real_time_enforcer_roles.forseti-rt-enforcer-viewer-role-id}"
  enforcer_writer_role = "${module.real_time_enforcer_roles.forseti-rt-enforcer-writer-role-id}"

  suffix = "${module.forseti.suffix}"
}
