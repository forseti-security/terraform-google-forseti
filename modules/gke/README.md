# Forseti on GKE

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| forseti\_client\_service\_account | Forseti Client service account | string | n/a | yes |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | n/a | yes |
| forseti\_cloudsql\_connection\_name | Forseti CloudSQL Connection String | string | n/a | yes |
| forseti\_server\_bucket | Forseti Server storage bucket | string | n/a | yes |
| forseti\_server\_service\_account | Forseti Server service account | string | n/a | yes |
| gke\_service\_account | Set to 'create' if the GKE cluster node-pool was created with an IAM SA attached. | string | `"nocreate"` | no |
| gke\_service\_account\_name | The name of the IAM service account attached to the GKE cluster node-pool | string | `""` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://kubernetes-charts.storage.googleapis.com"` | no |
| k8s\_ca\_certificate | Kubernetes API server CA certificate. | string | n/a | yes |
| k8s\_endpoint | The Kubernetes API endpoint. | string | n/a | yes |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-security-containers/forseti:latest"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-security-containers/forseti:latest"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| project\_id | The ID of the GCP project where Forseti is currently deployed. | string | n/a | yes |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |

[^]: (autogen_docs_end)
