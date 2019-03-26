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

pubsub_project_id = attribute('pubsub_project_id')
org_id            = attribute('org_id')
sink_project_id   = attribute('sink_project_id')
org_sink_name     = attribute('org_sink_name')
org_topic         = attribute('org_topic')
project_sink_name = attribute('project_sink_name')
project_topic     = attribute('project_topic')

control 'sinks' do
  describe command("gcloud logging sinks list --organization #{org_id} --filter='name:#{org_sink_name}' --format=json") do
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
      expect(data[:destination]).to eq "pubsub.googleapis.com/projects/#{pubsub_project_id}/topics/#{org_topic}"
    end
  end

  describe command("gcloud logging sinks list --project #{sink_project_id} --filter='name:#{project_sink_name}' --format=json") do
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
      expect(data[:destination]).to eq "pubsub.googleapis.com/projects/#{pubsub_project_id}/topics/#{project_topic}"
    end
  end
end
