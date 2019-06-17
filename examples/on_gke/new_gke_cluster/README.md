# Forseti on GKE - Deploy new GKE Cluster
Follow this example if Forseti exists in the environment but the GKE cluster doesn't exist or a new GKE cluster is desired.  This example assumes the cluster will be deployed using an existing VPC.

This example deploys the following:
1. A new GKE cluster - terraform-google-modules/kubernetes-engine/google
2. Forseti on GKE - forseti-on-gke

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials\_path | Path to service account json | string | n/a | yes |
<<<<<<< HEAD
| forseti\_client\_service\_account | Forseti Client service account | string | `""` | no |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | `""` | no |
| forseti\_cloudsql\_connection\_name | The connection string to the CloudSQL instance | string | `""` | no |
| forseti\_server\_service\_account | Forseti Server service account | string | `""` | no |
| forseti\_server\_storage\_bucket | Forseti Server storage bucket | string | `""` | no |
| gke\_cluster\_name | The name of the GKE Cluster | string | `"forseti-cluster"` | no |
| gke\_node\_ip\_range | The IP range for the GKE nodes. | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range | The IP range of the Kubernetes pods | string | `"10.2.0.0/20"` | no |
| gke\_service\_account | The service account to run nodes as if not overridden in node\_pools. The default value will cause a cluster-specific service account to be created. | string | `"create"` | no |
| gke\_service\_ip\_range | The IP range of the Kubernetes services. | string | `"10.3.0.0/20"` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"latest"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"latest"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network\_name | The name of the VPC being created | string | `"gke-network"` | no |
| production | Whether or not to deploy Forseti on GKE in a production configuration | string | `"true"` | no |
=======
| forseti\_client\_service\_account | Forseti Client service account | string | n/a | yes |
| forseti\_client\_vm\_ip | Forseti Client VM private IP address | string | n/a | yes |
| forseti\_cloudsql\_connection\_name | The connection string to the CloudSQL instance | string | n/a | yes |
| forseti\_server\_service\_account | Forseti Server service account | string | n/a | yes |
| forseti\_server\_storage\_bucket | Forseti Server storage bucket | string | n/a | yes |
| gke\_cluster\_name | The name of the GKE Cluster | string | `"forseti-cluster"` | no |
| gke\_node\_ip\_range | The IP range for the GKE nodes. | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range | The IP range of the Kubernetes pods | string | `"10.2.0.0/20"` | no |
| gke\_service\_account | The service account to run nodes as if not overridden in node_pools. The default value will cause a cluster-specific service account to be created. | string | `"create"` | no |
| gke\_service\_ip\_range | The IP range of the Kubernetes services. | string | `"10.3.0.0/20"` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://kubernetes-charts-incubator.storage.googleapis.com"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"default"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-security-containers/forseti:dev"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-security-containers/forseti:dev"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| network\_name | The name of the VPC being created | string | `"gke-network"` | no |
>>>>>>> Fixes per aaron-lane
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where forseti subnetwork will be deployed | string | n/a | yes |
| sub\_network\_name | The names of the subnet being created | string | `"gke-sub-network"` | no |
| zones | The zones to host the cluster in (optional if regional cluster / required if zonal) | list | `<list>` | no |

[^]: (autogen_docs_end)
