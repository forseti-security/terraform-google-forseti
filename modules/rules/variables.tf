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

variable "paths" {
  description = "A list of Forseti templates to add to the server bucket"
  type        = "list"
  default     = ["rules/audit_logging_rules.yaml", "rules/bigquery_rules.yaml", "rules/blacklist_rules.yaml", "rules/bucket_rules.yaml", "rules/cloudsql_rules.yaml", "rules/enabled_apis_rules.yaml", "rules/external_project_access_rules.yaml", "rules/firewall_rules.yaml", "rules/forwarding_rules.yaml", "rules/group_rules.yaml", "rules/iam_rules.yaml", "rules/iap_rules.yaml", "rules/instance_network_interface_rules.yaml", "rules/ke_rules.yaml", "rules/ke_scanner_rules.yaml", "rules/lien_rules.yaml", "rules/location_rules.yaml", "rules/log_sink_rules.yaml", "rules/resource_rules.yaml", "rules/retention_rules.yaml", "rules/service_account_key_rules.yaml"]
}

variable "bucket" {
  description = "The GCS bucket where rules will be uploaded"
  type        = "string"
}

variable "org_id" {
  description = "The organization ID"
}

variable "domain" {
  description = "The domain associated with the GCP Organization ID"
}
