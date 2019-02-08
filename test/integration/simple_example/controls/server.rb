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

require 'yaml'

control 'server' do
  title "Forseti server instance resources"
  describe command('forseti') do
    it { should exist }
  end

  describe command("forseti server configuration get") do
    its('exit_status') { should eq 0 }
  end

  describe command('forseti_server') do
    it { should exist }
  end

  describe command('forseti_enforcer') do
    it { should exist }
  end

  describe file("/home/ubuntu/forseti-security/configs/forseti_conf_server.yaml") do 
    it { should exist }
    it "is valid YAML" do
      YAML.load(subject.content)
    end
  end

  %w[
    audit_logging_rules.yaml
    bigquery_rules.yaml
    blacklist_rules.yaml
    bucket_rules.yaml
    cloudsql_rules.yaml
    enabled_apis_rules.yaml
    external_project_access_rules.yaml
    firewall_rules.yaml
    forwarding_rules.yaml
    group_rules.yaml
    iam_rules.yaml
    iap_rules.yaml
    instance_network_interface_rules.yaml
    ke_rules.yaml
    ke_scanner_rules.yaml
    lien_rules.yaml
    location_rules.yaml
    log_sink_rules.yaml
    resource_rules.yaml
    retention_rules.yaml
    service_account_key_rules.yaml
  ].each do |file|
    describe file("/home/ubuntu/forseti-security/rules/#{file}") do
      it { should exist }
      it "is valid YAML" do
        YAML.load(subject.content)
      end
    end
  end
end
