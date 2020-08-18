# Forseti on GKE

This sub-module deploys Forseti on GKE.  In short, this deploys a server container as a Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and an orchestrator container as a Kubernetes [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/).  Please see the [Forseti Security GKE Concepts](https://forsetisecurity.org/docs/latest/concepts/forseti-on-gke.html) documentation for more details
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_disable\_polling | Whether to disable polling for Admin API | bool | `"false"` | no |
| admin\_max\_calls | Maximum calls that can be made to Admin API | string | `"14"` | no |
| admin\_period | The period of max calls for the Admin API (in seconds) | string | `"1.0"` | no |
| appengine\_disable\_polling | Whether to disable polling for App Engine API | bool | `"false"` | no |
| appengine\_max\_calls | Maximum calls that can be made to App Engine API | string | `"18"` | no |
| appengine\_period | The period of max calls for the App Engine API (in seconds) | string | `"1.0"` | no |
| audit\_logging\_enabled | Audit Logging scanner enabled. | bool | `"false"` | no |
| audit\_logging\_violations\_should\_notify | Notify for Audit logging violations | bool | `"true"` | no |
| bigquery\_acl\_violations\_should\_notify | Notify for BigQuery ACL violations | bool | `"true"` | no |
| bigquery\_disable\_polling | Whether to disable polling for Big Query API | bool | `"false"` | no |
| bigquery\_enabled | Big Query scanner enabled. | bool | `"true"` | no |
| bigquery\_max\_calls | Maximum calls that can be made to Big Query API | string | `"160"` | no |
| bigquery\_period | The period of max calls for the Big Query API (in seconds) | string | `"1.0"` | no |
| blacklist\_enabled | Blacklist scanner enabled. | bool | `"true"` | no |
| blacklist\_violations\_should\_notify | Notify for Blacklist violations | bool | `"true"` | no |
| bucket\_acl\_enabled | Bucket ACL scanner enabled. | bool | `"true"` | no |
| bucket\_cai\_lifecycle\_age | GCS CAI lifecycle age value | string | `"14"` | no |
| bucket\_cai\_location | GCS CAI storage bucket location | string | `"us-central1"` | no |
| buckets\_acl\_violations\_should\_notify | Notify for Buckets ACL violations | bool | `"true"` | no |
| cai\_api\_timeout | Timeout in seconds to wait for the exportAssets API to return success. | string | `"3600"` | no |
| client\_access\_config | Client instance 'access_config' block | map(any) | `<map>` | no |
| client\_boot\_image | GCE Forseti Client boot image | string | `"ubuntu-os-cloud/ubuntu-1804-lts"` | no |
| client\_enabled | Enable Client VM | bool | `"true"` | no |
| client\_instance\_metadata | Metadata key/value pairs to make available from within the client instance. | map(string) | `<map>` | no |
| client\_private | Private GCE Forseti Client VM (no public IP) | bool | `"false"` | no |
| client\_region | GCE Forseti Client region | string | `"us-central1"` | no |
| client\_ssh\_allow\_ranges | List of CIDRs that will be allowed ssh access to forseti client | list(string) | `<list>` | no |
| client\_tags | GCE Forseti Client VM Tags | list(string) | `<list>` | no |
| client\_type | GCE Forseti Client machine type | string | `"n1-standard-2"` | no |
| cloud\_profiler\_enabled | Enable the Cloud Profiler | bool | `"false"` | no |
| cloudasset\_disable\_polling | Whether to disable polling for Cloud Asset API | bool | `"false"` | no |
| cloudasset\_max\_calls | Maximum calls that can be made to Cloud Asset API | string | `"1"` | no |
| cloudasset\_period | The period of max calls for the Cloud Asset API (in seconds) | string | `"1.0"` | no |
| cloudbilling\_disable\_polling | Whether to disable polling for Cloud Billing API | bool | `"false"` | no |
| cloudbilling\_max\_calls | Maximum calls that can be made to Cloud Billing API | string | `"5"` | no |
| cloudbilling\_period | The period of max calls for the Cloud Billing API (in seconds) | string | `"1.2"` | no |
| cloudsql\_acl\_enabled | Cloud SQL scanner enabled. | bool | `"true"` | no |
| cloudsql\_acl\_violations\_should\_notify | Notify for CloudSQL ACL violations | bool | `"true"` | no |
| cloudsql\_db\_name | CloudSQL database name | string | `"forseti_security"` | no |
| cloudsql\_disk\_size | The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. | string | `"25"` | no |
| cloudsql\_net\_write\_timeout | See MySQL documentation: https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html#sysvar_net_write_timeout | string | `"240"` | no |
| cloudsql\_password | CloudSQL password | string | `""` | no |
| cloudsql\_private | Whether to enable private network and not to create public IP for CloudSQL Instance | bool | `"false"` | no |
| cloudsql\_region | CloudSQL region | string | `"us-central1"` | no |
| cloudsql\_type | CloudSQL Instance size | string | `"db-n1-standard-4"` | no |
| cloudsql\_user | CloudSQL user | string | `"forseti_security_user"` | no |
| cloudsql\_user\_host | The host the user can connect from.  Can be an IP address or IP address range. Changing this forces a new resource to be created. | string | `"%"` | no |
| composite\_root\_resources | A list of root resources that Forseti will monitor. This supersedes the root_resource_id when set. | list(string) | `<list>` | no |
| compute\_disable\_polling | Whether to disable polling for Compute API | bool | `"false"` | no |
| compute\_max\_calls | Maximum calls that can be made to Compute API | string | `"18"` | no |
| compute\_period | The period of max calls for the Compute API (in seconds) | string | `"1.0"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | bool | `"false"` | no |
| config\_validator\_violations\_should\_notify | Notify for Config Validator violations. | bool | `"true"` | no |
| container\_disable\_polling | Whether to disable polling for Container API | bool | `"false"` | no |
| container\_max\_calls | Maximum calls that can be made to Container API | string | `"9"` | no |
| container\_period | The period of max calls for the Container API (in seconds) | string | `"1.0"` | no |
| crm\_disable\_polling | Whether to disable polling for CRM API | bool | `"false"` | no |
| crm\_max\_calls | Maximum calls that can be made to CRN API | string | `"4"` | no |
| crm\_period | The period of max calls for the CRM  API (in seconds) | string | `"1.2"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | bool | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| enable\_cai\_bucket | Create a GCS bucket for CAI exports | bool | `"true"` | no |
| enable\_service\_networking | Create a global service networking peering connection at the VPC level | bool | `"true"` | no |
| enable\_write | Enabling/Disabling write actions | bool | `"false"` | no |
| enabled\_apis\_enabled | Enabled APIs scanner enabled. | bool | `"false"` | no |
| enabled\_apis\_violations\_should\_notify | Notify for enabled APIs violations | bool | `"true"` | no |
| excluded\_resources | A list of resources to exclude during the inventory phase. | list(string) | `<list>` | no |
| external\_project\_access\_violations\_should\_notify | Notify for External Project Access violations | bool | `"true"` | no |
| firewall\_rule\_enabled | Firewall rule scanner enabled. | bool | `"true"` | no |
| firewall\_rule\_violations\_should\_notify | Notify for Firewall rule violations | bool | `"true"` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `""` | no |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| forseti\_home | Forseti installation directory | string | `"$USER_HOME/forseti-security"` | no |
| forseti\_repo\_url | Git repo for the Forseti installation | string | `"https://github.com/forseti-security/forseti-security"` | no |
| forseti\_run\_frequency | Schedule of running the Forseti scans | string | `"null"` | no |
| forseti\_version | The version of Forseti to install | string | `"v2.25.1"` | no |
| forwarding\_rule\_enabled | Forwarding rule scanner enabled. | bool | `"false"` | no |
| forwarding\_rule\_violations\_should\_notify | Notify for forwarding rule violations | bool | `"true"` | no |
| git\_sync\_image | The container image used by the config-validator git-sync side-car | string | `"gcr.io/google-containers/git-sync"` | no |
| git\_sync\_private\_ssh\_key\_file | The file containing the private SSH key allowing the git-sync to clone the policy library repository. | string | `"null"` | no |
| git\_sync\_wait | The time number of seconds between git-syncs | string | `"30"` | no |
| gke\_node\_pool\_name | The name of the GKE node-pool where Forseti is being deployed | string | `"default-pool"` | no |
| group\_enabled | Group scanner enabled. | bool | `"true"` | no |
| groups\_settings\_disable\_polling | Whether to disable polling for the G Suite Groups API | bool | `"false"` | no |
| groups\_settings\_enabled | Groups settings scanner enabled. | bool | `"true"` | no |
| groups\_settings\_max\_calls | Maximum calls that can be made to the G Suite Groups API | string | `"5"` | no |
| groups\_settings\_period | the period of max calls to the G Suite Groups API | string | `"1.1"` | no |
| groups\_settings\_violations\_should\_notify | Notify for groups settings violations | bool | `"true"` | no |
| groups\_violations\_should\_notify | Notify for Groups violations | bool | `"true"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | `""` | no |
| helm\_chart\_version | The version of the Helm chart to use | string | `"2.2.0"` | no |
| helm\_repository\_url | The Helm repository containing the 'forseti-security' Helm charts | string | `"https://forseti-security-charts.storage.googleapis.com/release/"` | no |
| iam\_disable\_polling | Whether to disable polling for IAM API | bool | `"false"` | no |
| iam\_max\_calls | Maximum calls that can be made to IAM API | string | `"90"` | no |
| iam\_period | The period of max calls for the IAM API (in seconds) | string | `"1.0"` | no |
| iam\_policy\_enabled | IAM Policy scanner enabled. | bool | `"true"` | no |
| iam\_policy\_violations\_should\_notify | Notify for IAM Policy violations | bool | `"true"` | no |
| iam\_policy\_violations\_slack\_webhook | Slack webhook for IAM Policy violations | string | `""` | no |
| iap\_enabled | IAP scanner enabled. | bool | `"true"` | no |
| iap\_violations\_should\_notify | Notify for IAP violations | bool | `"true"` | no |
| instance\_network\_interface\_enabled | Instance network interface scanner enabled. | bool | `"false"` | no |
| instance\_network\_interface\_violations\_should\_notify | Notify for instance network interface violations | bool | `"true"` | no |
| inventory\_email\_summary\_enabled | Email summary for inventory enabled | bool | `"false"` | no |
| inventory\_gcs\_summary\_enabled | GCS summary for inventory enabled | bool | `"true"` | no |
| inventory\_retention\_days | Number of days to retain inventory data. | string | `"-1"` | no |
| k8s\_config\_validator\_image | The container image used by the config-validator | string | `"gcr.io/forseti-containers/config-validator"` | no |
| k8s\_config\_validator\_image\_tag | The tag for the config-validator image. | string | `"e018e7c"` | no |
| k8s\_forseti\_namespace | The Kubernetes namespace in which to deploy Forseti. | string | `"forseti"` | no |
| k8s\_forseti\_orchestrator\_image | The container image for the Forseti orchestrator | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_orchestrator\_image\_tag | The tag for the container image for the Forseti orchestrator | string | `"v2.25.1"` | no |
| k8s\_forseti\_server\_image | The container image for the Forseti server | string | `"gcr.io/forseti-containers/forseti"` | no |
| k8s\_forseti\_server\_image\_tag | The tag for the container image for the Forseti server | string | `"v2.25.1"` | no |
| k8s\_forseti\_server\_ingress\_cidr | If network_policy is true, k8s_forseti_server_ingress_cidr will restrict connections to the Forseti Server service from the CIDR's specified | string | `""` | no |
| k8s\_tiller\_sa\_name | The Kubernetes Service Account used by Tiller | string | `"tiller"` | no |
| ke\_scanner\_enabled | KE scanner enabled. | bool | `"false"` | no |
| ke\_version\_scanner\_enabled | KE version scanner enabled. | bool | `"true"` | no |
| ke\_version\_violations\_should\_notify | Notify for KE version violations | bool | `"true"` | no |
| ke\_violations\_should\_notify | Notify for KE violations | bool | `"true"` | no |
| kms\_scanner\_enabled | KMS scanner enabled. | bool | `"true"` | no |
| kms\_violations\_should\_notify | Notify for KMS violations | bool | `"true"` | no |
| kms\_violations\_slack\_webhook | Slack webhook for KMS violations | string | `""` | no |
| lien\_enabled | Lien scanner enabled. | bool | `"true"` | no |
| lien\_violations\_should\_notify | Notify for lien violations | bool | `"true"` | no |
| load\_balancer | The type of load balancer to deploy for the forseti-server if desired: none, external, internal | string | `"internal"` | no |
| location\_enabled | Location scanner enabled. | bool | `"true"` | no |
| location\_violations\_should\_notify | Notify for location violations | bool | `"true"` | no |
| log\_sink\_enabled | Log sink scanner enabled. | bool | `"true"` | no |
| log\_sink\_violations\_should\_notify | Notify for log sink violations | bool | `"true"` | no |
| logging\_disable\_polling | Whether to disable polling for Logging API | bool | `"false"` | no |
| logging\_max\_calls | Maximum calls that can be made to Logging API | string | `"9"` | no |
| logging\_period | The period of max calls for the Logging API (in seconds) | string | `"1.0"` | no |
| manage\_firewall\_rules | Create client firewall rules | bool | `"true"` | no |
| manage\_rules\_enabled | A toggle to enable or disable the management of rules | bool | `"true"` | no |
| network | The VPC where the Forseti client and server will be created | string | `"default"` | no |
| network\_policy | Apply pod network policies | bool | `"false"` | no |
| network\_project | The project containing the VPC and subnetwork where the Forseti client and server will be created | string | `""` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | `""` | no |
| policy\_library\_repository\_branch | The specific git branch containing the policies. | string | `"master"` | no |
| policy\_library\_repository\_url | The git repository containing the policy-library. | string | `""` | no |
| policy\_library\_sync\_enabled | Sync config validator policy library from private repository. | bool | `"false"` | no |
| policy\_library\_sync\_gcs\_directory\_name | The directory name of the GCS folder used for the policy library sync config. | string | `"policy_library_sync"` | no |
| policy\_library\_sync\_git\_sync\_tag | Tag for the git-sync image. | string | `"v3.1.2"` | no |
| production | Whether or not to deploy Forseti on GKE in a production configuration | bool | `"true"` | no |
| project\_id | Google Project ID that you want Forseti deployed into | string | n/a | yes |
| recreate\_pods | Instructs the helm_release resource to, on update, perform pod restarts for the resources if applicable. | bool | `"true"` | no |
| resource\_enabled | Resource scanner enabled. | bool | `"true"` | no |
| resource\_name\_suffix | A suffix which will be appended to resource names. | string | `"null"` | no |
| resource\_violations\_should\_notify | Notify for resource violations | bool | `"true"` | no |
| retention\_enabled | Retention scanner enabled. | bool | `"false"` | no |
| retention\_violations\_should\_notify | Notify for retention violations | bool | `"true"` | no |
| retention\_violations\_slack\_webhook | Slack webhook for retention violations | string | `""` | no |
| role\_enabled | Role scanner enabled. | bool | `"false"` | no |
| role\_violations\_should\_notify | Notify for role violations | bool | `"true"` | no |
| role\_violations\_slack\_webhook | Slack webhook for role violations | string | `""` | no |
| securitycenter\_disable\_polling | Whether to disable polling for Security Center API | bool | `"false"` | no |
| securitycenter\_max\_calls | Maximum calls that can be made to Security Center API | string | `"14"` | no |
| securitycenter\_period | The period of max calls for the Security Center API (in seconds) | string | `"1.0"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_log\_level | The log level of the Forseti server container. | string | `"info"` | no |
| service\_account\_key\_enabled | Service account key scanner enabled. | bool | `"true"` | no |
| service\_account\_key\_violations\_should\_notify | Notify for service account key violations | bool | `"true"` | no |
| servicemanagement\_disable\_polling | Whether to disable polling for Service Management API | bool | `"false"` | no |
| servicemanagement\_max\_calls | Maximum calls that can be made to Service Management API | string | `"2"` | no |
| servicemanagement\_period | The period of max calls for the Service Management API (in seconds) | string | `"1.1"` | no |
| sqladmin\_disable\_polling | Whether to disable polling for SQL Admin API | bool | `"false"` | no |
| sqladmin\_max\_calls | Maximum calls that can be made to SQL Admin API | string | `"1"` | no |
| sqladmin\_period | The period of max calls for the SQL Admin API (in seconds) | string | `"1.1"` | no |
| storage\_bucket\_location | GCS storage bucket location | string | `"us-central1"` | no |
| storage\_disable\_polling | Whether to disable polling for Storage API | bool | `"false"` | no |
| subnetwork | The VPC subnetwork where the Forseti client and server will be created | string | `"default"` | no |
| verify\_policy\_library | Verify the Policy Library is setup correctly for the Config Validator scanner | bool | `"false"` | no |
| violations\_slack\_webhook | Slack webhook for any violation. Will apply to all scanner violation notifiers. | string | `""` | no |
| workload\_identity\_namespace | Workload Identity namespace | string | `"null"` | no |

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
