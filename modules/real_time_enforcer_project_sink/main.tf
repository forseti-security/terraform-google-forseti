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

resource "random_string" "main" {
  upper   = "false"
  lower   = "true"
  special = "false"
  length  = 4
}

#----------------------------------#
# Real Time Enforcer Pub/Sub topic #
#----------------------------------#

resource "google_pubsub_topic" "main" {
  name    = "real-time-enforcer-events-topic-${random_string.main.result}"
  project = var.pubsub_project_id
}

resource "google_logging_project_sink" "main" {
  name        = "real-time-enforcer-log-sink-${random_string.main.result}"
  project     = var.sink_project_id
  destination = "pubsub.googleapis.com/projects/${var.pubsub_project_id}/topics/${google_pubsub_topic.main.name}"

  filter = <<EOD
protoPayload.@type=type.googleapis.com/google.cloud.audit.AuditLog
severity != ERROR
protoPayload.serviceName != "k8s.io"
NOT protoPayload.methodName: "delete"
EOD


  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_member" "publisher" {
  topic   = google_pubsub_topic.main.name
  role    = "roles/pubsub.publisher"
  project = var.pubsub_project_id
  member  = google_logging_project_sink.main.writer_identity
}

