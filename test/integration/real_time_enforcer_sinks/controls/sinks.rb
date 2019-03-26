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

enforcer_topic    = attribute('enforcer_topic')
pubsub_project_id = attribute('pubsub_project_id')
org_id            = attribute('org_id')
org_id_sink_name  = attribute('org_id_sink_name')

control 'sinks' do
  describe command("gcloud logging sinks list --organization #{org_id} --filter='name:#{org_id_sink_name}' --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true).first
      else
        {}
      end
    end

    it "exports logs to the enforcer topic" do
      expect(data[:destination]).to eq "pubsub.googleapis.com/projects/thebo-forseti-svc-d296/topics/#{enforcer_topic}"
    end
  end
end
