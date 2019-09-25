# Forseti on GKE

This sub-module deploys Forseti on GKE.  In short, this deploys a server container as a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and an orchestrator container as a Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).  Please see the [Forseti Security GKE Concepts](https://forsetisecurity.org/docs/latest/concepts/forseti-on-gke.html) documentation for more details
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:

1. Terraform and kubectl are [installed](#software-dependencies) on the machine where Terraform is executed.
2. The Service Account you execute the module with has the right [permissions](#configure-a-service-account).
3. The Compute Engine, Kubernetes Engine, and Container Registry APIs are [active](#enable-apis) on the project you will launch the cluster in.
4. If you are using a Shared VPC, the APIs must also be activated on the Shared VPC host project and your service account needs the proper permissions there.
5. Forseti has been deployed into a GCP project, preferably the same project in which this Forseti on GKE is intended to be installed.

The [project factory](https://github.com/terraform-google-modules/terraform-google-project-factory) can be used to provision projects with the correct APIs active and the necessary Shared VPC connections.

### Software Dependencies
#### Kubectl
- [kubectl](https://github.com/kubernetes/kubernetes/releases) 1.9.x
#### Terraform and Plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12
- [Terraform Provider for GCP](https://www.terraform.io/docs/providers/google/index.html) v2.9

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| forseti\_client\_service\_account | Forseti Client service account | string | n/a | yes |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | n/a | yes |
| forseti\_cloudsql\_connection\_name | Forseti CloudSQL Connection String | string | n/a | yes |
| forseti\_server\_bucket | Forseti Server storage bucket | string | n/a | yes |
| forseti\_server\_service\_account | Forseti Server service account | string | n/a | yes |
| git\_sync\_image | The container image used by the config-validator git-sync side-car | string | `"gcr.io/google-containers/git-sync"` | no |
| git\_sync\_image\_tag | The container image tag used by the config-validator git-sync side-car | string | `"v3.1.2"` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the private SSH key allowing the git-sync to clone the policy library repository. | string | `""` | no |
| git\_sync\_ssh | Use SSH for git-sync operations | bool | `"true"` | no |
| git\_sync\_wait | The time number of seconds between git-syncs | string | `"30"` | no |
| gke\_service\_account | The name of the IAM service account attached to the GKE cluster node-pool | string | n/a | yes |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_config\_validator\_image | The container image used by the config-validator | string | `"gcr.io/forseti-containers/config-validator"` | no |
| k8s\_config\_validator\_image\_tag | The tag for the config-validator image. | string | `"latest"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"forseti"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.21.0"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.21.0"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| load\_balancer | The type of load balancer to deploy for the forseti-server if desired: none, external, internal | string | `"none"` | no |
| network\_policy | Apply pod network policies | bool | `"false"` | no |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | n/a | yes |
| production | Whether or not to deploy Forseti on GKE in a production configuration | bool | `"true"` | no |
| project\_id | The ID of the GCP project where Forseti is currently deployed. | string | n/a | yes |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
