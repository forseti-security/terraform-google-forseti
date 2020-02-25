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
  client_conf = file(
    "${path.module}/templates/configs/forseti_conf_client.yaml.tpl",
  )
}

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_client_config" {
  count    = var.client_enabled ? 1 : 0
  template = local.client_conf

  vars = {
    forseti_server_ip = var.server_address
  }
}

resource "google_storage_bucket_object" "forseti_client_config" {
  count   = var.client_enabled ? 1 : 0
  name    = "configs/forseti_conf_client.yaml"
  bucket  = var.client_gcs_module.forseti-client-storage-bucket
  content = data.template_file.forseti_client_config[0].rendered
}

