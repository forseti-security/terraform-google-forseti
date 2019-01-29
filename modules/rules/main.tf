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
  files = [
    "rules/audit_logging_rules.yaml",
    "rules/bigquery_rules.yaml",
    "rules/blacklist_rules.yaml",
    "rules/bucket_rules.yaml",
    "rules/cloudsql_rules.yaml",
    "rules/enabled_apis_rules.yaml",
    "rules/external_project_access_rules.yaml",
    "rules/firewall_rules.yaml",
    "rules/forwarding_rules.yaml",
    "rules/group_rules.yaml",
    "rules/iam_rules.yaml",
    "rules/iap_rules.yaml",
    "rules/instance_network_interface_rules.yaml",
    "rules/ke_rules.yaml",
    "rules/ke_scanner_rules.yaml",
    "rules/lien_rules.yaml",
    "rules/location_rules.yaml",
    "rules/log_sink_rules.yaml",
    "rules/resource_rules.yaml",
    "rules/retention_rules.yaml",
    "rules/service_account_key_rules.yaml",
  ]
}

data "template_file" "main" {
  count    = "${length(local.files)}"
  template = "${file("${path.module}/templates/${element(local.files, count.index)}")}"

  vars {
    org_id = "${var.org_id}"
    domain = "${var.domain}"
  }
}

resource "google_storage_bucket_object" "main" {
  count   = "${length(local.files)}"
  name    = "${element(local.files, count.index)}"
  content = "${element(data.template_file.main.*.rendered, count.index)}"
  bucket  = "${var.bucket}"

  lifecycle {
    ignore_changes = ["content", "detect_md5hash"]
  }
}
