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

project_id                          = attribute('project_id')
forseti_rt_enforcer_vm_name         = attribute('forseti-rt-enforcer-vm-name')
forseti_rt_enforcer_service_account = attribute('forseti-rt-enforcer-service-account')
forseti_rt_enforcer_topic           = attribute('forseti-rt-enforcer-topic')
forseti_rt_enforcer_storage_bucket  = attribute('forseti-rt-enforcer-storage-bucket')

control 'real-time-enforcer-gcp' do
  title "Real time enforcer GCP resources"

  describe google_compute_instance(project: project_id, zone: 'us-central1-c', name: forseti_rt_enforcer_vm_name) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-2' }
  end

  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/#{forseti_rt_enforcer_service_account}") do
    its(:email) { should eq forseti_rt_enforcer_service_account }
    its(:display_name) { should eq "Forseti Real Time Enforcer" }
  end

  describe google_pubsub_topic(project: project_id, name: forseti_rt_enforcer_topic) do
    it { should exist }
  end

  describe google_storage_bucket(name: forseti_rt_enforcer_storage_bucket) do
    it { should exist }
  end

  describe google_storage_bucket_iam_binding(bucket: forseti_rt_enforcer_storage_bucket, role: 'roles/storage.objectViewer') do
    its('members') { should include "serviceAccount:#{forseti_rt_enforcer_service_account}" }
    it { should exist }
  end

  describe google_storage_bucket_objects(bucket: forseti_rt_enforcer_storage_bucket) do
    # Enumerate the files that we expect to be present. This fixture ensures that we
    # don't silently drop a policy file.
    expected_files = %w[
      policy/bigquery/common.rego
      policy/bigquery/dataset_no_public_access.rego
      policy/bigquery/dataset_no_public_authenticated_access.rego
      policy/cloudresourcemanager/common_iam.rego
      policy/exclusions.rego
      policy/policies.rego
      policy/sql/acl.rego
      policy/sql/backups.rego
      policy/sql/common.rego
      policy/sql/require_ssl.rego
      policy/storage/bucket_iam_disallow_allauthenticatedusers.rego
      policy/storage/bucket_iam_disallow_allusers.rego
      policy/storage/common.rego
      policy/storage/common_iam.rego
      policy/storage/versioning.rego
    ]

    # Enumerate the files present in the policy directory. This fixture ensures that
    # we actually upload all files in the policy directory.
    template_dir = File.expand_path("../../../../modules/real_time_enforcer/files", __dir__)
    present_files = Dir.glob("#{template_dir}/policy/*.rego").map { |path| path.sub(/\A#{template_dir}\//, '') }

    files = expected_files | present_files

    files.each do |file|
      its('object_names') { should include(file) }
    end
  end
end
