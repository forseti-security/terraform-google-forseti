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

terraform {
  required_version = ">= 0.12.0"
}

provider "google" {
  version = "~> 2.11.0"
}

provider "local" {
  version = "~> 1.3"
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
  source  = "terraform-google-modules/forseti/google"
  version = "~> 5.1"

  # Replace these argument values with those obtained in the Prerequisites section
  domain               = "DOMAIN"
  project_id           = "PROJECT_ID"
  resource_name_suffix = "RESOURCE_NAME_SUFFIX"
  org_id               = "ORG_ID"

  network    = "default"
  subnetwork = "default"

  # Uncomment this input variables if using a shared VPC.
  # network_project = "SHARED_VPC_PROJECT_ID"

  client_instance_metadata = {
    enable-oslogin = "TRUE"
  }
  enable_write         = true
  manage_rules_enabled = false

  cloudsql_region = "us-central1"
  server_region   = "us-central1"
  client_region   = "us-central1"

  storage_bucket_location = "us-central1"
  bucket_cai_location     = "us-central1"

  ### Add any Forseti Server Configuration Variables Below this Line ###

}
