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

resource "random_integer" "random_minute" {
  min = 0
  max = 59
}

#--------#
# Locals #
#--------#
locals {
  random_hash     = var.suffix
  network_project = var.network_project != "" ? var.network_project : var.project_id
  server_zone     = "${var.server_region}-c"
  server_startup_script = file(
    "${path.module}/templates/scripts/forseti-server/forseti_server_startup_script.sh.tpl",
  )
  server_environment = file(
    "${path.module}/templates/scripts/forseti-server/forseti_environment.sh.tpl",
  )
  server_env = file(
    "${path.module}/templates/scripts/forseti-server/forseti_env.sh.tpl",
  )
  server_run_forseti = file(
    "${path.module}/templates/scripts/forseti-server/run_forseti.sh.tpl",
  )
  server_initialize_services = file(
    "${path.module}/templates/scripts/forseti-server/initialize_forseti_services.sh.tpl",
  )
  server_conf_path = "${var.forseti_home}/configs/forseti_conf_server.yaml"
  server_name      = "forseti-server-vm-${local.random_hash}"

  network_interface_base = {
    private = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
    }],

    public = [{
      subnetwork_project = local.network_project
      subnetwork         = var.subnetwork
      access_config      = [var.server_access_config]
    }],

  }
  network_interface = local.network_interface_base[var.server_private ? "private" : "public"]

  forseti_run_frequency = var.forseti_run_frequency == null ? "${random_integer.random_minute.result} */2 * * *" : var.forseti_run_frequency

  git_sync_public_ssh_key = length(tls_private_key.policy_library_sync_ssh) == 1 ? tls_private_key.policy_library_sync_ssh[0].public_key_openssh : ""
}

#-------------------#
# Forseti templates #
#-------------------#
data "template_file" "forseti_server_startup_script" {
  template = local.server_startup_script

  vars = {
    cloudsql_proxy_arch                    = var.cloudsql_proxy_arch
    cloud_profiler_enabled                 = var.cloud_profiler_enabled
    forseti_conf_server_checksum           = base64sha256(var.server_config_module.forseti-server-config)
    forseti_env                            = data.template_file.forseti_server_env.rendered
    forseti_environment                    = data.template_file.forseti_server_environment.rendered
    forseti_home                           = var.forseti_home
    forseti_run_forseti_services_md5_hash  = google_storage_bucket_object.run_forseti_script.md5hash
    forseti_init_services_md5_hash         = google_storage_bucket_object.initialize_forseti_services_script.md5hash
    forseti_repo_url                       = var.forseti_repo_url
    forseti_run_frequency                  = local.forseti_run_frequency
    forseti_scripts                        = var.forseti_scripts
    forseti_server_conf_path               = local.server_conf_path
    forseti_version                        = var.forseti_version
    google_cloud_sdk_version               = var.google_cloud_sdk_version
    mailjet_enabled                        = var.mailjet_enabled
    policy_library_home                    = var.policy_library_home
    policy_library_sync_enabled            = var.policy_library_sync_enabled
    policy_library_sync_gcs_directory_name = var.policy_library_sync_gcs_directory_name
    storage_bucket_name                    = var.server_gcs_module.forseti-server-storage-bucket
  }
}

data "template_file" "forseti_server_environment" {
  template = local.server_environment

  vars = {
    forseti_home                     = var.forseti_home
    forseti_server_conf_path         = local.server_conf_path
    policy_library_home              = var.policy_library_home
    policy_library_sync_enabled      = var.policy_library_sync_enabled
    policy_library_repository_branch = var.policy_library_repository_branch
    policy_library_repository_url    = var.policy_library_repository_url
    policy_library_sync_git_sync_tag = var.policy_library_sync_git_sync_tag
    storage_bucket_name              = var.server_gcs_module.forseti-server-storage-bucket
  }
}

