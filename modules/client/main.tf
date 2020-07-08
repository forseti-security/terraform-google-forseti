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
  client_startup_script = file(
    "${path.module}/templates/scripts/forseti-client/forseti_client_startup_script.sh.tpl",
  )
  client_env_script = file(
    "${path.module}/templates/scripts/forseti-client/forseti_environment.sh.tpl",
  )

  client_conf_path = "${var.forseti_home}/configs/forseti_conf_client.yaml"

  client_name = "forseti-client-vm-${var.suffix}"
  client_zone = "${var.client_region}-c"

  network_project = var.network_project != "" ? var.network_project : var.project_id

  network_interface_base = {
    private = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
    }],

    public = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
      access_config      = [var.client_access_config]
    }],

  }

  network_interface = local.network_interface_base[var.client_private ? "private" : "public"]
}

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_client_startup_script" {
  count    = var.client_enabled ? 1 : 0
  template = local.client_startup_script

  vars = {
    forseti_environment      = data.template_file.forseti_client_environment[0].rendered
    forseti_repo_url         = var.forseti_repo_url
    forseti_version          = var.forseti_version
    forseti_home             = var.forseti_home
    forseti_client_conf_path = local.client_conf_path
    google_cloud_sdk_version = var.google_cloud_sdk_version
    storage_bucket_name      = var.client_gcs_module.forseti-client-storage-bucket
  }
}

data "template_file" "forseti_client_environment" {
  count    = var.client_enabled ? 1 : 0
  template = local.client_env_script

  vars = {
    forseti_home             = var.forseti_home
    forseti_client_conf_path = local.client_conf_path
  }
}

#-------------------#
# Forseti client VM #
#-------------------#
resource "google_compute_instance" "forseti-client" {
  count                     = var.client_enabled ? 1 : 0
  name                      = local.client_name
  zone                      = local.client_zone
  project                   = var.project_id
  machine_type              = var.client_type
  tags                      = var.client_tags
  labels                    = var.client_labels
  allow_stopping_for_update = true
  metadata                  = var.client_instance_metadata
  metadata_startup_script   = data.template_file.forseti_client_startup_script[0].rendered
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

  boot_disk {
    initialize_params {
      image = var.client_boot_image
    }
  }

  service_account {
    email  = var.client_iam_module.forseti-client-service-account
    scopes = ["cloud-platform"]
  }

  dynamic "shielded_instance_config" {
    for_each = var.client_shielded_instance_config == null ? [] : [var.client_shielded_instance_config]
    content {
      enable_secure_boot          = lookup(var.client_shielded_instance_config, "enable_secure_boot", null)
      enable_vtpm                 = lookup(var.client_shielded_instance_config, "enable_vtpm", null)
      enable_integrity_monitoring = lookup(var.client_shielded_instance_config, "enable_integrity_monitoring", null)
    }
  }

  depends_on = [
    null_resource.services-dependency,
    var.client_config_module,
  ]
}

#------------------------#
# Forseti firewall rules #
#------------------------#
resource "google_compute_firewall" "forseti-client-deny-all" {
  count                   = var.client_enabled && var.manage_firewall_rules ? 1 : 0
  name                    = "forseti-client-deny-all-${var.suffix}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.client_iam_module.forseti-client-service-account]
  source_ranges           = ["0.0.0.0/0"]
  priority                = "200"
  enable_logging          = var.firewall_logging

  deny {
    protocol = "icmp"
  }

  deny {
    protocol = "udp"
  }

  deny {
    protocol = "tcp"
  }

  depends_on = [null_resource.services-dependency]
}

resource "google_compute_firewall" "forseti-client-ssh-external" {
  count                   = var.client_enabled && var.manage_firewall_rules && ! var.client_private ? 1 : 0
  name                    = "forseti-client-ssh-external-${var.suffix}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.client_iam_module.forseti-client-service-account]
  source_ranges           = var.client_ssh_allow_ranges
  priority                = "100"
  enable_logging          = var.firewall_logging

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [null_resource.services-dependency]
}

resource "google_compute_firewall" "forseti-client-ssh-iap" {
  count                   = var.client_enabled && var.manage_firewall_rules && var.client_private ? 1 : 0
  name                    = "forseti-client-ssh-iap-${var.suffix}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.client_iam_module.forseti-client-service-account]
  source_ranges           = ["35.235.240.0/20"]
  priority                = "100"
  enable_logging          = var.firewall_logging

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [null_resource.services-dependency]
}

resource "null_resource" "services-dependency" {
  count = var.client_enabled ? 1 : 0
  triggers = {
    services = jsonencode(var.services)
  }
}
