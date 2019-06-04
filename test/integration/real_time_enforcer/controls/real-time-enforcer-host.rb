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

control 'real-time-enforcer-host' do
  title "Real time enforcer host resources"

  describe command("systemctl is-active opa-policy") do
    its("exit_status") { should be(0).or be(3) }
    its("stdout.chomp") { should cmp("active").or cmp("activating").or cmp("inactive") }
    its("stderr") { should eq "" }
  end

  describe command("systemctl is-active opa-server") do
    its("exit_status") { should be(0).or be(3) }
    its("stdout.chomp") { should cmp("active").or cmp("activating").or cmp("inactive") }
    its("stderr") { should eq "" }
  end

  describe command("systemctl is-active enforcer") do
    its("exit_status") { should be(0).or be(3) }
    its("stdout.chomp") { should cmp("active").or cmp("activating").or cmp("inactive") }
    its("stderr") { should eq "" }
  end

  describe command('systemctl is-enabled enforcer') do
    its('exit_status') { should be_zero }
    its('stdout.chomp') { should eq 'enabled' }
    its('stderr') { should eq '' }
  end
end
