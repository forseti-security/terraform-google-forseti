# Forseti on GKE - End-to-End
Follow this example to deploy Forseti on-GKE but are starting from an empty GCP project.  In otherwords a GKE cluster does not yet exist.

This example deploys the following:
1. A new VPC
2. Forseti infrastructure
   * CloudSQL Database
   * Forseti Server GCS Bucket
   * Forseti Client GCS Bucket
   * Forseti Server IAM Service Account
   * Forseti Client IAM Service Account
3. A new GKE cluster - terraform-google-modules/kubernetes-engine/google
4. Forseti on GKE - forseti-on-gke

## Import an Existing Forseti Deployment
If you previously deployed Forseti either with Terraform or Deployment manager, that deployment can be migrated to Forseti on-GKE.  Please follow the [upgrade guide](../../docs/upgrading_to_v5.0.md) if you wish to reuse components (GCS buckets, CloudSQL etc.) for Forseti on-GKE.

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

### Create the Service Account and enable required APIs
You can create the service account manually, or by running the following command:

```bash
./helpers/setup.sh -p PROJECT_ID -o ORG_ID -k
```

This will create a service account called `cloud-foundation-forseti-<suffix>`,
give it the proper roles, and download service account credentials to
`${PWD}/credentials.json`. Note, that using this script assumes that you are
currently authenticated as a user that can create/authorize service accounts at
both the organization and project levels.

This script will also activate necessary APIs required for Terraform to deploy Forseti on-GKE end-to-end.
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | bool | `"false"` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `"us-central1"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | bool | `"false"` | no |
| default\_node\_pool\_disk\_size | Default Node Pool disk size | string | `"100"` | no |
| default\_node\_pool\_disk\_type | Default Node Pool disk type | string | `"pd-ssd"` | no |
| default\_node\_pool\_machine\_type | Default Node Pool machine type | string | `"n1-standard-8"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the private SSH key allowing the git-sync to clone the policy library repository. | string | `"null"` | no |
| gke\_cluster\_name | The name of the GKE Cluster | string | `"forseti-cluster"` | no |
| gke\_node\_ip\_range | The IP range for the GKE nodes. | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range | The IP range of the Kubernetes pods | string | `"10.2.0.0/20"` | no |
| gke\_pod\_ip\_range\_name | The name of the IP range of the Kubernetes pods | string | `"gke-pod-ip-range"` | no |
| gke\_service\_account | The service account to run nodes as if not overridden in node_pools. The default value will cause a cluster-specific service account to be created. | string | `"create"` | no |
| gke\_service\_ip\_range | The IP range of the Kubernetes services. | string | `"10.3.0.0/20"` | no |
| gke\_service\_ip\_range\_name | The name of the IP range of the Kubernetes services. | string | `"gke-service-ip-range"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | n/a | yes |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.25.1"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.25.1"` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| kubernetes\_version | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region. | string | `"1.15.11-gke.9"` | no |
| network | The name of the VPC being created | string | `"forseti-gke-network"` | no |
| network\_description | An optional description of the network. The resource must be recreated to modify this field. | string | `""` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | bool | `"false"` | no |
| project\_id | The ID of an existing Google project where Forseti will be installed | string | n/a | yes |
| region | Region where Forseti will be deployed | string | `"us-central1"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| subnetwork | The name of the subnet being created | string | `"gke-sub-network"` | no |

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
