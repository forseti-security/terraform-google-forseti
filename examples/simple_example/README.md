[^]: (autogen_docs_start)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| credentials_file_path | Path to service account json | string | - | yes |
| gsuite_admin_email | The email of a GSuite super admin, used for pulling user directory information *and* sending notifications. | string | - | yes |
| notification_recipient_email | Notification recipient email | string | - | yes |
| project_id | The ID of an existing Google project where Forseti will be installed | string | - | yes |
| sendgrid_api_key | The Sendgrid api key for notifier | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| buckets_list |  |

[^]: (autogen_docs_end)