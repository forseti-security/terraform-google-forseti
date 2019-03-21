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
  credentials = "${file(var.credentials_path)}"
  version     = "~> 1.20"
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
  source                   = "../../"
  project_id               = "${var.project_id}"
  gsuite_admin_email       = "${var.gsuite_admin_email}"
  org_id                   = "${var.org_id}"
  domain                   = "${var.domain}"
  client_instance_metadata = "${var.instance_metadata}"
  server_instance_metadata = "${var.instance_metadata}"
}

module "real_time_enforcer" {
  source = "../../modules/real_time_enforcer"

  project_id                 = "${var.project_id}"
  org_id                     = "${var.org_id}"
  enforcer_instance_metadata = "${var.instance_metadata}"

  suffix = "${module.forseti.suffix}"
}

resource "google_logging_project_sink" "real-time-enforcer-log-sink" {
  name                   = "real-time-enforcer-log-sink"
  project                = "${var.enforcer_project_id}"
  destination            = "pubsub.googleapis.com/projects/${var.project_id}/topics/${module.real_time_enforcer.forseti-rt-enforcer-topic}"
  filter                 = <<EOD
protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog
severity != ERROR
protoPayload.serviceName != "k8s.io"
NOT protoPayload.methodName: "delete"
EOD
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_member" "publisher" {
  topic   = "${module.real_time_enforcer.forseti-rt-enforcer-topic}"
  role    = "roles/pubsub.publisher"
  project = "${var.project_id}"
  member  = "${google_logging_project_sink.real-time-enforcer-log-sink.writer_identity}"
}
