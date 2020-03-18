global:

    dummy_key: this_is_just_a_placeholder_see_issue_2486

##############################################################################

inventory:

    # You must set ONLY one of root_resource_id or composite_root_resources in
    # your configuration. Defining both will cause Forseti to exit with an
    # error.

    # Root resource to start crawling from, formatted as
    # <resource_type>/<resource_id>, (e.g. "organizations/12345677890")
    ${ROOT_RESOURCE_ID}

    # Composite root resources: combines multiple resource roots into a single
    # inventory, for use across all Forseti modules. Can contain one or more
    # resources from the GCP Resource Hierarchy in any combination.
    # https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy
    #
    # All resources must grant the appropriate IAM permissions to the Forseti
    # service account before they can be included in the inventory.
    #
    # Forseti Explain is not supported with a composite root at this time.
    #
    # Resources can exist in multiple organizations.
    #
    #composite_root_resources:
    #    - "folders/12345"
    #    - "folders/45678"
    #    - "projects/98765"
    #    - "organizations/56789"
    ${COMPOSITE_ROOT_RESOURCES}

    # Resources to be excluded during the inventory process.
    # Only organizations/<ORG_NUMBER>, folders/<FOLDER_NUMBER>,
    # projects/<PROJECT_ID> or projects/<PROJECT_NUMBER> are accepted.
    # The child resources under the excluded resources will also be excluded.
    #
    # Example:
    # excluded_resources: ['folders/1234', 'projects/my-project-123', 'projects/4321']
    ${EXCLUDED_RESOURCES}

    # gsuite access
    domain_super_admin_email: ${DOMAIN_SUPER_ADMIN_EMAIL}

    api_quota:
        # We are not using the max allowed API quota because we wanted to
        # include some rooms for retries.
        # Period is in seconds.

        # Set disable_polling to True to disable polling that API for creation
        # of the inventory. This can speed up inventory creation for
        # organizations that do not use specific APIs. Defaults to False if
        # not defined.
        admin:
          max_calls: ${ADMIN_MAX_CALLS}
          period: ${ADMIN_PERIOD}
          disable_polling: ${ADMIN_DISABLE_POLLING}
        appengine:
          max_calls: ${APPENGINE_MAX_CALLS}
          period: ${APPENGINE_PERIOD}
          disable_polling: ${APPENGINE_DISABLE_POLLING}
        bigquery:
          max_calls: ${BIGQUERY_MAX_CALLS}
          period: ${BIGQUERY_PERIOD}
          disable_polling: ${BIGQUERY_DISABLE_POLLING}
        cloudasset:
          max_calls: ${CLOUDASSET_MAX_CALLS}
          period: ${CLOUDASSET_PERIOD}
          disable_polling:  ${CLOUDASSET_DISABLE_POLLING}
        cloudbilling:
          max_calls: ${CLOUDBILLING_MAX_CALLS}
          period: ${CLOUDBILLING_PERIOD}
          disable_polling: ${CLOUDBILLING_DISABLE_POLLING}
        compute:
          max_calls: ${COMPUTE_MAX_CALLS}
          period: ${COMPUTE_PERIOD}
          disable_polling: ${COMPUTE_DISABLE_POLLING}
        container:
          max_calls: ${CONTAINER_MAX_CALLS}
          period: ${CONTAINER_PERIOD}
          disable_polling: ${CONTAINER_DISABLE_POLLING}
        crm:
          max_calls: ${CRM_MAX_CALLS}
          period: ${CRM_PERIOD}
          disable_polling: ${CRM_DISABLE_POLLING}
        groupssettings:
          max_calls: ${GROUPS_SETTINGS_MAX_CALLS}
          period: ${GROUPS_SETTINGS_PERIOD}
          disable_polling: ${GROUPS_SETTINGS_DISABLE_POLLING}
        iam:
          max_calls: ${IAM_MAX_CALLS}
          period: ${IAM_PERIOD}
          disable_polling: ${IAM_DISABLE_POLLING}
        logging:
          max_calls: ${LOGGING_MAX_CALLS}
          period: ${LOGGING_PERIOD}
          disable_polling: ${LOGGING_DISABLE_POLLING}
        servicemanagement:
          max_calls: ${SERVICEMANAGEMENT_MAX_CALLS}
          period: ${SERVICEMANAGEMENT_PERIOD}
          disable_polling: ${SERVICEMANAGEMENT_DISABLE_POLLING}
        serviceusage:
          max_calls: ${SERVICEUSAGE_MAX_CALLS}
          period: ${SERVICEUSAGE_PERIOD}
          disable_polling: ${SERVICEUSAGE_DISABLE_POLLING}
        sqladmin:
          max_calls: ${SQLADMIN_MAX_CALLS}
          period: ${SQLADMIN_PERIOD}
          disable_polling: ${SQLADMIN_DISABLE_POLLING}
        storage:  # Does not use API quota
          disable_polling: ${STORAGE_DISABLE_POLLING}

    cai:
        # The FORSETI_CAI_BUCKET needs to be in Forseti project.
        enabled: ${CAI_ENABLED}
        gcs_path: gs://${FORSETI_CAI_BUCKET}

        # Timeout in seconds to wait for the exportAssets API to return success.
        # Defaults to 3600 if not set.
        api_timeout: ${CAI_API_TIMEOUT}

        # Optional list of asset types supported by Cloud Asset inventory API.
        # https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/overview
        # If included, only the asset types listed will be included in the
        # Forseti inventory. This can be used to reduce the size of the
        # inventory database to save on storage and reduce the time to complete
        # a pull of the inventory.
        #
        # If commented out then all currently supported asset types are
        # exported from Cloud Asset API. The list of default asset types is
        # in google/cloud/forseti/services/inventory/base/cloudasset.py

        #asset_types:
        #    - appengine.googleapis.com/Application
        #    - appengine.googleapis.com/Service
        #    - appengine.googleapis.com/Version
        #    - bigquery.googleapis.com/Dataset
        #    - bigquery.googleapis.com/Table
        #    - cloudbilling.googleapis.com/BillingAccount
        #    - cloudkms.googleapis.com/CryptoKey
        #    - cloudkms.googleapis.com/CryptoKeyVersion
        #    - cloudkms.googleapis.com/KeyRing
        #    - cloudresourcemanager.googleapis.com/Folder
        #    - cloudresourcemanager.googleapis.com/Organization
        #    - cloudresourcemanager.googleapis.com/Project
        #    - compute.googleapis.com/Autoscaler
        #    - compute.googleapis.com/BackendBucket
        #    - compute.googleapis.com/BackendService
        #    - compute.googleapis.com/Disk
        #    - compute.googleapis.com/Firewall
        #    - compute.googleapis.com/ForwardingRule
        #    - compute.googleapis.com/GlobalForwardingRule
        #    - compute.googleapis.com/HealthCheck
        #    - compute.googleapis.com/HttpHealthCheck
        #    - compute.googleapis.com/HttpsHealthCheck
        #    - compute.googleapis.com/Image
        #    - compute.googleapis.com/Instance
        #    - compute.googleapis.com/InstanceGroup
        #    - compute.googleapis.com/InstanceGroupManager
        #    - compute.googleapis.com/InstanceTemplate
        #    - compute.googleapis.com/License
        #    - compute.googleapis.com/Network
        #    - compute.googleapis.com/Project
        #    - compute.googleapis.com/RegionBackendService
        #    - compute.googleapis.com/Route
        #    - compute.googleapis.com/Router
        #    - compute.googleapis.com/Snapshot
        #    - compute.googleapis.com/SslCertificate
        #    - compute.googleapis.com/Subnetwork
        #    - compute.googleapis.com/TargetHttpProxy
        #    - compute.googleapis.com/TargetHttpsProxy
        #    - compute.googleapis.com/TargetInstance
        #    - compute.googleapis.com/TargetPool
        #    - compute.googleapis.com/TargetSslProxy
        #    - compute.googleapis.com/TargetTcpProxy
        #    - compute.googleapis.com/TargetVpnGateway
        #    - compute.googleapis.com/UrlMap
        #    - compute.googleapis.com/VpnTunnel
        #    - container.googleapis.com/Cluster
        #    - dataproc.googleapis.com/Cluster
        #    - dataproc.googleapis.com/Job
        #    - dns.googleapis.com/ManagedZone
        #    - dns.googleapis.com/Policy
        #    - iam.googleapis.com/Role
        #    - iam.googleapis.com/ServiceAccount
        #    - iam.googleapis.com/ServiceAccountKey
        #    - k8s.io/Namespace
        #    - k8s.io/Node
        #    - k8s.io/Pod
        #    - k8s.io/Service
        #    - pubsub.googleapis.com/Subscription
        #    - pubsub.googleapis.com/Topic
        #    - rbac.authorization.k8s.io/ClusterRole
        #    - rbac.authorization.k8s.io/ClusterRoleBinding
        #    - rbac.authorization.k8s.io/Role
        #    - rbac.authorization.k8s.io/RoleBinding
        #    - serviceusage.googleapis.com/Service
        #    - spanner.googleapis.com/Database
        #    - spanner.googleapis.com/Instance
        #    - sqladmin.googleapis.com/Instance
        #    - storage.googleapis.com/Bucket

    # Number of days to retain inventory data:
    #  -1 : (default) keep all previous data forever
    #   0 : delete all previous inventory data before running
    retention_days: ${INVENTORY_RETENTION_DAYS}

