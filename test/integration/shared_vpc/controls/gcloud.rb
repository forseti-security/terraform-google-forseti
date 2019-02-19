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
forseti_client_vm_ip    = attribute("forseti-client-vm-ip")
region                  = attribute("region")
network_name            = attribute('network_name')

control 'forseti-command-server' do
  impact 1.0
  title 'Check that forseti server is running'
  describe command("gcloud compute ssh #{forseti_server_vm_name} --project #{project_id}  --zone=#{region}-c --command 'sudo systemctl status forseti --no-page'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
  end
  describe command("gcloud compute ssh #{forseti_server_vm_name} --project #{project_id}  --zone=#{region}-c --command 'forseti config show'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:response) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout.tr("'",'"'), symbolize_names: true)
      else
        {}
      end
    end

    it 'forseti config should point to gRPC port' do
      expect(response).to include(endpoint: 'localhost:50051')
    end
  end
end

control 'forseti-command-client' do
  impact 1.0
  title 'Check that forseti client is running'
  describe command("gcloud compute ssh #{forseti_client_vm_name} --project #{project_id}  --zone=#{region}-c --command 'forseti config show'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:response) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout.tr("'",'"'), symbolize_names: true)
      else
        {}
      end
    end

    it 'forseti config should point to gRPC port' do
      expect(response).to include(endpoint: "#{forseti_client_vm_ip}:50051")
    end
  end
end