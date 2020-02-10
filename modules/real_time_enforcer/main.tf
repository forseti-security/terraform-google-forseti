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

locals {
  random_hash          = var.suffix
  network_project      = var.network_project != "" ? var.network_project : var.project_id
  enforcer_name        = "forseti-enforcer-vm-${local.random_hash}"
  enforcer_sa_name     = "forseti-enforcer-gcp-${local.random_hash}"
  enforcer_bucket_name = "forseti-enforcer-${local.random_hash}"
  enforcer_zone        = "${var.enforcer_region}-c"

  real_time_enforcer_policy_files = [
    "policy/bigquery/common.rego",
    "policy/bigquery/dataset_no_public_access.rego",
    "policy/bigquery/dataset_no_public_authenticated_access.rego",
    "policy/cloudresourcemanager/common_iam.rego",
    "policy/config.yaml",
    "policy/exclusions.rego",
    "policy/policies.rego",
    "policy/sql/acl.rego",
    "policy/sql/backups.rego",
    "policy/sql/common.rego",
    "policy/sql/require_ssl.rego",
    "policy/storage/bucket_iam_disallow_allauthenticatedusers.rego",
    "policy/storage/bucket_iam_disallow_allusers.rego",
    "policy/storage/common.rego",
    "policy/storage/common_iam.rego",
    "policy/storage/versioning.rego",
  ]

  real_time_enforcer_project_roles = [
    "roles/logging.logWriter",
  ]

  network_interface_base = {
    private = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
    }]

    public = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
      access_config      = [var.enforcer_instance_access_config]
    }]
  }

  network_interface = local.network_interface_base[var.enforcer_instance_private ? "private" : "public"]
}

resource "google_service_account" "main" {
  account_id   = local.enforcer_sa_name
  project      = var.project_id
  display_name = "Forseti Real Time Enforcer"
}

resource "google_organization_iam_member" "enforcer-viewer" {
  org_id = var.org_id
  role   = var.enforcer_viewer_role
  member = "serviceAccount:${google_service_account.main.email}"
}

resource "google_organization_iam_member" "enforcer-writer" {
  org_id = var.org_id
  role   = var.enforcer_writer_role
  member = "serviceAccount:${google_service_account.main.email}"
}

#---------------------#
# Enforcer GCS Bucket #
#---------------------#

resource "google_storage_bucket" "main" {
  name               = local.enforcer_bucket_name
  location           = var.storage_bucket_location
  project            = var.project_id
  force_destroy      = true
  bucket_policy_only = true
}

resource "google_storage_bucket_iam_member" "service_account_read" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.main.email}"
}

resource "google_storage_bucket_object" "enforcer_policy" {
  count  = length(local.real_time_enforcer_policy_files)
  name   = element(local.real_time_enforcer_policy_files, count.index)
  source = "${path.module}/files/${element(local.real_time_enforcer_policy_files, count.index)}"
  bucket = google_storage_bucket.main.name

  lifecycle {
    ignore_changes = [
      content,
      detect_md5hash,
    ]
  }
}

#-----------------------#
# Enforcer GCE instance #
#-----------------------#

data "template_file" "cloud-init" {
  template = file("${path.module}/templates/cloud-init.yml")

  vars = {
    project_id        = var.project_id
    enforcer_bucket   = google_storage_bucket.main.name
    subscription_name = google_pubsub_subscription.main.name
  }
}

resource "google_compute_instance" "main" {
  name = local.enforcer_name
  zone = local.enforcer_zone

  project                   = var.project_id
  machine_type              = var.enforcer_type
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.enforcer_boot_image
    }
  }
  dynamic "network_interface" {
    for_each = local.network_interface
    content {
      # Field `address` has been deprecated. Use `network_ip` instead.
      # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
      network            = lookup(network_interface.value, "network", null)
      network_ip         = lookup(network_interface.value, "network_ip", null)
      subnetwork         = lookup(network_interface.value, "subnetwork", null)
      subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)

      dynamic "access_config" {
        for_each = lookup(network_interface.value, "access_config", [])
        content {
          nat_ip                 = lookup(access_config.value, "nat_ip", null)
          network_tier           = lookup(access_config.value, "network_tier", null)
          public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
        }
      }

      dynamic "alias_ip_range" {
        for_each = lookup(network_interface.value, "alias_ip_range", [])
        content {
          ip_cidr_range         = alias_ip_range.value.ip_cidr_range
          subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
        }
      }
    }
  }

  metadata = merge(
    var.enforcer_instance_metadata,
    {
      "user-data" = data.template_file.cloud-init.rendered
    },
  )

  service_account {
    email  = google_service_account.main.email
    scopes = ["cloud-platform"]
  }
}

#-------------------------#
# Enforcer Firewall Rules #
#-------------------------#
resource "google_compute_firewall" "rt-enforcer-deny-all" {
  count                   = var.manage_firewall_rules ? 1 : 0
  name                    = "forseti-rt-enforcer-deny-all-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [google_service_account.main.email]
  source_ranges           = ["0.0.0.0/0"]
  priority                = "200"

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "udp"
  }

  deny {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "rt-enforcer-ssh-external" {
  count                   = var.manage_firewall_rules ? 1 : 0
  name                    = "forseti-rt-enforcer-ssh-external-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [google_service_account.main.email]
  source_ranges           = var.enforcer_ssh_allow_ranges
  priority                = "100"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_project_iam_member" "main" {
  count   = length(local.real_time_enforcer_project_roles)
  project = var.project_id
  role    = element(local.real_time_enforcer_project_roles, count.index)
  member  = "serviceAccount:${google_service_account.main.email}"
}

