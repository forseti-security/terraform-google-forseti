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
  random_hash             = var.suffix
  storage_cai_bucket_name = "forseti-cai-export-${local.random_hash}"
  server_bucket_name      = "forseti-server-${local.random_hash}"
}

#------------------------#
# Forseti Storage bucket #
#------------------------#

resource "google_storage_bucket" "server_config" {
  name                        = local.server_bucket_name
  location                    = var.storage_bucket_location
  project                     = var.project_id
  storage_class               = var.storage_bucket_class
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.gcs_labels

  depends_on = [null_resource.services-dependency]
}

resource "google_storage_bucket" "cai_export" {
  count                       = var.enable_cai_bucket ? 1 : 0
  name                        = local.storage_cai_bucket_name
  location                    = var.bucket_cai_location
  project                     = var.project_id
  storage_class               = var.storage_bucket_class
  force_destroy               = true
  uniform_bucket_level_access = true
  labels                      = var.gcs_labels

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = var.bucket_cai_lifecycle_age
    }
  }

  depends_on = [null_resource.services-dependency]
}

resource "null_resource" "services-dependency" {
  triggers = {
    services = jsonencode(var.services)
  }
}
