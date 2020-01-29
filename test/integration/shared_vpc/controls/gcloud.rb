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

title 'Forseti Terraform GCP Test Suite for Shared VPC setup using gcloud command'

project_id              = attribute("project_id")
forseti_server_vm_name  = attribute("forseti-server-vm-name")
forseti_server_vm_ip    = attribute("forseti-server-vm-ip")
forseti_client_vm_name  = attribute("forseti-client-vm-name")
region                  = attribute("region")
subnetwork              = attribute("subnetwork")
network_project         = attribute("network_project")

control 'forseti-subnetwork' do
  impact 1.0
  title 'Check that forseti server and client are on a proper subnet'
  describe command("gcloud compute instances describe #{forseti_server_vm_name} --project #{project_id} --zone #{region}-c --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        {}
      end
    end

    it 'forseti server should be on shared vpc subnetwork' do
      expect(data[:networkInterfaces].first).to include(subnetwork: "https://www.googleapis.com/compute/v1/projects/#{network_project}/regions/#{region}/subnetworks/#{subnetwork}")
    end
  end
  describe command("gcloud compute instances describe #{forseti_client_vm_name} --project #{project_id} --zone #{region}-c --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        {}
      end
    end

    it 'forseti server should be on shared vpc subnetwork' do
      expect(data[:networkInterfaces].first).to include(subnetwork: "https://www.googleapis.com/compute/v1/projects/#{network_project}/regions/#{region}/subnetworks/#{subnetwork}")
    end
  end
end

control 'forseti-command-server' do
  impact 1.0
  title 'Check that forseti server is running'
  describe command("sudo systemctl status forseti --no-page") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    its(:stdout) { should match(/Active: active/) }
  end

  describe command("forseti config show") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
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

  describe command('forseti') do
    it { should exist }
  end
end

control 'forseti-command-client' do
  impact 1.0
  title 'Check that forseti client is running'
  describe command("forseti config show") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    its(:stdout) { should match /'endpoint': '#{forseti_server_vm_ip}:50051'/ }
  end
end
