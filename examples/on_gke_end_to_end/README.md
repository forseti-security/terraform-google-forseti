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
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | bool | `"false"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| git\_sync\_image | The container image used by the config-validator git-sync side-car | string | `"gcr.io/google-containers/git-sync"` | no |
| git\_sync\_image\_tag | The container image tag used by the config-validator git-sync side-car | string | `"v3.1.2"` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the private SSH key allowing the git-sync to clone the policy library repository. | string | `""` | no |
| git\_sync\_ssh | Use SSH for git-sync operations | bool | `"false"` | no |
| git\_sync\_wait | The time number of seconds between git-syncs | string | `"30"` | no |
| gke\_cluster\_name | The name of the GKE Cluster | string | `"forseti-cluster"` | no |
| gke\_node\_ip\_range | The IP range for the GKE nodes. | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range | The IP range of the Kubernetes pods | string | `"10.2.0.0/20"` | no |
| gke\_service\_account | The service account to run nodes as if not overridden in node\_pools. The default value will cause a cluster-specific service account to be created. | string | `"create"` | no |
| gke\_service\_ip\_range | The IP range of the Kubernetes services. | string | `"10.3.0.0/20"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | n/a | yes |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_config\_validator\_image | The container image used by the config-validator | string | `"gcr.io/forseti-containers/config-validator"` | no |
| k8s\_config\_validator\_image\_tag | The tag for the config-validator image. | string | `"latest"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"forseti"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.20.0"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.20.0"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| load\_balancer | The type of load balancer to deploy for the forseti-server if desired: none, external, internal | string | `"internal"` | no |
| network\_description | An optional description of the network. The resource must be recreated to modify this field. | string | `""` | no |
| network\_name | The name of the VPC being created | string | `"forseti-gke-network"` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `"https://github.com/forseti-security/policy-library"` | no |
| production | Whether or not to deploy Forseti on GKE in a production configuration | bool | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | `"us-central1"` | no |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |
| sub\_network\_name | The name of the subnet being created | string | `"gke-sub-network"` | no |
| zones | The zones to host the cluster in. This is optional if the GKE cluster is regional.  It is required if the cluster is zonal. | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-client-service-account | Forseti Client service account |
| forseti-client-storage-bucket | Forseti Client storage bucket |
| forseti-client-vm-ip | Forseti Client VM private IP address |
| forseti-client-vm-name | Forseti Client VM name |
| forseti-server-service-account | Forseti Server service account |
| forseti-server-storage-bucket | Forseti Server storage bucket |
| forseti-server-vm-ip | Forseti Server VM private IP address |
| forseti-server-vm-name | Forseti Server VM name |
| suffix | The random suffix appended to Forseti resources |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