##############################################################################

scanner:

    # Output path (do not include filename).
    # If GCS location, the format of the path should be:
    # gs://bucket-name/path/for/output
    output_path: gs://${FORSETI_BUCKET}/scanner_violations

    # Rules path (do not include filename).
    # If GCS location, the format of the path should be:
    # gs://bucket-name/path/for/rules_path
    # if no rules_path is specified, rules are
    # searched in /path/to/forseti_security/rules/
    rules_path: ${RULES_PATH}

    # Enable the scanners as default to true when integrated for Forseti 2.0.

    scanners:
        - name: audit_logging
          enabled: ${AUDIT_LOGGING_ENABLED}
        - name: bigquery
          enabled: ${BIGQUERY_ENABLED}
        - name: blacklist
          enabled: ${BLACKLIST_ENABLED}
        - name: bucket_acl
          enabled: ${BUCKET_ACL_ENABLED}
        - name: config_validator
          enabled: ${CONFIG_VALIDATOR_ENABLED}
          verify_policy_library: ${VERIFY_POLICY_LIBRARY}
        - name: cloudsql_acl
          enabled: ${CLOUDSQL_ACL_ENABLED}
        - name: enabled_apis
          enabled: ${ENABLED_APIS_ENABLED}
        - name: firewall_rule
          enabled: ${FIREWALL_RULE_ENABLED}
        - name: forwarding_rule
          enabled: ${FORWARDING_RULE_ENABLED}
        - name: group
          enabled: ${GROUP_ENABLED}
        - name: groups_settings
          enabled: ${GROUPS_SETTINGS_ENABLED}
        - name: iam_policy
          enabled: ${IAM_POLICY_ENABLED}
        - name: iap
          enabled: ${IAP_ENABLED}
        - name: instance_network_interface
          enabled: ${INSTANCE_NETWORK_INTERFACE_ENABLED}
        - name: ke_scanner
          enabled: ${KE_SCANNER_ENABLED}
        - name: ke_version_scanner
          enabled: ${KE_VERSION_SCANNER_ENABLED}
        - name: kms_scanner
          enabled: ${KMS_SCANNER_ENABLED}
        - name: lien
          enabled: ${LIEN_ENABLED}
        - name: location
          enabled: ${LOCATION_ENABLED}
        - name: log_sink
          enabled: ${LOG_SINK_ENABLED}
        - name: resource
          enabled: ${RESOURCE_ENABLED}
        - name: retention
          enabled: ${RETENTION_ENABLED}
        - name: role
          enabled: ${ROLE_ENABLED}
        - name: service_account_key
          enabled: ${SERVICE_ACCOUNT_KEY_ENABLED}

