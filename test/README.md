# Forseti Infrastructure Tests
There are two suites of tests: `simple_example` and `shared_vpc`. `simple_example` tests deploy forseti module into a
single project while `shared_vpc` tests deploy forseti module into a project that has a shared VPC with another
host-project

# shared_vpc integration tests
`shared_vpc` integration tests requires that you already have host project and service project setup with shared-vpc and
at least one shared subnetwork. Service account that you use to create the environment defined in 
`test/fixtures/shared_vpc` must have the following roles:
* Organization Administrator (roles/resourcemanager.organizationAdmin)
* Compute Shared VPC Admin (roles/compute.xpnAdmin)
* Project Creator (roles/resourcemanager.projectCreator)

## Configuring integration tests
Create a Terraform variables file based on the provided example:

```
cp test/fixtures/shared/terraform.tfvars.example test/fixtures/shared_vpc/terraform.tfvars
```

Update `terraform.tfvars` to match your environment:

```
credentials_path = "/path/to/credentials.json"
shared_project_id = "sample-project-001"
service_project_id = "service-project-001"
org_id = 100000000000
billing_account = "000000-000000-000000"
domain = "company.domain.com"
network_name = "shared-vpc"
subnetwork = "subnet-001"
```

## Running Integration Tests

From the root of the module directory execute the following commands:

```
# Initialize the terraform providers and context
bundle exec kitchen setup shared-vpc

# Invoke the building of the cloud assets defined in the terraform code
bundle exec kitchen converge shared-vpc

# Execute the integration test suite
bundle exec kitchen verify shared-vpc

# Tear down the working environment.
bundle exec kitchen destroy shared-vpc
```

If you want to run the full lifecycle suite at once

```
bundle exec kitchen test
```

## Caveat
At the moment `bundle exec kitchen destroy shared-vpc` will fail to destroy all the resources on the first run. You will
have to run this command at least 2 times. At the end the whole environment will be destroyed but some terraform states
will fails to be destroyed.

# simple_example integration tests

## Configuring integration tests

Create a Terraform variables file based on the provided example:

```bash
cp test/fixtures/simple_example/terraform.tfvars.example test/fixtures/simple_example/terraform.tfvars
```

Update `terraform.tfvars` to match your environment:

```bash
credentials_path = "../../../credentials.json"`
gsuite_admin_email = "admin@example.com"
org_id = "000000000000"
project_id = "forseti-test-f6bd"
```

## Running Integration Tests

From the root of the module directory execute the following commands:

```bash
# Initialize the terraform providers and context
bundle exec kitchen setup tf-module

# Invoke the building of the cloud assets defined in the terraform code
bundle exec kitchen converge tf-module

# Execute the integration test suite
bundle exec kitchen verify tf-module

# Tear down the working environment
bundle exec kitchen destroy tf-module
```

If you want to run the full lifecycle suite at once

```bash
bundle exec kitchen test tf-module
```
