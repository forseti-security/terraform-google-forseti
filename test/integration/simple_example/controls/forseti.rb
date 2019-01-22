# encoding: utf-8
# copyright: 2018, The Authors

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

title 'Forseti Terraform GCP Test Suite'

project_id = attribute('project_id')
forseti_client_vm_name = attribute('forseti-client-vm-name')
forseti_server_vm_name = attribute('forseti-server-vm-name')
forseti_client_storage_bucket = attribute('forseti-client-storage-bucket')
forseti_server_storage_bucket = attribute('forseti-server-storage-bucket')
forseti_client_service_account = attribute('forseti-client-service-account')
forseti_server_service_account = attribute('forseti-server-service-account')

control 'forseti-client-vm' do
  title 'Test forseti client vm'
  describe google_compute_instance(
    project: project_id,
    zone: 'us-central1-c',
    name: forseti_client_vm_name
  ) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-2' }
  end
end

control 'forseti-server-vm' do
  title 'Test forseti server vm'
  describe google_compute_instance(
    project: project_id,
    zone: 'us-central1-c',
    name: forseti_server_vm_name
  ) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-2' }
  end
end

control 'forseti-cloudsql-instance' do
  title 'Test CloudSQL Instance is up'
  describe google_sql_database_instances(project: project_id) do
    its('instance_names') { should include(/forseti-server-db-*/) }
  end
end

control 'forseti-server-iam-roles' do
  title 'Test Server Project IAM Role bindings'
  describe google_project_iam_binding(project: project_id, role: "roles/storage.objectViewer") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/storage.objectCreator") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/cloudsql.client") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/cloudtrace.agent") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/logging.logWriter") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/iam.serviceAccountTokenCreator") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
end

# @todo: Create Terraform test fixture with `enable_write = "true"`
#control 'forseti-server-read-iam-roles' do
#  title 'Test Server Read Org Level IAM Role bindings'
#  describe google_project_iam_binding(project: project_id, role: "roles/compute.securityAdmin") do
#    it { should exist }
#    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
#  end
#end

control 'forseti-google-storage-buckets' do
  title 'Test GCS Buckets are present'
  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include forseti_server_storage_bucket }
    its('bucket_names') { should include forseti_client_storage_bucket }
    its('bucket_names') { should include(/forseti-cai-export/) }
  end

  describe google_storage_bucket_objects(bucket: forseti_server_storage_bucket) do
    let(:files) do
      %w[
        rules/audit_logging_rules.yaml
        rules/bigquery_rules.yaml
        rules/blacklist_rules.yaml
        rules/bucket_rules.yaml
        rules/cloudsql_rules.yaml
        rules/enabled_apis_rules.yaml
        rules/external_project_access_rules.yaml
        rules/firewall_rules.yaml
        rules/forwarding_rules.yaml
        rules/group_rules.yaml
        rules/iam_rules.yaml
        rules/iap_rules.yaml
        rules/instance_network_interface_rules.yaml
        rules/ke_rules.yaml
        rules/ke_scanner_rules.yaml
        rules/lien_rules.yaml
        rules/location_rules.yaml
        rules/log_sink_rules.yaml
        rules/resource_rules.yaml
        rules/retention_rules.yaml
        rules/service_account_key_rules.yaml
      ]
    end

    its('object_names') { should include(*files) }
  end
end

control 'forseti-client-service-account' do
  title 'Test Forseti Client Service Account'
  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/#{forseti_client_service_account}") do
    its(:email) { should eq forseti_client_service_account }
    its(:display_name) { should eq "Forseti Client Service Account" }
  end
end

control 'forseti-server-service-account' do
  title 'Test Forseti Server Service Account'
  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/#{forseti_server_service_account}") do
    its(:email) { should eq forseti_server_service_account }
    its(:display_name) { should eq "Forseti Server Service Account" }
  end
end

control 'forseti-firewall-rules' do
  title 'Test Forseti Firewall Rules'
  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include(/forseti-server-ssh-external/) }
    its('firewall_names') { should include(/forseti-server-allow-grpc/) }
    its('firewall_names') { should include(/forseti-server-deny-all/) }
  end
end
