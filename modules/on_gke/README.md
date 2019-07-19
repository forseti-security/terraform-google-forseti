# Forseti on GKE

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| forseti\_client\_service\_account | Forseti Client service account | string | `""` | no |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | `""` | no |
| forseti\_cloudsql\_connection\_name | Forseti CloudSQL Connection String | string | `""` | no |
| forseti\_server\_bucket | Forseti Server storage bucket | string | `""` | no |
| forseti\_server\_service\_account | Forseti Server service account | string | `""` | no |
| gke\_service\_account | The name of the IAM service account attached to the GKE cluster node-pool | string | `""` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"latest"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"latest"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network\_policy | Apply pod network policies | string | `"false"` | no |
| production | Whether or not to deploy Forseti on GKE in a production configuration | string | `"true"` | no |
| project\_id | The ID of the GCP project where Forseti is currently deployed. | string | n/a | yes |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |

[^]: (autogen_docs_end)
