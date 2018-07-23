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

variable "download_forseti" {
  description = "Whether to download the forseti repo or not. If false, a Forseti repo must be in the root of main.tf file. (Default 'true')"
  default     = "true"
}

variable "gcs_location" {
  description = "The GCS bucket location"
  default     = "us-central1"
}

variable "cloud_sql_region" {
  description = "The Cloud SQL region"
  default     = "us-central1"
}

variable "sendgrid_api_key" {
  description = "The Sendgrid api key for notifier"
}

variable "notification_recipient_email" {
  description = "Notification recipient email"
}

variable "gsuite_admin_email" {
  description = "The email of a GSuite super admin, used for pulling user directory information."
}

variable "project_id" {
  description = "The ID of the project where Forseti will be installed"
}

variable "forseti_repo_url" {
  description = "Foresti git repository URL"
  default     = "https://github.com/GoogleCloudPlatform/forseti-security.git"
}

variable "forseti_repo_branch" {
  description = "Forseti repository branch"
  default     = "stable"
}

variable "credentials_file_path" {
  description = "Path to service account json"
}
