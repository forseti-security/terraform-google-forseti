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
  version = "~> 2.11.0"
  project = var.project_id
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

module "forseti-install-simple" {
  source  = "terraform-google-modules/forseti/google"
  version = "~> 5.0.0"

  project_id = var.project_id
  org_id     = var.org_id
  domain     = var.domain

  server_region   = var.region
  client_region   = var.region
  cloudsql_region = var.region
  network         = var.network
  subnetwork      = var.subnetwork

  storage_bucket_location = var.region
  bucket_cai_location     = var.region

  gsuite_admin_email      = var.gsuite_admin_email
  sendgrid_api_key        = var.sendgrid_api_key
  forseti_email_sender    = var.forseti_email_sender
  forseti_email_recipient = var.forseti_email_recipient

  client_instance_metadata = var.instance_metadata
  server_instance_metadata = var.instance_metadata

  client_tags = var.instance_tags
  server_tags = var.instance_tags

  client_private = var.private
  server_private = var.private
}
