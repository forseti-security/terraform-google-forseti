# Server Config

This sub-module deploys the Server configuration file in the Server Google Cloud Storage (GCS) bucket.

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
| audit\_logging\_enabled | Audit Logging scanner enabled. | string | `"false"` | no |
| audit\_logging\_violations\_should\_notify | Notify for Audit logging violations | string | `"true"` | no |
| bigquery\_acl\_violations\_should\_notify | Notify for BigQuery ACL violations | string | `"true"` | no |
| bigquery\_disable\_polling | Whether to disable polling for Big Query API | bool | `"false"` | no |
| bigquery\_enabled | Big Query scanner enabled. | string | `"true"` | no |
| bigquery\_max\_calls | Maximum calls that can be made to Big Query API | string | `"160"` | no |
| bigquery\_period | The period of max calls for the Big Query API (in seconds) | string | `"1.0"` | no |
| blacklist\_enabled | Audit Logging scanner enabled. | string | `"true"` | no |
| blacklist\_violations\_should\_notify | Notify for Blacklist violations | string | `"true"` | no |
| bucket\_acl\_enabled | Bucket ACL scanner enabled. | string | `"true"` | no |
| buckets\_acl\_violations\_should\_notify | Notify for Buckets ACL violations | string | `"true"` | no |
| cai\_api\_timeout | Timeout in seconds to wait for the exportAssets API to return success. | string | `"3600"` | no |
| cloudasset\_disable\_polling | Whether to disable polling for Cloud Asset API | bool | `"false"` | no |
| cloudasset\_max\_calls | Maximum calls that can be made to Cloud Asset API | string | `"1"` | no |
| cloudasset\_period | The period of max calls for the Cloud Asset API (in seconds) | string | `"1.0"` | no |
| cloudbilling\_disable\_polling | Whether to disable polling for Cloud Billing API | bool | `"false"` | no |
| cloudbilling\_max\_calls | Maximum calls that can be made to Cloud Billing API | string | `"5"` | no |
| cloudbilling\_period | The period of max calls for the Cloud Billing API (in seconds) | string | `"1.2"` | no |
| cloudsql\_acl\_enabled | Cloud SQL scanner enabled. | string | `"true"` | no |
| cloudsql\_acl\_violations\_should\_notify | Notify for CloudSQL ACL violations | string | `"true"` | no |
| composite\_root\_resources | A list of root resources that Forseti will monitor. This supersedes the root_resource_id when set. | list(string) | `<list>` | no |
| compute\_disable\_polling | Whether to disable polling for Compute API | bool | `"false"` | no |
| compute\_max\_calls | Maximum calls that can be made to Compute API | string | `"18"` | no |
| compute\_period | The period of max calls for the Compute API (in seconds) | string | `"1.0"` | no |
| config\_validator\_enabled | Config Validator scanner enabled. | string | `"false"` | no |
| config\_validator\_violations\_should\_notify | Notify for Config Validator violations. | string | `"true"` | no |
| container\_disable\_polling | Whether to disable polling for Container API | bool | `"false"` | no |
| container\_max\_calls | Maximum calls that can be made to Container API | string | `"9"` | no |
| container\_period | The period of max calls for the Container API (in seconds) | string | `"1.0"` | no |
| crm\_disable\_polling | Whether to disable polling for CRM API | bool | `"false"` | no |
| crm\_max\_calls | Maximum calls that can be made to CRN API | string | `"4"` | no |
| crm\_period | The period of max calls for the CRM  API (in seconds) | string | `"1.2"` | no |
| cscc\_source\_id | Source ID for CSCC Beta API | string | `""` | no |
| cscc\_violations\_enabled | Notify for CSCC violations | string | `"false"` | no |
| domain | The domain associated with the GCP Organization ID | string | n/a | yes |
| enabled\_apis\_enabled | Enabled APIs scanner enabled. | string | `"false"` | no |
| enabled\_apis\_violations\_should\_notify | Notify for enabled APIs violations | string | `"true"` | no |
| excluded\_resources | A list of resources to exclude during the inventory phase. | list(string) | `<list>` | no |
| external\_project\_access\_violations\_should\_notify | Notify for External Project Access violations | string | `"true"` | no |
| firewall\_rule\_enabled | Firewall rule scanner enabled. | string | `"true"` | no |
| firewall\_rule\_violations\_should\_notify | Notify for Firewall rule violations | string | `"true"` | no |
| folder\_id | GCP Folder that the Forseti project will be deployed into | string | `""` | no |
| forseti\_email\_recipient | Email address that receives Forseti notifications | string | `""` | no |
| forseti\_email\_sender | Email address that sends the Forseti notifications | string | `""` | no |
| forwarding\_rule\_enabled | Forwarding rule scanner enabled. | string | `"false"` | no |
| forwarding\_rule\_violations\_should\_notify | Notify for forwarding rule violations | string | `"true"` | no |
| group\_enabled | Group scanner enabled. | string | `"true"` | no |
| groups\_settings\_disable\_polling | Whether to disable polling for the G Suite Groups API | bool | `"false"` | no |
| groups\_settings\_enabled | Groups settings scanner enabled. | string | `"true"` | no |
| groups\_settings\_max\_calls | Maximum calls that can be made to the G Suite Groups API | string | `"5"` | no |
| groups\_settings\_period | the period of max calls to the G Suite Groups API | string | `"1.1"` | no |
| groups\_settings\_violations\_should\_notify | Notify for groups settings violations | string | `"true"` | no |
| groups\_violations\_should\_notify | Notify for Groups violations | string | `"true"` | no |
| gsuite\_admin\_email | G-Suite administrator email address to manage your Forseti installation | string | n/a | yes |
| iam\_disable\_polling | Whether to disable polling for IAM API | bool | `"false"` | no |
| iam\_max\_calls | Maximum calls that can be made to IAM API | string | `"90"` | no |
| iam\_period | The period of max calls for the IAM API (in seconds) | string | `"1.0"` | no |
| iam\_policy\_enabled | IAM Policy scanner enabled. | string | `"true"` | no |
| iam\_policy\_violations\_should\_notify | Notify for IAM Policy violations | string | `"true"` | no |
| iam\_policy\_violations\_slack\_webhook | Slack webhook for IAM Policy violations | string | `""` | no |
| iap\_enabled | IAP scanner enabled. | string | `"true"` | no |
| iap\_violations\_should\_notify | Notify for IAP violations | string | `"true"` | no |
| instance\_network\_interface\_enabled | Instance network interface scanner enabled. | string | `"false"` | no |
| instance\_network\_interface\_violations\_should\_notify | Notify for instance network interface violations | string | `"true"` | no |
| inventory\_email\_summary\_enabled | Email summary for inventory enabled | string | `"true"` | no |
| inventory\_gcs\_summary\_enabled | GCS summary for inventory enabled | string | `"true"` | no |
| inventory\_retention\_days | Number of days to retain inventory data. | string | `"-1"` | no |
| ke\_scanner\_enabled | KE scanner enabled. | string | `"false"` | no |
| ke\_version\_scanner\_enabled | KE version scanner enabled. | string | `"true"` | no |
| ke\_version\_violations\_should\_notify | Notify for KE version violations | string | `"true"` | no |
| ke\_violations\_should\_notify | Notify for KE violations | string | `"true"` | no |
| kms\_scanner\_enabled | KMS scanner enabled. | string | `"true"` | no |
| kms\_violations\_should\_notify | Notify for KMS violations | string | `"true"` | no |
| kms\_violations\_slack\_webhook | Slack webhook for KMS violations | string | `""` | no |
| lien\_enabled | Lien scanner enabled. | string | `"true"` | no |
| lien\_violations\_should\_notify | Notify for lien violations | string | `"true"` | no |
| location\_enabled | Location scanner enabled. | string | `"true"` | no |
| location\_violations\_should\_notify | Notify for location violations | string | `"true"` | no |
| log\_sink\_enabled | Log sink scanner enabled. | string | `"true"` | no |
| log\_sink\_violations\_should\_notify | Notify for log sink violations | string | `"true"` | no |
| logging\_disable\_polling | Whether to disable polling for Logging API | bool | `"false"` | no |
| logging\_max\_calls | Maximum calls that can be made to Logging API | string | `"9"` | no |
| logging\_period | The period of max calls for the Logging API (in seconds) | string | `"1.0"` | no |
| org\_id | GCP Organization ID that Forseti will have purview over | string | n/a | yes |
| resource\_enabled | Resource scanner enabled. | string | `"true"` | no |
| resource\_violations\_should\_notify | Notify for resource violations | string | `"true"` | no |
| securitycenter\_disable\_polling | Whether to disable polling for Security Center API | bool | `"false"` | no |
| securitycenter\_max\_calls | Maximum calls that can be made to Security Center API | string | `"1"` | no |
| securitycenter\_period | The period of max calls for the Security Center API (in seconds) | string | `"1.1"` | no |
| sendgrid\_api\_key | Sendgrid.com API key to enable email notifications | string | `""` | no |
| server\_gcs\_module | The Forseti Server GCS module | string | n/a | yes |
| service\_account\_key\_enabled | Service account key scanner enabled. | string | `"true"` | no |
| service\_account\_key\_violations\_should\_notify | Notify for service account key violations | string | `"true"` | no |
| servicemanagement\_disable\_polling | Whether to disable polling for Service Management API | bool | `"false"` | no |
| servicemanagement\_max\_calls | Maximum calls that can be made to Service Management API | string | `"2"` | no |
| servicemanagement\_period | The period of max calls for the Service Management API (in seconds) | string | `"1.1"` | no |
| sqladmin\_disable\_polling | Whether to disable polling for SQL Admin API | bool | `"false"` | no |
| sqladmin\_max\_calls | Maximum calls that can be made to SQL Admin API | string | `"1"` | no |
| sqladmin\_period | The period of max calls for the SQL Admin API (in seconds) | string | `"1.1"` | no |
| storage\_disable\_polling | Whether to disable polling for Storage API | bool | `"false"` | no |
| violations\_slack\_webhook | Slack webhook for any violation. Will apply to all scanner violation notifiers. | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| forseti-server-config | The rendered Forseti server configuration file |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
