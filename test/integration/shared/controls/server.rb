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

require "yaml"

forseti_version = "2.25.1"
suffix = attribute("suffix")

control "server" do
  title "Forseti server instance resources"
  describe command("forseti") do
    it { should exist }
  end

  describe command("forseti server configuration get") do
    its("exit_status") { should eq 0 }
  end

  describe command("forseti inventory list") do
    its("exit_status") { should eq 0 }
  end

  describe command("forseti_server") do
    it { should exist }
  end

  describe command("forseti_enforcer") do
    it { should exist }
  end

  describe command("python3 -m pip show forseti-security|grep Version") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match("Version: #{forseti_version}") }
    its("stderr") { should cmp "" }
  end

  describe file("/home/ubuntu/forseti-scripts/initialize_forseti_services.sh") do
    it { should exist }
  end



  describe command("sudo gcloud sql instances describe forseti-server-db-#{suffix}") do
    its("exit_status") { should eq 0 }
    its("stdout") { should match("- name: net_write_timeout\n    value: '240'") }
  end


  describe command("cat /etc/cron.allow") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "root" }
    its(:stdout) { should match "ubuntu" }
  end

  describe command("cat /etc/default/grub.d/50-cloudimg-settings.cfg | grep GRUB_CMDLINE_LINUX=") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    its(:stdout) { should match "GRUB_CMDLINE_LINUX=\"scsi_mod.use_blk_mq=Y apparmor=1 security=apparmor\"" }
  end

  describe command("grep '^\\s*linux' /boot/grub/grub.cfg | grep -v apparmor=1") do
    its(:exit_status) { should eq 1 }
    its(:stderr) { should eq "" }
    its(:stdout) { should eq "" }
    end
end
