/**
 * Copyright 2020 Google LLC
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

variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "master"
}

variable "org_id" {
  description = "GCP Organization ID that Forseti will have purview over"
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}

variable "network" {
  description = "Name of the shared VPC"
}

variable "subnetwork" {
  description = "Name of the subnetwork where forseti will be deployed"
}
