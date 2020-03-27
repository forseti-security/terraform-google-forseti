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

require "yaml"

control "server-rules" do
  title "Forseti scanner rules exist on server VM"

  # Enumerate the files that we expect to be present. This fixture ensures that we
  # don't silently drop a rules file.
  expected_files = %w[
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
    role_rules.yaml
    service_account_key_rules.yaml
  ]

  template_dir = File.expand_path("../../../../modules/rules/templates/rules", __dir__)

  # Enumerate the files that are present in the rules directory. This fixture ensures
  # that we don't miss an included rules file.
  present_files = Dir.glob("#{template_dir}/*.yaml").map { |file| File.basename(file) }

  files = expected_files | present_files

  files.each do |file|
    describe file("/home/ubuntu/forseti-security/rules/#{file}") do
      it { should exist }
      it "is valid YAML" do
        YAML.load(subject.content)
      end
    end
  end
end
