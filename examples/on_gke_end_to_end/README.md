# Forseti on GKE - End-to-End
Follow this example you desire to deploy Forseti on GKE but are starting from an empty GCP project.  In otherwords, Forseti has not been yet been deployed.

This example deploys the following:
1. A new VPC
2. Forseti infrstructure
3. A new GKE cluster - terraform-google-modules/kubernetes-engine/google
4. Forseti on GKE - forseti-on-gke

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| gke\_cluster\_name | The name of the GKE Cluster | string | `"forseti-cluster"` | no |
| gke\_node\_ip\_range | The IP range for the GKE nodes. | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range | The IP range of the Kubernetes pods | string | `"10.2.0.0/20"` | no |
| gke\_service\_account | The service account to run nodes as if not overridden in node\_pools. The default value will cause a cluster-specific service account to be created. | string | `"create"` | no |
| gke\_service\_ip\_range | The IP range of the Kubernetes services. | string | `"10.3.0.0/20"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | `""` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"latest"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"latest"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network\_name | The name of the VPC being created | string | `"gke-network"` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | `""` | no |
| production | Whether or not to deploy Forseti on GKE in a production configuration | string | `"true"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | n/a | yes |
| sub\_network\_name | The names of the subnet being created | string | `"gke-sub-network"` | no |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | list | `<list>` | no |

[^]: (autogen_docs_end)
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
- [Terraform Provider for GCP][terraform-provider-google] v2.9

### Configure a Service Account
In order to execute this module you must have a Service Account with the
following project roles:
- roles/compute.viewer
- roles/container.clusterAdmin
- roles/container.developer
- roles/iam.serviceAccountAdmin
- roles/iam.serviceAccountUser
- roles/resourcemanager.projectIamAdmin (only required if `service_account` is set to `create`)

### Enable APIs
In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Kubernetes Engine API - container.googleapis.com
- Container Registry API - containerregistry.googleapis.com
