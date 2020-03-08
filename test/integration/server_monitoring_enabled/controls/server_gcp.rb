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

require "yaml"

project_id = attribute('project_id')
forseti_server_service_account = attribute('forseti-server-service-account')

control "server_gcp" do
  title "Forseti Server VM with `server_monitoring_enabled=true`"

  describe google_project_iam_binding(project: project_id, role: "roles/monitoring.metricWriter") do
    it { should exist }
    its('members') { should include "serviceAccount:#{forseti_server_service_account}" }
  end
end
