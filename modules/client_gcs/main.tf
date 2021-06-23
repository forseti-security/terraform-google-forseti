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

#--------#
# Locals #
#--------#
locals {
  client_bucket_name = "forseti-client-${var.suffix}"
}

#------------------------#
# Forseti storage bucket #
#------------------------#
resource "google_storage_bucket" "client_config" {
  count                       = var.client_enabled ? 1 : 0
  name                        = local.client_bucket_name
  location                    = var.storage_bucket_location
  storage_class               = var.storage_bucket_class
  project                     = var.project_id
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.gcs_labels

  depends_on = [null_resource.services-dependency]
}

resource "null_resource" "services-dependency" {
  count = var.client_enabled ? 1 : 0
  triggers = {
    services = jsonencode(var.services)
  }
}
