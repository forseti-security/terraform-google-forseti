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

resource "random_string" "main" {
  upper   = "true"
  lower   = "true"
  number  = "false"
  special = "false"
  length  = 4
}

module "real_time_enforcer_roles" {
  source = "../../../modules/real_time_enforcer_roles"

  org_id          = "${var.org_id}"
  suffix          = "${random_string.main.result}"
  prevent_destroy = "false"
}