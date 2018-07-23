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

locals {
  credentials_file_path = "${var.credentials_file_path}"
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(local.credentials_file_path)}"
}

/******************************************
  Module calling
 *****************************************/
module "forseti-install-simple" {
  source                       = "../../"
  gsuite_admin_email           = "${var.gsuite_admin_email}"
  project_id                   = "${var.project_id}"
  sendgrid_api_key             = "${var.sendgrid_api_key}"
  notification_recipient_email = "${var.notification_recipient_email}"
  credentials_file_path        = "${local.credentials_file_path}"
}
