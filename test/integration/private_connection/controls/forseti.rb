# Copyright 2020 Google LLC
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
# encoding: utf-8

org_id = attribute('org_id')
project_id = attribute('project_id')
suffix = attribute('suffix')
forseti_server_vm_name = attribute('forseti-server-vm-name')
forseti_server_storage_bucket = attribute('forseti-server-storage-bucket')
forseti_server_service_account = attribute('forseti-server-service-account')

control 'forseti' do
  title "Forseti GCP resources"

  describe google_compute_instance(
    project: project_id,
    zone: 'us-central1-c',
    name: forseti_server_vm_name
  ) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-8' }
    its('network_interfaces_count'){should eq 1}
  end

  describe google_sql_database_instances(project: project_id) do
    its('instance_names') { should include(/forseti-server-db-*/) }
  end

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
  describe google_project_iam_binding(project: project_id, role: "roles/logging.logWriter") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
  describe google_project_iam_binding(project: project_id, role: "roles/iam.serviceAccountTokenCreator") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end

  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include forseti_server_storage_bucket }
    its('bucket_names') { should include(/forseti-cai-export/) }
  end

  describe google_storage_bucket_objects(bucket: forseti_server_storage_bucket) do

    # Enumerate the files that we expect to be present. This fixture ensures that we
    # don't silently drop a rules file.
    let(:expected_files) do
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
        rules/groups_settings_rules.yaml
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
        rules/role_rules.yaml
        rules/service_account_key_rules.yaml
      ]
    end

    # Enumerate the files that are present in the rules directory  This fixture ensures
    # that we don't miss an included rules file.
    let(:present_files) do
      template_dir = File.expand_path(
        "../../../../modules/rules/templates/rules",
        __dir__
      )
      Dir.glob("#{template_dir}/*.yaml").map {|file| "rules/#{File.basename(file)}" }
    end

    let(:files) { expected_files | present_files }

    its('object_names') { should include(*files) }
  end

  describe google_service_account(project: project_id, name: "projects/#{project_id}/serviceAccounts/#{forseti_server_service_account}") do
    its(:email) { should eq forseti_server_service_account }
    its(:display_name) { should eq "Forseti Server Service Account" }
  end

  describe google_compute_firewall(project: project_id, name: "forseti-server-allow-grpc-#{suffix}") do
    let(:allowed) { subject.allowed.map(&:item) }

    its('source_ranges') { should eq ["10.128.0.0/9"] }
    its('direction') { should eq 'INGRESS' }
    its('priority') { should eq 100 }

    it "allows gRPC traffic" do
      expect(allowed).to contain_exactly({ip_protocol: "tcp", ports: ["50051", "50052"]})
    end
  end

  describe google_compute_firewall(project: project_id, name: "forseti-server-deny-all-#{suffix}") do
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
end

control 'forseti-org-iam' do
  title "Validate organization roles of SA"
  describe command("gcloud organizations get-iam-policy #{org_id} --filter='bindings.members:#{forseti_server_service_account}' --flatten='bindings[].members' --format='json(bindings.role)'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:sa_roles) do
      JSON.parse(subject.stdout).map { |a| a["bindings"]["role"] }
    end

    let(:expected_roles) do
      [
        "roles/appengine.appViewer",
        "roles/bigquery.metadataViewer",
        "roles/browser",
        "roles/cloudasset.viewer",
        "roles/cloudsql.viewer",
        "roles/compute.networkViewer",
        "roles/iam.securityReviewer",
        "roles/orgpolicy.policyViewer",
        "roles/servicemanagement.quotaViewer",
        "roles/serviceusage.serviceUsageConsumer",
      ]
    end

    it 'has all expected org roles' do
      expect(sa_roles).to match_array(expected_roles)
    end
  end
end