data "template_file" "forseti_server_env" {
  template = local.server_env

  vars = {
    project_id             = var.project_id
    cloudsql_db_name       = var.cloudsql_module.forseti-cloudsql-db-name
    cloudsql_db_port       = var.cloudsql_module.forseti-cloudsql-db-port
    cloudsql_region        = var.cloudsql_module.forseti-cloudsql-region
    cloudsql_instance_name = var.cloudsql_module.forseti-cloudsql-instance-name
    cloudsql_db_user       = var.cloudsql_module.forseti-cloudsql-user
    cloudsql_db_password   = var.cloudsql_module.forseti-cloudsql-password
    forseti_scripts        = var.forseti_scripts
  }
}

data "template_file" "forseti_server_run" {
  template = local.server_run_forseti

  vars = {
    forseti_home                = var.forseti_home
    forseti_server_conf_path    = local.server_conf_path
    forseti_scripts             = var.forseti_scripts
    policy_library_home         = var.policy_library_home
    policy_library_sync_enabled = var.policy_library_sync_enabled
    project_id                  = var.project_id
    storage_bucket_name         = var.server_gcs_module.forseti-server-storage-bucket
    cloudsql_db_name            = var.cloudsql_module.forseti-cloudsql-db-name
    cloudsql_db_password        = var.cloudsql_module.forseti-cloudsql-password
    cloudsql_db_port            = var.cloudsql_module.forseti-cloudsql-db-port
    cloudsql_region             = var.cloudsql_module.forseti-cloudsql-region
    cloudsql_db_user            = var.cloudsql_module.forseti-cloudsql-user
    cloudsql_instance_name      = var.cloudsql_module.forseti-cloudsql-instance-name
  }
}

data "template_file" "forseti_server_initialize_services" {
  template = local.server_initialize_services

  vars = {
    cloudsql_connection_name         = var.cloudsql_module.forseti-cloudsql-connection-name
    cloudsql_db_name                 = var.cloudsql_module.forseti-cloudsql-db-name
    cloudsql_db_port                 = var.cloudsql_module.forseti-cloudsql-db-port
    cloudsql_db_user                 = var.cloudsql_module.forseti-cloudsql-user
    cloudsql_db_password             = var.cloudsql_module.forseti-cloudsql-password
    config_validator_image           = var.config_validator_image
    config_validator_image_tag       = var.config_validator_image_tag
    forseti_home                     = var.forseti_home
    forseti_server_conf_path         = local.server_conf_path
    policy_library_home              = var.policy_library_home
    policy_library_repository_branch = var.policy_library_repository_branch
    policy_library_repository_url    = var.policy_library_repository_url
    policy_library_sync_enabled      = var.policy_library_sync_enabled
    policy_library_sync_git_sync_tag = var.policy_library_sync_git_sync_tag
  }
}

#------------------------#
# Forseti Firewall Rules #
#------------------------#
resource "google_compute_firewall" "forseti-server-deny-all" {
  count                   = var.manage_firewall_rules ? 1 : 0
  name                    = "forseti-server-deny-all-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.server_iam_module.forseti-server-service-account]
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

  depends_on = [null_resource.services-dependency]
}

resource "google_compute_firewall" "forseti-server-ssh-external" {
  count                   = var.manage_firewall_rules && ! var.server_private ? 1 : 0
  name                    = "forseti-server-ssh-external-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.server_iam_module.forseti-server-service-account]
  source_ranges           = var.server_ssh_allow_ranges
  priority                = "100"
  enable_logging          = var.firewall_logging

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [null_resource.services-dependency]
}

resource "google_compute_firewall" "forseti-server-ssh-iap" {
  count                   = var.manage_firewall_rules && var.server_private ? 1 : 0
  name                    = "forseti-server-ssh-iap-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.server_iam_module.forseti-server-service-account]
  source_ranges           = ["35.235.240.0/20"]
  priority                = "100"
  enable_logging          = var.firewall_logging

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  depends_on = [null_resource.services-dependency]
}

