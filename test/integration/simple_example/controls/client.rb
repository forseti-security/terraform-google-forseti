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

forseti_server_vm_ip = attribute("forseti-server-vm-ip")
forseti_version = "2.16.0"

control "client" do
  title "Forseti client instance resources"
  describe command("forseti") do
    it { should exist }
  end

  describe command("forseti config show") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match(/#{forseti_server_vm_ip}:50051/) }
  end

  describe command("forseti inventory list") do
    its("exit_status") { should eq 0 }
  end

  describe command("pip show forseti-security|grep Version") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match("Version: #{forseti_version}") }
  end

  describe file("/home/ubuntu/forseti-security/configs/forseti_conf_client.yaml") do
    it { should exist }

    it "sets the hostname to the Forseti server IP" do
      expect(YAML.load(subject.content)).to eq("server_ip" => forseti_server_vm_ip)
    end
  end
end
