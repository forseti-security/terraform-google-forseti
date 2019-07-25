# Forseti on GKE - Deploy on GKE
Follow this example if Forseti already exists in the environment.  Additionally, this example supports the scenario that a GKE already exists as well.  The only action taken by Terraform is to invoke Helm to deploy Forseti on GKE.

This example deploys the following:
1. Forseti on GKE - forseti-on-gke

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
| forseti\_client\_service\_account | Forseti Client service account | string | n/a | yes |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | n/a | yes |
| forseti\_cloudsql\_connection\_name | The connection string to the CloudSQL instance | string | n/a | yes |
| forseti\_server\_service\_account | Forseti Server service account | string | n/a | yes |
| forseti\_server\_storage\_bucket | Forseti Server storage bucket | string | n/a | yes |
| gke\_service\_account | The service account to run nodes as if not overridden in node\_pools. | string | `"create"` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_ca\_certificate | Kubernetes API server CA certificate. | string | n/a | yes |
| k8s\_endpoint | The Kubernetes API endpoint. | string | n/a | yes |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"latest"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"latest"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network\_policy | Whether or not to apply Pod NetworkPolicies | string | `"false"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |

[^]: (autogen_docs_end)
