
control "instance" do
  describe google_compute_instance(project: 'rltech-173716', name: 'forseti-client-vm') do
    it { should exist }
    its('name') { should match 'forseti-client-vm' }
  end
end

