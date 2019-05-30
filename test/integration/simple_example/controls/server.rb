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

require "yaml"

forseti_version = "2.16.0"

control "server" do
  title "Forseti server instance resources"
  describe command("forseti") do
    it { should exist }
  end

  describe command("forseti server configuration get") do
    its("exit_status") { should eq 0 }
  end

  describe command("forseti inventory list") do
    its("exit_status") { should eq 0 }
  end

  describe command("forseti_server") do
    it { should exist }
  end

  describe command("forseti_enforcer") do
    it { should exist }
  end

  describe command("pip show forseti-security|grep Version") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match("Version: #{forseti_version}") }
  end

  describe file("/home/ubuntu/forseti-security/configs/forseti_conf_server.yaml") do
    it { should exist }
    it "is valid YAML" do
      YAML.load(subject.content)
    end

    let(:config) { YAML.load(subject.content) }

    describe "inventory" do
      describe "api_quota" do
        it "configures admin_max_calls" do
          expect(config["inventory"]["api_quota"]["admin"]["max_calls"]).to eq 14
        end

        it "configures admin_period" do
          expect(config["inventory"]["api_quota"]["admin"]["period"]).to eq 1.0
        end

        it "configures admin_disable_polling" do
          expect(config["inventory"]["api_quota"]["admin"]["disable_polling"]).to eq false
        end

        it "configures appengine_max_calls" do
          expect(config["inventory"]["api_quota"]["appengine"]["max_calls"]).to eq 18
        end

        it "configures appengine_period" do
          expect(config["inventory"]["api_quota"]["appengine"]["period"]).to eq 1.0
        end

        it "configures appengine_disable_polling" do
          expect(config["inventory"]["api_quota"]["appengine"]["disable_polling"]).to eq false
        end

        it "configures bigquery_max_calls" do
          expect(config["inventory"]["api_quota"]["bigquery"]["max_calls"]).to eq 160
        end

        it "configures bigquery_period" do
          expect(config["inventory"]["api_quota"]["bigquery"]["period"]).to eq 1.0
        end

        it "configures bigquery_disable_polling" do
          expect(config["inventory"]["api_quota"]["bigquery"]["disable_polling"]).to eq false
        end

        it "configures cloudasset_max_calls" do
          expect(config["inventory"]["api_quota"]["cloudasset"]["max_calls"]).to eq 1
        end

        it "configures cloudasset_period" do
          expect(config["inventory"]["api_quota"]["cloudasset"]["period"]).to eq 1.0
        end

        it "configures cloudasset_disable_polling" do
          expect(config["inventory"]["api_quota"]["cloudasset"]["disable_polling"]).to eq false
        end

        it "configures cloudbilling_max_calls" do
          expect(config["inventory"]["api_quota"]["cloudbilling"]["max_calls"]).to eq 5
        end

        it "configures cloudbilling_period" do
          expect(config["inventory"]["api_quota"]["cloudbilling"]["period"]).to eq 1.2
        end

        it "configures cloudbilling_disable_polling" do
          expect(config["inventory"]["api_quota"]["cloudbilling"]["disable_polling"]).to eq false
        end

        it "configures compute_max_calls" do
          expect(config["inventory"]["api_quota"]["compute"]["max_calls"]).to eq 18
        end

        it "configures compute_period" do
          expect(config["inventory"]["api_quota"]["compute"]["period"]).to eq 1.0
        end

        it "configures compute_disable_polling" do
          expect(config["inventory"]["api_quota"]["compute"]["disable_polling"]).to eq false
        end

        it "configures container_max_calls" do
          expect(config["inventory"]["api_quota"]["container"]["max_calls"]).to eq 9
        end

        it "configures container_period" do
          expect(config["inventory"]["api_quota"]["container"]["period"]).to eq 1.0
        end

        it "configures container_disable_polling" do
          expect(config["inventory"]["api_quota"]["container"]["disable_polling"]).to eq false
        end

        it "configures crm_max_calls" do
          expect(config["inventory"]["api_quota"]["crm"]["max_calls"]).to eq 4
        end

        it "configures crm_period" do
          expect(config["inventory"]["api_quota"]["crm"]["period"]).to eq 1.2
        end

        it "configures crm_disable_polling" do
          expect(config["inventory"]["api_quota"]["crm"]["disable_polling"]).to eq false
        end

        it "configures groups_settings_max_calls" do
          expect(config["inventory"]["api_quota"]["groupssettings"]["max_calls"]).to eq 5
        end

        it "configures groups_settings_period" do
          expect(config["inventory"]["api_quota"]["groupssettings"]["period"]).to eq 1.1
        end

        it "configures groups_settings_disable_polling" do
          expect(config["inventory"]["api_quota"]["groupssettings"]["disable_polling"]).to eq false
        end

        it "configures iam_max_calls" do
          expect(config["inventory"]["api_quota"]["iam"]["max_calls"]).to eq 90
        end

        it "configures iam_period" do
          expect(config["inventory"]["api_quota"]["iam"]["period"]).to eq 1.0
        end

        it "configures iam_disable_polling" do
          expect(config["inventory"]["api_quota"]["iam"]["disable_polling"]).to eq false
        end

        it "configures logging_max_calls" do
          expect(config["inventory"]["api_quota"]["logging"]["max_calls"]).to eq 9
        end

        it "configures logging_period" do
          expect(config["inventory"]["api_quota"]["logging"]["period"]).to eq 1.0
        end

        it "configures logging_disable_polling" do
          expect(config["inventory"]["api_quota"]["logging"]["disable_polling"]).to eq false
        end

        it "configures securitycenter_max_calls" do
          expect(config["inventory"]["api_quota"]["securitycenter"]["max_calls"]).to eq 1
        end

        it "configures securitycenter_period" do
          expect(config["inventory"]["api_quota"]["securitycenter"]["period"]).to eq 1.1
        end

        it "configures securitycenter_disable_polling" do
          expect(config["inventory"]["api_quota"]["securitycenter"]["disable_polling"]).to eq false
        end

        it "configures servicemanagement_max_calls" do
          expect(config["inventory"]["api_quota"]["servicemanagement"]["max_calls"]).to eq 2
        end

        it "configures servicemanagement_period" do
          expect(config["inventory"]["api_quota"]["servicemanagement"]["period"]).to eq 1.1
        end

        it "configures servicemanagement_disable_polling" do
          expect(config["inventory"]["api_quota"]["servicemanagement"]["disable_polling"]).to eq false
        end

        it "configures sqladmin_max_calls" do
          expect(config["inventory"]["api_quota"]["sqladmin"]["max_calls"]).to eq 1
        end

        it "configures sqladmin_period" do
          expect(config["inventory"]["api_quota"]["sqladmin"]["period"]).to eq 1.1
        end

        it "configures sqladmin_disable_polling" do
          expect(config["inventory"]["api_quota"]["sqladmin"]["disable_polling"]).to eq false
        end

        it "configures storage_disable_polling" do
          expect(config["inventory"]["api_quota"]["storage"]["disable_polling"]).to eq false
        end
      end

      it "configures cai_api_timeout" do
        expect(config["inventory"]["cai"]["api_timeout"]).to eq 3600
      end

      it "configures inventory_retention_days" do
        expect(config["inventory"]["retention_days"]).to eq(-1)
      end
    end

    describe "scanner" do
      it "configures audit_logging_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "audit_logging", "enabled" => false)
      end

      it "configures bigquery_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "bigquery", "enabled" => true)
      end

      it "configures blacklist_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "blacklist", "enabled" => true)
      end

      it "configures bucket_acl_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "bucket_acl", "enabled" => true)
      end

      it "configures cloudsql_acl_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "cloudsql_acl", "enabled" => true)
      end

      it "configures enabled_apis_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "enabled_apis", "enabled" => false)
      end

      it "configures firewall_rule_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "firewall_rule", "enabled" => true)
      end

      it "configures forwarding_rule_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "forwarding_rule", "enabled" => false)
      end

      it "configures group_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "group", "enabled" => true)
      end

      it "configures iam_policy_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "iam_policy", "enabled" => true)
      end

      it "configures iap_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "iap", "enabled" => true)
      end

      it "configures instance_network_interface_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "instance_network_interface", "enabled" => false)
      end

      it "configures ke_scanner_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "ke_scanner", "enabled" => false)
      end

      it "configures ke_version_scanner_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "ke_version_scanner", "enabled" => true)
      end

      it "configures kms_scanner_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "kms_scanner", "enabled" => true)
      end

      it "configures lien_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "lien", "enabled" => true)
      end

      it "configures location_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "location", "enabled" => true)
      end

      it "configures log_sink_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "log_sink", "enabled" => true)
      end

      it "configures resource_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "resource", "enabled" => true)
      end

      it "configures service_account_key_enabled" do
        expect(config["scanner"]["scanners"]).to include("name" => "service_account_key", "enabled" => true)
      end
    end

    describe "notifier" do
      describe "resources" do
        it "configures iam_policy_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(
            including(
              "resource" => "iam_policy_violations",
              "should_notify" => true,
              # This extra bit of verification tests the `iam_policy_violations_slack_webhook` variable
              "notifiers" => including("name" => "slack_webhook", "configuration" => { "data_format" => "json", "webhook_url" => nil }),
            )
          )
        end

        it "configures audit_logging_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "audit_logging_violations", "should_notify" => true))
        end

        it "configures blacklist_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "blacklist_violations", "should_notify" => true))
        end

        it "configures bigquery_acl_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "bigquery_acl_violations", "should_notify" => true))
        end

        it "configures buckets_acl_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "buckets_acl_violations", "should_notify" => true))
        end

        it "configures cloudsql_acl_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "cloudsql_acl_violations", "should_notify" => true))
        end

        it "configures enabled_apis_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "enabled_apis_violations", "should_notify" => true))
        end

        it "configures firewall_rule_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "firewall_rule_violations", "should_notify" => true))
        end

        it "configures forwarding_rule_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "forwarding_rule_violations", "should_notify" => true))
        end

        it "configures ke_version_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "ke_version_violations", "should_notify" => true))
        end

        it "configures ke_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "ke_violations", "should_notify" => true))
        end

        it "configures kms_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(
            including(
              "resource" => "kms_violations",
              "should_notify" => true,
              # This extra bit of verification tests the `kms_violations_slack_webhook` variable
              "notifiers" => including("name" => "slack_webhook", "configuration" => { "data_format" => "json", "webhook_url" => nil }),
            )
          )
        end

        it "configures groups_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "groups_violations", "should_notify" => true))
        end

        it "configures instance_network_interface_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "instance_network_interface_violations", "should_notify" => true))
        end

        it "configures iap_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "iap_violations", "should_notify" => true))
        end

        it "configures lien_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "lien_violations", "should_notify" => true))
        end

        it "configures location_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "location_violations", "should_notify" => true))
        end

        it "configures log_sink_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "log_sink_violations", "should_notify" => true))
        end

        it "configures resource_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "resource_violations", "should_notify" => true))
        end

        it "configures service_account_key_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "service_account_key_violations", "should_notify" => true))
        end

        it "configures external_project_access_violations_should_notify" do
          expect(config["notifier"]["resources"]).to include(including("resource" => "external_project_access_violations", "should_notify" => true))
        end
      end

      it "configures cscc_violations_enabled" do
        expect(config["notifier"]["violation"]["cscc"]["enabled"]).to eq false
      end

      it "configures cscc_source_id" do
        expect(config["notifier"]["violation"]["cscc"]["source_id"]).to be_nil
      end

      it "configures inventory_gcs_summary_enabled" do
        expect(config["notifier"]["inventory"]["gcs_summary"]["enabled"]).to eq true
      end

      it "configures inventory_email_summary_enabled" do
        expect(config["notifier"]["inventory"]["email_summary"]["enabled"]).to eq true
      end
    end
  end

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
