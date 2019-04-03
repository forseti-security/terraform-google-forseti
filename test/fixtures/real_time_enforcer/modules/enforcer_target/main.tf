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
  version = "~> 2.0"
}

resource "random_string" "main" {
  length  = 4
  upper   = false
  lower   = true
  special = false
}

resource "google_storage_bucket" "main" {
  project = "${var.enforcer_project_id}"
  name    = "forseti-enforcer-target-${random_string.main.result}"
}

data "google_project" "main" {
  project_id = "${var.enforcer_project_id}"
}

# Create a GCS bucket with overly permissive IAM members. The Forseti real time
# enforcer should automatically remediate the bad permissions.

resource "google_storage_bucket_iam_member" "allusers" {
  bucket = "${google_storage_bucket.main.name}"
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_iam_member" "allauthenticatedusers" {
  bucket = "${google_storage_bucket.main.name}"
  role   = "roles/storage.objectViewer"
  member = "allAuthenticatedUsers"
}
