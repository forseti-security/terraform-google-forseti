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

provider "google" {
  version = "~> 3.7.0"
  project = var.project_id
}

locals {
  service_list = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "dns.googleapis.com"
  ]
}

resource "google_project_service" "main" {
  count              = length(local.service_list)
  project            = var.project_id
  service            = local.service_list[count.index]
  disable_on_destroy = "false"
}

resource "google_compute_network" "network" {
  name                    = "forseti-network-2"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "forseti-subnet-2"
  region                   = var.region
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}

# Router to control egress connectivity
resource "google_compute_router" "forseti-router" {
  count   = var.block_egress ? 0 : 1
  name    = "forseti-network-router"
  network = google_compute_network.network.name
  region  = var.region
}

resource "google_compute_router_nat" "forseti-nat" {
  count  = var.block_egress ? 0 : 1
  name   = "forseti-network-router-nat"
  router = google_compute_router.forseti-router[count.index].name
  region = google_compute_router.forseti-router[count.index].region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  nat_ips                          = []
  min_ports_per_vm                 = "64"
  udp_idle_timeout_sec             = "30"
  icmp_idle_timeout_sec            = "30"
  tcp_established_idle_timeout_sec = "1200"
  tcp_transitory_idle_timeout_sec  = "30"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Private DNS zone to forward Google API calls
resource "google_dns_managed_zone" "forseti-private-zone" {
  name        = "forseti-private-zone"
  dns_name    = "googleapis.com."
  description = "private zone for Google API private access"
  visibility  = "private"
  private_visibility_config {
    networks {
      network_url = google_compute_network.network.self_link
    }
  }

  depends_on = [google_project_service.main]
}

resource "google_dns_record_set" "forseti-private-zone-cname" {
  managed_zone = google_dns_managed_zone.forseti-private-zone.name
  name         = "*.${google_dns_managed_zone.forseti-private-zone.dns_name}"
  type         = "CNAME"
  ttl          = 300
  rrdatas      = ["private.googleapis.com."]
}

resource "google_dns_record_set" "forseti-private-zone-a" {
  managed_zone = google_dns_managed_zone.forseti-private-zone.name
  name         = "private.${google_dns_managed_zone.forseti-private-zone.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = ["199.36.153.8", "199.36.153.10", "199.36.153.9", "199.36.153.11"]
}

# Route calls to private API via default-internet-router
resource "google_compute_route" "forseti-private-vip-route" {
  name             = "forseti-private-vip-route"
  dest_range       = "199.36.153.8/30"
  priority         = 100
  network          = google_compute_network.network.name
  next_hop_gateway = "default-internet-gateway"
}

# Forseti deployment.
module "forseti" {
  source     = "../../"
  domain     = var.domain
  project_id = var.project_id
  org_id     = var.org_id
  composite_root_resources = [
    "organizations/${var.org_id}",
  ]
  config_validator_enabled = true
  server_private           = true
  client_enabled           = false
  cloudsql_private         = true
  server_region            = var.region
  server_instance_metadata = var.instance_metadata
  client_region            = var.region
  cloudsql_region          = var.region
  storage_bucket_location  = var.region
  bucket_cai_location      = var.region
  network                  = google_compute_network.network.name
  subnetwork               = google_compute_subnetwork.subnet.name
  forseti_version          = var.forseti_version
}

resource "google_compute_firewall" "forseti-server-allow-sql-connection" {
  name                    = "forseti-server-allow-sql-connection"
  network                 = google_compute_network.network.name
  direction               = "EGRESS"
  target_service_accounts = [module.forseti.forseti-server-service-account]
  destination_ranges      = [module.forseti.forseti-cloudsql-instance-ip]
  priority                = "1000"

  allow {
    protocol = "tcp"
    ports    = ["3306", "3307"]
  }
}

# this rule enables egress during setup and limits egress only to Google Cloud managed services rest of the time
resource "google_compute_firewall" "forseti-server-allow-internet" {
  name                    = "forseti-server-allow-internet"
  network                 = google_compute_network.network.name
  direction               = "EGRESS"
  target_service_accounts = [module.forseti.forseti-server-service-account]
  destination_ranges      = var.block_egress ? ["199.36.153.8/30"] : ["0.0.0.0/0"]
  priority                = "1000"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "icmp"
    ports    = []
  }
}

# this rule simulates an environment that a default block all egress traffic firewall is enforced
resource "google_compute_firewall" "block-all-egress" {
  name               = "block-all-egress"
  network            = google_compute_network.network.name
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  priority           = "2000"

  deny {
    protocol = "all"
  }
}
