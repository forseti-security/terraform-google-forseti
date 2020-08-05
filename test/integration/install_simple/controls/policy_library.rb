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

control "policy-library" do
  # Assert Policy Library contains Constraints from Policy Bundle
  describe file('/home/ubuntu/policy-library/policy-library/policies/constraints') do
    it { should be_a_directory }
  end

  describe command("ls -l /home/ubuntu/policy-library/policy-library/policies/constraints/*.yaml | egrep -c '^-'") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^[1-9]/) }
  end
end
