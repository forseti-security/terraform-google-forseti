# Forseti on GKE - Deploy on GKE
Follow this example if Forseti already exists in the environment.  Additionally, this example supports the scenario that a GKE already exists as well.  The only action taken by Terraform is to invoke Helm to deploy Forseti on GKE.

This example deploys the following:
1. Forseti on GKE - forseti-on-gke

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
In addition to the [roles](https://github.com/forseti-security/terraform-google-forseti#iam-roles) required for the core module function, the Service Account must have these roles for this example.
- roles/container.developer

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| credentials\_path | Path to service account json | string | n/a | yes |
| forseti\_client\_service\_account | Forseti Client service account | string | n/a | yes |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | n/a | yes |
| forseti\_cloudsql\_connection\_name | The connection string to the CloudSQL instance | string | n/a | yes |
| forseti\_server\_service\_account | Forseti Server service account | string | n/a | yes |
| forseti\_server\_storage\_bucket | Forseti Server storage bucket | string | n/a | yes |
| git\_sync\_image | The container image used by the config-validator git-sync side-car | string | `"gcr.io/google-containers/git-sync"` | no |
| git\_sync\_image\_tag | The container image tag used by the config-validator git-sync side-car | string | `"v3.1.2"` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the private SSH key allowing the git-sync to clone the policy library repository. | string | `""` | no |
| git\_sync\_ssh | Use SSH for git-sync operations | bool | `"false"` | no |
| git\_sync\_wait | The time number of seconds between git-syncs | string | `"30"` | no |
| gke\_cluster\_location | The location of the GKE cluster on which to deploy Forseti | string | n/a | yes |
| gke\_cluster\_name | The name of the GKE cluster on which to deploy Forseti | string | n/a | yes |
| gke\_service\_account | The service account to run nodes as if not overridden in node_pools. | string | `"create"` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_config\_validator\_image | The container image used by the config-validator | string | `"gcr.io/forseti-containers/config-validator"` | no |
| k8s\_config\_validator\_image\_tag | The tag for the config-validator image. | string | `"latest"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"forseti"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.21.0"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.21.0"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| load\_balancer | The type of load balancer to deploy for the forseti-server if desired: none, external, internal | string | `"internal"` | no |
| network\_policy | Whether or not to apply Pod NetworkPolicies | bool | `"false"` | no |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `"https://github.com/forseti-security/policy-library"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |
| suffix | The random suffix appended to Forseti resources | string | n/a | yes |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
