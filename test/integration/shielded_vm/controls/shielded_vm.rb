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

zone = "us-central1-c"

project_id = attribute("project_id")

server_shielded_vm = attribute("forseti-server-shielded-vm-name")
client_shielded_vm = attribute("forseti-client-shielded-vm-name")
shielded_vms = [server_shielded_vm, client_shielded_vm]

control "shielded-vm" do
  title "Forseti Shielded VM"

  shielded_vms.each { |vm|
    describe command("gcloud compute instances describe #{vm} --zone=#{zone} --project=#{project_id} --format=json") do
      its('exit_status') { should be 0 }
      its('stderr') { should eq '' }

      let!(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout, symbolize_names: true)
        else
          {}
        end
      end

      describe "shielded instance config" do
        it 'should exist' do
          expect(data).to have_key(:shieldedInstanceConfig)
        end

        it 'should have enableIntegrityMonitoring property' do
          expect(data[:shieldedInstanceConfig][:enableIntegrityMonitoring]).to eq true
        end

        it 'should have enableSecureBoot property' do
          expect(data[:shieldedInstanceConfig][:enableSecureBoot]).to eq true
        end

        it 'should have enableVtpm property' do
          expect(data[:shieldedInstanceConfig][:enableVtpm]).to eq true
        end
      end
    end
  }
end
