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

require 'base64'
require 'kubeclient'
require 'rest-client'

ca_certificate = attribute('ca_certificate')
client_token = attribute('client_token')
kubernetes_endpoint = attribute('kubernetes_endpoint')

control "kubectl" do
  title "Kubernetes configuration"

  describe "kubernetes" do
    let(:kubernetes_http_endpoint) { "https://#{kubernetes_endpoint}/api" }
    let(:client) do
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(Base64.decode64(ca_certificate)))
      Kubeclient::Client.new(
        kubernetes_http_endpoint,
        "v1",
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        },
        auth_options: {
          bearer_token: Base64.decode64(client_token),
        },
      )
    end

    let(:kubernetes_batch_http_endpoint) { "https://#{kubernetes_endpoint}/apis/batch" }
    let(:batch_client) do
      cert_store = OpenSSL::X509::Store.new
      cert_store.add_cert(OpenSSL::X509::Certificate.new(Base64.decode64(ca_certificate)))
      Kubeclient::Client.new(
        kubernetes_batch_http_endpoint,
        "v1",
        ssl_options: {
          cert_store: cert_store,
          verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        },
        auth_options: {
          bearer_token: Base64.decode64(client_token),
        },
      )
    end

    describe "cron-jobs" do
      let(:all_jobs) { batch_client.get_jobs }

      describe "forseti-orchestrator" do
        let(:jobs) do
          all_jobs.select { |n| n.metadata.labels.component == "forseti-orchestrator" }
        end

        it "has the expected size" do
            expect(jobs.size).to eq 3
        end
      end
    end

    describe "pods" do
      let(:all_pods) { client.get_pods }

      describe "forseti-database" do
        let(:pod) do
          all_pods.select { |n| n.metadata.labels.component == "forseti-database" }.first
        end

        it "has the expected status" do
            expect(pod.status.phase).to eq 'Running'
        end
      end

      describe "forseti-security" do
        let(:pod) do
          all_pods.select { |n| n.metadata.labels.component == "forseti-server" }.first
        end

        it "has the expected status" do
            expect(pod.status.phase).to eq 'Running'
        end
      end

      describe "tiller-deploy" do
        let(:pod) do
          all_pods.select { |n| n.metadata.labels.name == "tiller" }.first
        end

        it "has the expected status" do
            expect(pod.status.phase).to eq 'Running'
        end
      end
    end
  end
end
