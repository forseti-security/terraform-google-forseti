# Forseti on GKE - End-to-End
Follow this example to deploy Forseti on GKE but are starting from an empty GCP project.  In otherwords, Forseti has not been yet been deployed.

This example deploys the following:
1. A new VPC
2. Forseti infrastructure
   * CloudSQL Database
   * Forseti Server GCS Bucket
   * Forseti Client GCS Bucket
   * Forseti Server VM
   * Forseti Client VM
   * Forseti Server IAM Service Account
   * Forseti Client IAM Service Account
3. A new GKE cluster - terraform-google-modules/kubernetes-engine/google
4. Forseti on GKE - forseti-on-gke

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine, Kubernetes Engine, and Container Registry APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active and the necessary Shared VPC connections.

### Software Dependencies
#### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12
- [Terraform Provider for GCP](https://www.terraform.io/docs/providers/google/index.html) v2.9

### Configure a Service Account
In addition to the [roles](https://github.com/forseti-security/terraform-google-forseti#iam-roles) required for the core module function, the Service Account must have these roles for this example.
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com
- Container Registry API - containerregistry.googleapis.com

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
