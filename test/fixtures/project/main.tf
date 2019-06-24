module "project_factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 2.4"

  billing_account = "${var.billing_account}"
  name            = "forseti-test"
  org_id          = "${var.org_id}"

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "storage-api.googleapis.com",
  ]

  apis_authority              = "false"
  disable_dependent_services  = "true"
  disable_services_on_destroy = "true"
  folder_id                   = "${var.folder_id}"
  random_project_id           = "true"
  shared_vpc                  = "${var.shared_vpc}"
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 0.8"

  network_name = "forseti-test"
  project_id   = "${module.project_factory.project_id}"

  secondary_ranges {
    forseti-test = []
  }

  subnets = [
    {
      subnet_name   = "forseti-test"
      subnet_ip     = "10.128.0.0/20"
      subnet_region = "us-central1"
    },
  ]
}

data "google_compute_zones" "main" {
  project = "${module.project_factory.project_id}"
  region  = "${module.network.subnets_regions[0]}"
  status  = "UP"
}

locals {
  service_account_member = "serviceAccount:${module.project_factory.service_account_email}"
}

resource "google_organization_iam_member" "organization_admin" {
  member = "${local.service_account_member}"
  org_id = "${var.org_id}"
  role   = "roles/resourcemanager.organizationAdmin"
}

resource "google_organization_iam_member" "organization_role_admin" {
  member = "${local.service_account_member}"
  org_id = "${var.org_id}"
  role   = "roles/iam.organizationRoleAdmin"
}

resource "google_organization_iam_member" "config_writer" {
  member = "${local.service_account_member}"
  org_id = "${var.org_id}"
  role   = "roles/logging.configWriter"
}

resource "google_project_iam_member" "host_compute_admin" {
  count = "${var.shared_vpc == "" ? 0 : 1}"

  member  = "${local.service_account_member}"
  project = "${var.shared_vpc}"
  role    = "roles/compute.admin"
}

resource "google_project_iam_member" "instance_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/compute.instanceAdmin"
}

resource "google_project_iam_member" "network_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/compute.networkAdmin"
}

resource "google_project_iam_member" "security_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/compute.securityAdmin"
}

resource "google_project_iam_member" "service_account_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/iam.serviceAccountAdmin"
}

resource "google_project_iam_member" "service_account_user" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/iam.serviceAccountUser"
}

resource "google_project_iam_member" "service_usage_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/serviceusage.serviceUsageAdmin"
}

resource "google_project_iam_member" "storage_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/storage.admin"
}

resource "google_project_iam_member" "cloudsql_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/cloudsql.admin"
}

resource "google_project_iam_member" "pubsub_admin" {
  member  = "${local.service_account_member}"
  project = "${module.project_factory.project_id}"
  role    = "roles/pubsub.admin"
}

resource "google_project_iam_member" "enforcer_storage_admin" {
  count = "${var.real_time_enforcer == "" ? 0 : 1}"

  project = "${var.real_time_enforcer}"
  role    = "roles/storage.admin"
  member  = "${local.service_account_member}"
}

resource "google_service_account_key" "forseti" {
  service_account_id = "projects/${module.project_factory.project_id}/serviceAccounts/${module.project_factory.service_account_unique_id}"
}
