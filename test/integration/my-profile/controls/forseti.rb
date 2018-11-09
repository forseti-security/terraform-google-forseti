# encoding: utf-8
# copyright: 2018, The Authors

title 'Sample Section'

gcp_project_id = attribute('gcp_project_id')
#gcp_org_id = attribute('gcp_org_id')

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
  title 'Test Server Project IAM Role bindings'
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

# @TODO Need to figure out the Org level permissions to execute this test
#
# control 'forseti-server-read-iam-roles' do
#   gcp_enable_privileged_resources = '1'
#
#   impact 1.0
#   title 'Test Server Read Org Level IAM Role bindings'
#   describe google_project_iam_binding(project: , role: "roles/compute.securityAdmin") do
#     it { should exist }
#     its ('members'){ should include /forseti/ }
#   end
# end

control 'forseti-google-storage-buckets' do
  impact 1.0
  title 'Test GCS Buckets are present'
  describe google_storage_buckets(project: gcp_project_id) do
    its('bucket_names') { should include /forseti-server/ }
  end
  describe google_storage_buckets(project: gcp_project_id) do
    its('bucket_names') { should include /forseti-client/ }
  end
  # @TODO can't get the bucket to accept regex matching, below works but doesn't account for random_id
  # describe google_storage_bucket_objects(bucket: 'forseti-server-52d2853a') do
  #   its('object_names'){ should include 'configs/forseti_conf_server.yaml' }
  # end
end

control 'forseti-client-service-account' do
  impact 1.0
  title 'Test Forseti Client Service Account'
  describe google_service_accounts(project: gcp_project_id) do
    its('service_account_emails'){ should include /forseti-client-gcp/ }
  end
end

control 'forseti-server-service-account' do
  impact 1.0
  title 'Test Forseti Server Service Account'
  describe google_service_accounts(project: gcp_project_id) do
    its('service_account_emails'){ should include /forseti-server-gcp/ }
  end
end