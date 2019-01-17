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

control 'forseti-client-vm' do
  impact 1.0
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
  impact 1.0
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
  impact 1.0
  title 'Test CloudSQL Instance is up'
  describe google_sql_database_instances(project: project_id) do
    its('instance_names') { should include /forseti-server-db-*/ }
  end
end


control 'forseti-server-iam-roles' do

  impact 1.0
  title 'Test Server Project IAM Role bindings'
  describe google_project_iam_binding(project: project_id, role: "roles/storage.objectViewer") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/storage.objectCreator") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/cloudsql.client") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/cloudtrace.agent") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/logging.logWriter") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/iam.serviceAccountTokenCreator") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
end

# @TODO Need to figure out the Org level permissions to execute this test
#
# control 'forseti-server-read-iam-roles' do
#   gcp_enable_privileged_resources = '1'
#
#   impact 1.0
#   title 'Test Server Read Org Level IAM Role bindings'
#   describe google_project_iam_binding(project: , role: "roles/compute.securityAdmin") do
#     it { should exist }
#     its ('members'){ should include /forseti/ }
#   end
# end

control 'forseti-google-storage-buckets' do
  impact 1.0
  title 'Test GCS Buckets are present'
  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include /forseti-server/ }
  end
  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include /forseti-client/ }
  end
  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include /forseti-cai-export/ }
  end
  # @TODO can't get the bucket to accept regex matching, below works but doesn't account for random_id
  # describe google_storage_bucket_objects(bucket: 'forseti-server-52d2853a') do
  #   its('object_names'){ should include 'configs/forseti_conf_server.yaml' }
  # end
end

control 'forseti-client-service-account' do
  impact 1.0
  title 'Test Forseti Client Service Account'
  describe google_service_accounts(project: project_id) do
    its('service_account_emails'){ should include /forseti-client-gcp/ }
  end
end

control 'forseti-server-service-account' do
  impact 1.0
  title 'Test Forseti Server Service Account'
  describe google_service_accounts(project: project_id) do
    its('service_account_emails'){ should include /forseti-server-gcp/ }
  end
end

control 'forseti-firewall-rules' do
  impact 1.0
  title 'Test Forseti Firewall Rules'
  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include /forseti-server-ssh-external/ }
  end
  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include /forseti-server-allow-grpc/ }
  end
  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include /forseti-server-deny-all/ }
  end

end
