[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| gcp\_credentials\_file |  | string | n/a | yes |
| gke\_node\_ip\_range |  | string | `"10.1.0.0/20"` | no |
| gke\_pod\_ip\_range |  | string | `"10.2.0.0/20"` | no |
| gke\_service\_account |  | string | `"create"` | no |
| gke\_service\_ip\_range |  | string | `"10.3.0.0/20"` | no |
| gsuite\_admin\_email |  | string | n/a | yes |
| gsuite\_domain |  | string | n/a | yes |
| helm\_repository\_url |  | string | `"https://kubernetes-charts.storage.googleapis.com"` | no |
| k8s\_scheduler\_image |  | string | `"gcr.io/forseti-security-containers/forseti:dev"` | no |
| k8s\_server\_image |  | string | `"gcr.io/forseti-security-containers/forseti:dev"` | no |
| network\_name |  | string | `"gke-network"` | no |
| organization\_id |  | string | n/a | yes |
| project\_id |  | string | n/a | yes |
| region |  | string | n/a | yes |
| sub\_network\_name |  | string | `"gke-sub-network"` | no |
| zones |  | list | `<list>` | no |

[^]: (autogen_docs_end)
