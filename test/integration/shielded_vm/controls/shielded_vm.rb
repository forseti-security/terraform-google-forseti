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

server_shielded_vm = attribute("forseti-server-shielded-vm-name")
client_shielded_vm = attribute("forseti-client-shielded-vm-name")
shielded_vms = [server_shielded_vm, client_shielded_vm]

server_unshielded_vm = attribute("forseti-server-unshielded-vm-name")
client_unshielded_vm = attribute("forseti-client-unshielded-vm-name")
unshielded_vms = [server_unshielded_vm, client_unshielded_vm]

control "forseti-shielded-vm" do
  title "Forseti VM"

  shielded_vms.each { |vm|
    describe command("gcloud compute instances describe #{vm} --zone=#{zone} --format=json") do
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

  unshielded_vms.each { |vm|
    describe command("gcloud compute instances describe #{vm} --zone=#{zone} --format=json") do
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
        it 'should not exist' do
          expect(data).not_to have_key(:shieldedInstanceConfig)
        end
      end
    end
  }
end