resource "google_compute_firewall" "forseti-server-allow-grpc" {
  count                   = var.manage_firewall_rules ? 1 : 0
  name                    = "forseti-server-allow-grpc-${local.random_hash}"
  project                 = local.network_project
  network                 = var.network
  target_service_accounts = [var.server_iam_module.forseti-server-service-account]
  source_ranges           = var.server_grpc_allow_ranges
  source_service_accounts = var.client_iam_module.forseti-client-service-account != null ? [var.client_iam_module.forseti-client-service-account] : null
  priority                = "100"
  enable_logging          = var.firewall_logging

  allow {
    protocol = "tcp"
    ports    = ["50051", "50052"]
  }

  depends_on = [null_resource.services-dependency]
}

#------------------------#
# Forseti Storage bucket #
#------------------------#

resource "tls_private_key" "policy_library_sync_ssh" {
  count     = var.policy_library_sync_enabled ? 1 : 0
  algorithm = "RSA"
}

resource "google_storage_bucket_object" "policy_library_sync_ssh_key" {
  count   = var.policy_library_sync_enabled && var.policy_library_repository_url != "" ? 1 : 0
  name    = "${var.policy_library_sync_gcs_directory_name}/ssh"
  content = tls_private_key.policy_library_sync_ssh[0].private_key_pem
  bucket  = var.server_gcs_module.forseti-server-storage-bucket

  depends_on = [
    tls_private_key.policy_library_sync_ssh,
  ]
}

resource "google_storage_bucket_object" "policy_library_sync_ssh_known_hosts" {
  count   = var.policy_library_sync_enabled && var.policy_library_sync_ssh_known_hosts != "" ? 1 : 0
  name    = "${var.policy_library_sync_gcs_directory_name}/known_hosts"
  content = var.policy_library_sync_ssh_known_hosts
  bucket  = var.server_gcs_module.forseti-server-storage-bucket
}

resource "google_storage_bucket_object" "run_forseti_script" {
  name    = "scripts/run_forseti.sh"
  content = data.template_file.forseti_server_run.rendered
  bucket  = var.server_gcs_module.forseti-server-storage-bucket
}

resource "google_storage_bucket_object" "initialize_forseti_services_script" {
  name    = "scripts/initialize_forseti_services.sh"
  content = data.template_file.forseti_server_initialize_services.rendered
  bucket  = var.server_gcs_module.forseti-server-storage-bucket
}

#-------------------------#
# Forseti server instance #
#-------------------------#
resource "google_compute_instance" "forseti-server" {
  name                      = local.server_name
  zone                      = local.server_zone
  project                   = var.project_id
  machine_type              = var.server_type
  tags                      = var.server_tags
  labels                    = var.server_labels
  allow_stopping_for_update = true
  metadata                  = var.server_instance_metadata
  metadata_startup_script   = data.template_file.forseti_server_startup_script.rendered

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
      image = var.server_boot_image
      size  = var.server_boot_disk_size
      type  = var.server_boot_disk_type
    }
  }

  service_account {
    email  = var.server_iam_module.forseti-server-service-account
    scopes = ["cloud-platform"]
  }

  dynamic "shielded_instance_config" {
    for_each = var.server_shielded_instance_config == null ? [] : [var.server_shielded_instance_config]
    content {
      enable_secure_boot          = lookup(var.server_shielded_instance_config, "enable_secure_boot", null)
      enable_vtpm                 = lookup(var.server_shielded_instance_config, "enable_vtpm", null)
      enable_integrity_monitoring = lookup(var.server_shielded_instance_config, "enable_integrity_monitoring", null)
    }
  }

  depends_on = [
    var.server_iam_module,
    var.server_rules_module,
    null_resource.services-dependency,
  ]
}

resource "null_resource" "services-dependency" {
  triggers = {
    services = jsonencode(var.services)
  }
}
