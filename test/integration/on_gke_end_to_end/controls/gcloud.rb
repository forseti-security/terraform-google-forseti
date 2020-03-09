# Copyright 2020 Google LLC
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

cluster_name = attribute('gke_cluster_name')
location = attribute('gke_cluster_location')
project_id = attribute('gke_project_id')

# TODO:
# 3) Verify cron job was deployed: kubectl get cronjobs
# 4) Run cronjob and SSh to client to verify inventory shows up, verify GCS violations exist
control "gcloud" do
  title "Google Compute Engine GKE configuration"
  describe command("gcloud beta --project=#{project_id} container clusters --zone=#{location} describe #{cluster_name} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "cluster" do
      it "is running" do
        expect(data['status']).to eq 'RUNNING'
      end

      it "is regional" do
        expect(data['location']).to match(/^.*[1-9]$/)
      end

      it "is multi zoned" do
        expect(data['locations'].size).to eq 3
      end

      it "uses public nodes and master endpoint" do
        expect(data['privateClusterConfig']).to eq nil
      end
    end

    describe "default node pool" do
      let(:default_node_pool) { data['nodePools'].select { |p| p['name'] == "default-node-pool" }.first }

      it "has initial node count of 1" do
        expect(default_node_pool['initialNodeCount']).to eq 1
      end

      it "has the expected minimum node count" do
        expect(default_node_pool).to include(
          "autoscaling" => including(
            "minNodeCount" => 1,
          ),
        )
      end

      it "has the expected maximum node count" do
        expect(default_node_pool).to include(
          "autoscaling" => including(
            "maxNodeCount" => 1,
          ),
        )
      end

      it "has the expected machine type" do
        expect(default_node_pool).to include(
          "config" => including(
            "machineType" => "n1-standard-8",
          ),
        )
      end

      it "has the expected disk size" do
        expect(default_node_pool).to include(
          "config" => including(
            "diskSizeGb" => 100,
          ),
        )
      end

      it "has the expected labels" do
        expect(default_node_pool).to include(
          "config" => including(
            "labels" => including(
              "cluster_name" => cluster_name,
              "node_pool" => "default-node-pool",
            ),
          ),
        )
      end

      it "has autorepair enabled" do
        expect(default_node_pool).to include(
          "management" => including(
            "autoRepair" => true,
          ),
        )
      end

      it "has the expected status" do
        expect(default_node_pool['status']).to eq 'RUNNING'
      end
    end
  end
end
