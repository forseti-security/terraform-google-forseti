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

provider "google" {
  version = "~> 3.7"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_string" "suffix" {
  upper   = "false"
  lower   = "true"
  number  = "true"
  special = "false"
  length  = 6
}

module "real_time_enforcer_roles" {
  source = "../../modules/real_time_enforcer_roles"
  org_id = var.org_id
  suffix = random_string.suffix.result
}

module "real_time_enforcer_project_sink" {
  source            = "../../modules/real_time_enforcer_project_sink"
  pubsub_project_id = var.project_id
  sink_project_id   = var.enforcer_project_id
}

module "real_time_enforcer" {
  source                     = "../../modules/real_time_enforcer"
  project_id                 = var.project_id
  org_id                     = var.org_id
  enforcer_instance_metadata = var.instance_metadata
  topic                      = module.real_time_enforcer_project_sink.topic
  enforcer_viewer_role       = module.real_time_enforcer_roles.forseti-rt-enforcer-viewer-role-id
  enforcer_writer_role       = module.real_time_enforcer_roles.forseti-rt-enforcer-writer-role-id
  enforcer_instance_private  = true
  suffix                     = random_string.suffix.result
  network                    = var.network
  subnetwork                 = var.subnetwork
  client_region              = var.region
  enforcer_region            = var.region
}
