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

variable "credentials_path" {
  description = "Location of service account json credentials"
}

variable "shared_project_id" {
  description = "ID of the project that will have shared VPC"
}

variable "service_project_id" {
  description = "ID of the project that will have forseti server"
}

variable "org_id" {
  description = "Organization ID"
}

variable "billing_account" {
  description = "Billing account 0000-0000-0000"
}

variable "domain" {
  description = "Organization domain"
}

variable "network_name" {
  description = "Name of the shared VPC"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork where forseti will be deployed"
  default = "forseti-subnet-01"
}

variable "region" {
  description = "Region where forseti subnetwork will be deployed"
  default     = "us-east1"
}

variable "subnet_cidr" {
  description = "Subnetwork CIDR"
  default     = "10.0.0.0/24"
}

