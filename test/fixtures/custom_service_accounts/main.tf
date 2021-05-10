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

module "custom-service-accounts" {
  source = "../../.."

  project_id          = var.project_id
  org_id              = var.org_id
  domain              = var.domain
  network             = var.network
  subnetwork          = var.subnetwork
  forseti_version     = var.forseti_version
  deletion_protection = false

  # The resources that create the service accounts are in test/setup/iam.tf.
  # Did not create them here and directly reference them becuase `count` will complain
  # google_service_account.forseti_{server,client}.email are unknown until apply.
  server_service_account = "my-custom-server-sa@${var.project_id}.iam.gserviceaccount.com"
  client_service_account = "my-custom-client-sa@${var.project_id}.iam.gserviceaccount.com"
}
