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

    let(:expected_roles) do
      [
        "organizations/#{org_id}/roles/forseti.enforcerViewer",
        "organizations/#{org_id}/roles/forseti.enforcerWriter"
      ]
    end

    it 'permits the enforcer to view and enforce policy' do
      expect(roles).to contain_exactly(*expected_roles)
    end
  end
end
