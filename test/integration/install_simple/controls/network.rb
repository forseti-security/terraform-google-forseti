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
# encoding: utf-8

project_id = attribute('project_id')
forseti_server_vm_name = attribute('forseti-server-vm-name')
forseti_client_vm_name = attribute('forseti-client-vm-name')
forseti_cloud_nat_name = 'clout-nat-' + project_id
forseti_router_name = 'router-' + project_id

control 'forseti-nat' do
  title "Forseti GCP NAT resources"

  describe google_compute_router_nat(
    project: project_id,
    region: 'us-central1',
    router: forseti_router_name,
    name: forseti_cloud_nat_name
    ) do
    it { should exist }
  end

  describe google_compute_routers(
    project: project_id,
    region: 'us-central1'
  ) do
    its('names') { should include forseti_router_name }
  end

end

control 'forseti-no-public-ips' do
  title "Ensure no public IP addresses on Forseti Client and Server VM"
  describe command(
    "gcloud compute instances describe #{forseti_server_vm_name} --flatten='networkInterfaces' --format='json(networkInterfaces.accessConfigs)' --zone=us-central1-c --project=#{project_id}"
  ) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:access_configs) do
      JSON.parse(subject.stdout)
    end

    it 'Server has no public IP address' do
      expect(access_configs).to match_array([nil])
    end
  end

  describe command(
    "gcloud compute instances describe #{forseti_client_vm_name} --flatten='networkInterfaces' --format='json(networkInterfaces.accessConfigs)' --zone=us-central1-c --project=#{project_id}"
  ) do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:access_configs) do
      JSON.parse(subject.stdout)
    end

    it 'Client has no public IP address' do
      expect(access_configs).to match_array([nil])
    end
  end
end