resource "random_pet" "main" {
  length    = "1"
  prefix    = "forseti-simple-example"
  separator = "-"
}

resource "google_compute_router" "main" {
  name    = "${random_pet.main.id}"
  network = "default"

  bgp {
    asn = "64514"
  }

  region  = "us-central1"
  project = "${var.project_id}"
}

data "google_compute_subnetwork" "main" {
  name    = "default"
  project = "${var.project_id}"
  region  = "${google_compute_router.main.region}"
}

resource "google_compute_router_nat" "main" {
  name                               = "${random_pet.main.id}"
  router                             = "${google_compute_router.main.name}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = "${data.google_compute_subnetwork.main.self_link}"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  project = "${var.project_id}"
  region  = "${google_compute_router.main.region}"
}
