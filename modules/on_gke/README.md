# Forseti on GKE

This sub-module deploys Forseti on GKE.  In short, this deploys a server container as a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and an orchestrator container as a Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).  Please see the [Forseti Security GKE Concepts](https://forsetisecurity.org/docs/latest/concepts/forseti-on-gke.html) documentation for more details
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.22.0"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.22.0"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| load\_balancer | The type of load balancer to deploy for the forseti-server if desired: none, external, internal | string | `"none"` | no |
| network\_policy | Apply pod network policies | bool | `"false"` | no |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | n/a | yes |
| production | Whether or not to deploy Forseti on GKE in a production configuration | bool | `"true"` | no |
| project\_id | The ID of the GCP project where Forseti is currently deployed. | string | n/a | yes |
| recreate\_pods | Instructs the helm\_release resource to, on update, perform pod restarts for the resources if applicable. | bool | `"true"` | no |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
