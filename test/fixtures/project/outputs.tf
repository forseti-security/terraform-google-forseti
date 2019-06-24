output "project_id" {
  value = "${module.project_factory.project_id}"

  description = "The ID of the project."
}

output "network" {
  value = "${module.network.network_name}"

  description = "The name of the network."
}

output "region" {
  value = "${module.network.subnets_regions[0]}"

  description = "The name of the subnetwork."
}

output "service_account_private_key" {
  value = "${base64decode(google_service_account_key.forseti.private_key)}"

  description = "The private key of the service account."
  sensitive   = true
}

output "subnetwork" {
  value = "${module.network.subnets_self_links[0]}"

  description = "The self link of the subnetwork."
}

output "zone" {
  value = "${data.google_compute_zones.main.names[0]}"

  description = "A zone available to the subnetwork."
}