##############################################################################

notifier:
    api_quota:
        securitycenter:
            max_calls: ${SECURITYCENTER_MAX_CALLS}
            period: ${SECURITYCENTER_PERIOD}

    # Provide connector details
    %{ if SENDGRID_API_KEY != "" }
    email_connector:
      name: sendgrid
      auth:
        api_key: ${SENDGRID_API_KEY}
      sender: ${EMAIL_SENDER}
      recipient: ${EMAIL_RECIPIENT}
      data_format: csv
    %{ endif }

    # For every resource type you can set up a notification pipeline
    # to send alerts for every violation found
    resources:
        - resource: iam_policy_violations
          should_notify: ${IAM_POLICY_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            # Slack webhook pipeline.
            # Create an incoming webhook in your organization's Slack setting, located at:
            # https://[your_org].slack.com/apps/manage/custom-integrations
            # Add the provided URL in the configuration below in `webhook_url`.
            %{ if IAM_POLICY_VIOLATIONS_SLACK_WEBHOOK != "" || VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: %{ if IAM_POLICY_VIOLATIONS_SLACK_WEBHOOK != "" }${IAM_POLICY_VIOLATIONS_SLACK_WEBHOOK}%{ else }${VIOLATIONS_SLACK_WEBHOOK}%{ endif }
            %{ endif }

        - resource: audit_logging_violations
          should_notify: ${AUDIT_LOGGING_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: blacklist_violations
          should_notify: ${BLACKLIST_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: bigquery_acl_violations
          should_notify: ${BIGQUERY_ACL_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: buckets_acl_violations
          should_notify: ${BUCKETS_ACL_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: config_validator_violations
          should_notify: ${CONFIG_VALIDATOR_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: cloudsql_acl_violations
          should_notify: ${CLOUDSQL_ACL_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: enabled_apis_violations
          should_notify: ${ENABLED_APIS_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: firewall_rule_violations
          should_notify: ${FIREWALL_RULE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: forwarding_rule_violations
          should_notify: ${FORWARDING_RULE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: groups_settings_violations
          should_notify: ${GROUPS_SETTINGS_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: ke_version_violations
          should_notify: ${KE_VERSION_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: ke_violations
          should_notify: ${KE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: kms_violations
          should_notify: ${KMS_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            # Slack webhook pipeline.
            # Create an incoming webhook in your organization's Slack setting, located at:
            # https://[your_org].slack.com/apps/manage/custom-integrations
            # Add the provided URL in the configuration below in `webhook_url`.
            %{ if KMS_VIOLATIONS_SLACK_WEBHOOK != "" || VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: %{ if KMS_VIOLATIONS_SLACK_WEBHOOK != "" }${KMS_VIOLATIONS_SLACK_WEBHOOK}%{ else }${VIOLATIONS_SLACK_WEBHOOK}%{ endif }
            %{ endif }

        - resource: groups_violations
          should_notify: ${GROUPS_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: instance_network_interface_violations
          should_notify: ${INSTANCE_NETWORK_INTERFACE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: iap_violations
          should_notify: ${IAP_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: lien_violations
          should_notify: ${LIEN_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: location_violations
          should_notify: ${LOCATION_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: log_sink_violations
          should_notify: ${LOG_SINK_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: resource_violations
          should_notify: ${RESOURCE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: retention_violations
          should_notify: ${RETENTION_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: role_violations
          should_notify: ${ROLE_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: service_account_key_violations
          should_notify: ${SERVICE_ACCOUNT_KEY_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

        - resource: external_project_access_violations
          should_notify: ${EXTERNAL_PROJECT_ACCESS_VIOLATIONS_SHOULD_NOTIFY}
          notifiers:
            %{ if SENDGRID_API_KEY != "" }
            # Email violations
            - name: email_violations
            %{ endif }
            # Upload violations to GCS.
            - name: gcs_violations
              configuration:
                data_format: csv
                # gcs_path should begin with "gs://"
                gcs_path: gs://${FORSETI_BUCKET}/scanner_violations
            %{ if VIOLATIONS_SLACK_WEBHOOK != "" }
            - name: slack_webhook
              configuration:
                data_format: json  # slack only supports json
                webhook_url: ${VIOLATIONS_SLACK_WEBHOOK}
            %{ endif }

    violation:
      cscc:
        enabled: ${CSCC_VIOLATIONS_ENABLED}
        # Cloud SCC uses a source_id. It is unique per
        # organization and must be generated via a self-registration process.
        # The format is: organizations/ORG_ID/sources/SOURCE_ID
        source_id: ${CSCC_SOURCE_ID}

    inventory:
      gcs_summary:
        enabled: ${INVENTORY_GCS_SUMMARY_ENABLED}
        # data_format may be one of: csv (the default) or json
        data_format: csv
        # gcs_path should begin with "gs://"
        gcs_path: gs://${FORSETI_BUCKET}/inventory_summary
      email_summary:
        enabled: ${INVENTORY_EMAIL_SUMMARY_ENABLED}
