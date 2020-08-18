# Forseti on-GKE
Follow this example to deploy Forseti on-GKE if you already have a GKE cluster.

This example deploys the following:
1. Forseti infrastructure
   * CloudSQL Database
   * Forseti Server GCS Bucket
   * Forseti Client GCS Bucket
   * Forseti Client VM
   * Forseti Server IAM Service Account
   * Forseti Client IAM Service Account
2. Forseti on GKE - forseti-on-gke

## Import an Existing Forseti Deployment
If you previously deployed Forseti either with Terraform or Deployment manager, that deployment can be migrated to Forseti on-GKE.  Please follow the [upgrade guide](../../docs/upgrading_to_v5.0.md) if you wish to reuse components (GCS buckets, CloudSQL etc.) for Forseti on-GKE.

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine, Kubernetes Engine, and Container Registry APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.
5. A GKE cluser (v1.12+) with the [workload-identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) addon enabled.

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
- roles/iam.serviceAccountKeyAdmin
- roles/compute.networkAdmin
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com
- Container Registry API - containerregistry.googleapis.com

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | bool | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the SSH key allowing the git-sync to clone the policy library repository. | string | `"null"` | no |
| gke\_cluster\_location | The location of the GKE Cluster | string | n/a | yes |
| gke\_cluster\_name | The name of the GKE Cluster | string | n/a | yes |
| gke\_node\_pool\_name | The name of the GKE node-pool where Forseti is being deployed | string | `"default-pool"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | n/a | yes |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | bool | `"false"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | `"default"` | no |
| workload\_identity\_namespace | Workload Identity namespace | string | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| config-validator-git-public-key-openssh | The public OpenSSH key generated to allow the Forseti Server to clone the policy library repository. |
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-cloudsql-connection-name | Forseti CloudSQL Connection String |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| kubernetes-forseti-namespace | The Kubernetes namespace in which Forseti is deployed |
| kubernetes-forseti-server-ingress | The loadbalancer ingress address of the forseti-server service in GKE |
| kubernetes-forseti-tiller-sa-name | The name of the service account deploying Forseti |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
