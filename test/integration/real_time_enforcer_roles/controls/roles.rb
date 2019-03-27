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

org_id                             = attribute("org_id")
forseti_rt_enforcer_viewer_role_id = attribute("forseti-rt-enforcer-viewer-role-id")
forseti_rt_enforcer_writer_role_id = attribute("forseti-rt-enforcer-writer-role-id")

control 'roles' do
  # Extract the role ID to match the requirements of `gcloud iam roles describe`
  viewer_role_id = forseti_rt_enforcer_viewer_role_id.split("/").last
  writer_role_id = forseti_rt_enforcer_writer_role_id.split("/").last

  describe command("gcloud iam roles describe --organization #{org_id} #{viewer_role_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        {}
      end
    end

    it "sets the correct permissions" do
      expect(data[:includedPermissions]).to contain_exactly(
        "bigquery.datasets.get",
        "bigquery.datasets.getIamPolicy",
        "cloudsql.instances.get",
        "resourcemanager.projects.get",
        "resourcemanager.projects.getIamPolicy",
        "storage.buckets.get",
        "storage.buckets.getIamPolicy",
      )
    end
  end

  describe command("gcloud iam roles describe --organization #{org_id} #{writer_role_id} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        {}
      end
    end

    it "sets the correct permissions" do
      expect(data[:includedPermissions]).to contain_exactly(
        "storage.buckets.setIamPolicy",
        "storage.buckets.update",
        "bigquery.datasets.setIamPolicy",
        "cloudsql.instances.update",
        "resourcemanager.projects.setIamPolicy"
      )
    end
  end
end
