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

suffix                              = attribute('suffix')
project_id                          = attribute('project_id')
enforcer_project_id                 = attribute('enforcer_project_id')
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
    let(:files) do
      # Enumerate the files that we expect to be present. This fixture ensures that we
      # don't silently drop a policy file.
      expected_files = %w[
        policy/bigquery/common.rego
        policy/bigquery/dataset_no_public_access.rego
        policy/bigquery/dataset_no_public_authenticated_access.rego
        policy/cloudresourcemanager/common_iam.rego
        policy/exclusions.rego
        policy/policies.rego
        policy/config.yaml
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
      present_files = Dir.glob("#{template_dir}/policy/**/*.*").map { |path| path.sub(/\A#{template_dir}\//, '') }

      expected_files | present_files
    end

    its('object_names') { should contain_exactly(*files) }
  end

  describe google_compute_firewall(project: project_id, name: "forseti-rt-enforcer-ssh-external-#{suffix}") do
    its('source_ranges') { should eq ["0.0.0.0/0"] }
    its('direction') { should eq 'INGRESS' }
    its('allowed_ssh?') { should be true }
    its('priority') { should eq 100 }
  end

  describe google_compute_firewall(project: project_id, name: "forseti-rt-enforcer-deny-all-#{suffix}") do
    let(:denied) { subject.denied.map(&:item) }

    its('source_ranges') { should eq ["0.0.0.0/0"] }
    its('direction') { should eq 'INGRESS' }
    its('priority') { should eq 200 }

    it "denies TCP, UDP, and ICMP" do
      expect(denied).to contain_exactly(
        {ip_protocol: "icmp"},
        {ip_protocol: "tcp"},
        {ip_protocol: "udp"}
      )
    end
  end

  describe google_project_iam_binding(project: project_id, role: 'roles/logging.logWriter') do
    its('members') { should include "serviceAccount:#{forseti_rt_enforcer_service_account}" }
  end
end

control 'real-time-enforcer-target-gcp' do
  google_storage_buckets(project: enforcer_project_id).bucket_names.each do |bucket_name|
    describe google_storage_bucket_acl(bucket: bucket_name, entity: 'allAuthenticatedUsers') do
      it { should_not exist }
    end

    describe google_storage_bucket_acl(bucket: bucket_name, entity: 'allUsers') do
      it { should_not exist }
    end
  end
end
