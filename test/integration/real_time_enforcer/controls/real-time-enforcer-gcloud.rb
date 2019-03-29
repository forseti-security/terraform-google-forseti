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

org_id = attribute('org_id')
forseti_rt_enforcer_service_account = attribute('forseti-rt-enforcer-service-account')
forseti_rt_enforcer_viewer_role_id = attribute('forseti-rt-enforcer-viewer-role-id')
forseti_rt_enforcer_writer_role_id = attribute('forseti-rt-enforcer-writer-role-id')

control 'real-time-enforcer-gcloud' do
  describe command("gcloud organizations get-iam-policy #{org_id} --filter='bindings.members:#{forseti_rt_enforcer_service_account}' --flatten='bindings[].members' --format='json(bindings.role)'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:roles) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true).map { |a| a[:bindings][:role] }
      else
        []
      end
    end

    it 'permits the enforcer to view and enforcer policy' do
      expect(roles).to contain_exactly(forseti_rt_enforcer_viewer_role_id, forseti_rt_enforcer_writer_role_id)
    end
  end
end
