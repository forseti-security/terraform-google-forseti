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

variable "sendgrid_api_key" {
  description = "The Sendgrid api key for notifier"
  default     = ""
}

variable "notification_recipient_email" {
  description = "Notification recipient email"
}

variable "gsuite_admin_email" {
  description = "The email of a GSuite super admin, used for pulling user directory information *and* sending notifications."
}

variable "project_id" {
  description = "The ID of an existing Google project where Forseti will be installed"
}

variable "credentials_file_path" {
  description = "Path to service account json"
}

variable "shared_vpc" {
  description = "The ID of the host project which hosts the shared VPC"
  default     = ""
}

variable "shared_vpc_subnets" {
  description = "List of subnets fully qualified subnet IDs (ie. projects/$PROJECT_ID/regions/$REGION/subnetworks/$SUBNET_ID)"
  type        = "list"
  default     = [""]
}
