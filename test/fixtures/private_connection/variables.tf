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

variable "org_id" {
  description = "Organization ID"
}

variable "domain" {
  description = "Organization domain"
}

variable "project_id" {
  description = "ID of the project that will have forseti server"
}

variable "region" {
  description = "Region where forseti subnetwork will be deployed"
  default     = "us-central1"
}

variable "block_egress" {
  description = "Controls whether the forseti infrastructure components can communicate to internet"
  type        = bool
  default     = false
}

variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "master"
}
