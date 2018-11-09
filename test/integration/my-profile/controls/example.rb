# encoding: utf-8
# copyright: 2018, The Authors

title 'Sample Section'

gcp_project_id = attribute('gcp_project_id')

# you add controls here
control 'gcp-single-region-1.0' do                                                    # A unique ID for this control
  impact 1.0                                                                          # The criticality, if this control fails.
  title 'Ensure single region has the correct properties.'                            # A human-readable title
  desc 'An optional description...'
  describe google_compute_region(project: gcp_project_id, name: 'europe-west2') do    # The actual test
    its('zone_names') { should include 'europe-west2-a' }
  end
end

# plural resources can be leveraged to loop across many resources
control 'gcp-regions-loop-1.0' do                                                     # A unique ID for this control
  impact 1.0                                                                          # The criticality, if this control fails.
  title 'Ensure regions have the correct properties in bulk.'                         # A human-readable title
  desc 'An optional description...'
  google_compute_regions(project: gcp_project_id).region_names.each do |region_name|  # Loop across all regions by name
    describe google_compute_region(project: gcp_project_id, name: region_name) do     # The test for a single region
      it { should be_up }
    end
  end
end

control 'forseti-client-vm' do
  impact 1.0
  title 'Test forseti client vm'
  describe google_compute_instances(project: gcp_project_id,  zone: 'us-central1-c') do
    its('instance_names') { should include /forseti-client-vm-*/ }
  end
end

control 'forseti-server-vm' do
  impact 1.0
  title 'Test foseti server vm'
  describe google_compute_instances(project: gcp_project_id,  zone: 'us-central1-c') do
    its('instance_names') { should include /forseti-server-vm-*/ }
  end
end

control 'forseti-cloudsql-instance' do
  impact 1.0
  title 'Test CloudSQL Instance is up'
  describe google_sql_database_instances(project: gcp_project_id) do
    its('instance_names') { should include /forseti-server-db-*/ }
  end
end


control 'forseti-server-iam-roles' do
  gcp_enable_privileged_resources = '1'

  impact 1.0
  title 'Test Server IAM Role bindings'
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/storage.objectViewer") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/storage.objectCreator") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/cloudsql.client") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/cloudtrace.agent") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/logging.logWriter") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
  describe google_project_iam_binding(project: gcp_project_id, role: "roles/iam.serviceAccountTokenCreator") do
    it { should exist }
    its ('members'){ should include /forseti/ }
  end
end