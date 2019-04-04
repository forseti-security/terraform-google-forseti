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


project_id      = attribute("project_id")
network_project = attribute("network_project")

control 'forseti-service-project' do
  title 'Forseti service project'
  describe google_compute_project_info(project: project_id) do
    its('xpn_project_status') { should eq 'UNSPECIFIED_XPN_PROJECT_STATUS' }
    its('name') { should eq project_id }
  end
end

control 'forseti-shared-project' do
  title 'Forseti host project'
  describe google_compute_project_info(project: network_project) do
    its('xpn_project_status') { should eq 'HOST' }
    its('name') { should eq network_project }
  end
end
