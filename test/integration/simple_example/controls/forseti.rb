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

org_id = attribute('org_id')
project_id = attribute('project_id')
forseti_client_vm_name = attribute('forseti-client-vm-name')
forseti_server_vm_name = attribute('forseti-server-vm-name')
forseti_client_storage_bucket = attribute('forseti-client-storage-bucket')
forseti_server_storage_bucket = attribute('forseti-server-storage-bucket')
forseti_client_service_account = attribute('forseti-client-service-account')
forseti_server_service_account = attribute('forseti-server-service-account')

control 'forseti' do
  title "Forseti GCP resources"

  describe google_compute_instance(
    project: project_id,
    zone: 'us-central1-c',
    name: forseti_client_vm_name
  ) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-2' }
  end

  describe google_compute_instance(
    project: project_id,
    zone: 'us-central1-c',
    name: forseti_server_vm_name
  ) do
    it { should exist }
    its('machine_size') { should eq 'n1-standard-2' }
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

  describe google_storage_buckets(project: project_id) do
    its('bucket_names') { should include forseti_server_storage_bucket }
    its('bucket_names') { should include forseti_client_storage_bucket }
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

  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/#{forseti_client_service_account}") do
    its(:email) { should eq forseti_client_service_account }
    its(:display_name) { should eq "Forseti Client Service Account" }
  end

  describe google_service_account(name: "projects/#{project_id}/serviceAccounts/#{forseti_server_service_account}") do
    its(:email) { should eq forseti_server_service_account }
    its(:display_name) { should eq "Forseti Server Service Account" }
  end

  describe google_compute_firewalls(project: project_id) do
    its('firewall_names') { should include(/forseti-server-ssh-external/) }
    its('firewall_names') { should include(/forseti-server-allow-grpc/) }
    its('firewall_names') { should include(/forseti-server-deny-all/) }
    its('firewall_names') { should include(/forseti-client-ssh-external/) }
    its('firewall_names') { should include(/forseti-client-deny-all/) }
  end

  google_compute_firewalls(project: project_id).where(firewall_name: /forseti-(server|client)-ssh-external/).firewall_names.each do |firewall_name|
    describe google_compute_firewall(project: project_id, name: firewall_name) do
      its('direction') { should eq "INGRESS" }
      its('allowed_ssh?')  { should be true }
      its('allowed_https?') { should be false }
      its('allowed_http?') { should be false }
      its('priority') { should eq 100 }
      it { should_not allow_port_protocol("21", "tcp") }
      it { should_not allow_port_protocol("8080", "tcp") }
    end
  end

  google_compute_firewalls(project: project_id).where(firewall_name: /forseti-server-allow-grpc/).firewall_names.each do |firewall_name|
    describe google_compute_firewall(project: project_id, name: firewall_name) do
      its('direction') { should eq "INGRESS" }
      its('allowed_ssh?')  { should be false }
      its('allowed_https?') { should be false }
      its('allowed_http?') { should be false }
      its('priority') { should eq 100 }
      it { should_not allow_port_protocol("21", "tcp") }
      it { should_not allow_port_protocol("8080", "tcp") }
    end
  end

  google_compute_firewalls(project: project_id).where(firewall_name: /forseti-(client|server)-deny-all/).firewall_names.each do |firewall_name|
    describe google_compute_firewall(project: project_id, name: firewall_name) do
      its('direction') { should eq "INGRESS" }
      its('priority') { should eq 200 }
      its('source_ranges') { should eq ["0.0.0.0/0"] }
      its('denied.first.ip_protocol') { should eq 'icmp' }

      let(:denied) do
        subject.denied
      end
      it 'denied.second.ip_protocol should eq udp' do
        expect(denied[1].ip_protocol).to eq('udp')
      end
      it 'denied.third.ip_protocol should eq tcp' do
        expect(denied[2].ip_protocol).to eq('tcp')
      end
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
        "roles/bigquery.dataViewer",
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
