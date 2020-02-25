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
suffix = attribute("suffix")

control "forseti-no-client-vm" do
  title "Forseti No Client VM"

  describe command("gcloud compute instances list --filter='zone:#{zone}' --project=#{project_id} --format='json(name)'") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        []
      end
    end

    it 'should have server VM' do
      expect(data).to include({:name => "forseti-server-vm-#{suffix}"})
    end

    it 'should not have client VM' do
      expect(data).not_to include({:name => "forseti-client-vm-#{suffix}"})
    end
  end

  describe command("gcloud iam service-accounts list --project=#{project_id} --format='json(email)'") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        []
      end
    end

    it 'should have server service account' do
      expect(data).to include({:email => "forseti-server-gcp-#{suffix}@#{project_id}.iam.gserviceaccount.com"})
    end

    it 'should not have client service account' do
      expect(data).not_to include({:email => "forseti-client-gcp-#{suffix}@#{project_id}.iam.gserviceaccount.com"})
    end
  end

  describe command("gsutil ls -p #{project_id}") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "gs://forseti-cai-export-#{suffix}" }
    its(:stdout) { should match "gs://forseti-server-#{suffix}" }
    its(:stdout) { should_not match "gs://forseti-client-#{suffix}" }
  end
end
