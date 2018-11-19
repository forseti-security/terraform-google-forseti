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

/******************************************
  Locals configuration
 *****************************************/
locals {
  project_id           = "${var.project_id}"
  should_download      = "${var.download_forseti == "true" ? true : false}"
  skip_sendgrid_config = "${var.sendgrid_api_key == ""}"

  services_list = [
    "admin.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "bigquery-json.googleapis.com",
    "cloudbilling.googleapis.com",
    "sql-component.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "deploymentmanager.googleapis.com",
    "iam.googleapis.com",
  ]
  /*COMMAND TO REPLACE SCRIPT FOR AUTOMATION*/
  launch_first               = "sh ${path.module}/scripts/accScript.sh ${var.gsuite_admin_email} &&"
  launch_command_main        = "cd forseti-security && python install/gcp_installer.py --no-cloudshell --service-account-key-file ${var.credentials_file_path} --gsuite-superadmin-email ${var.gsuite_admin_email}"
  launch_command_gcs         = "${var.gcs_location != "" ? format("--gcs-location %s", var.gcs_location) : "--gcs-location \"\""}"
  launch_command_cloudsql    = "${var.cloud_sql_region != "" ? format("--cloudsql-region %s", var.cloud_sql_region) : "--cloudsql-region \"\"" }"
  launch_command_sendgrid    = "${var.sendgrid_api_key != "" ? format("--sendgrid-api-key %s", var.sendgrid_api_key) : "--skip-sendgrid-config" }"
  launch_command_email_notif = "${var.notification_recipient_email != "" && !local.skip_sendgrid_config ? format("--notification-recipient-email %s", var.notification_recipient_email) : ""}"
  launch_command_list        = "${compact(list(local.launch_first, local.launch_command_main, local.launch_command_sendgrid, local.launch_command_cloudsql, local.launch_command_email_notif, local.launch_command_gcs))}"
  launch_command_fmt         = "${join(" ", local.launch_command_list)}"
}

/*******************************************
  Activate services
 *******************************************/
resource "google_project_service" "activate_services" {
  count   = "${length(local.services_list)}"
  project = "${local.project_id}"

  service = "${element(local.services_list, count.index)}"
}

/*******************************************
   Repo downloading
 *******************************************/
resource "null_resource" "get_repo" {
  count = "${local.should_download ? 1 : 0}"

  # Remove foresti existing repo
  provisioner "local-exec" {
    command = "rm -rf forseti-security"
  }

  # Clone repository
  provisioner "local-exec" {
    command = "git clone --single-branch -b ${var.forseti_repo_branch} ${var.forseti_repo_url}"
  }
}

/*******************************************
   Forseti execution
 *******************************************/
resource "null_resource" "execute_forseti" {
  # Execute forseti installation
  provisioner "local-exec" {
    command = "${local.launch_command_fmt}"

    environment {
      CLOUDSDK_CORE_PROJECT = "${local.project_id}"
    }
  }

  depends_on = ["null_resource.get_repo", "google_project_service.activate_services"]
}

/*******************************************
   Buckets list retrieval
 *******************************************/
data "external" "bucket_retrieval" {
  program = ["bash", "${path.module}/scripts/get-project-buckets.sh", "${var.credentials_file_path}"]

  depends_on = ["null_resource.execute_forseti"]
}
