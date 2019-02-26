# Forseti Infrastructure Tests
There are two suites of tests: `simple_example` and `shared_vpc`. `simple_example` tests deploy forseti module into a
single project while `shared_vpc` tests deploy forseti module into a project that has a shared VPC with another
host-project

# shared_vpc integration tests
`shared_vpc` integration tests requires that you already have host project and service project setup with shared-vpc and
at least one shared subnetwork.

## Configuring integration tests
Create a Terraform variables file based on the provided example:

```
cp test/fixtures/shared/terraform.tfvars.example test/fixtures/shared_vpc/terraform.tfvars
```

Update `terraform.tfvars` to match your environment:

```
credentials_path = "/path/to/credentials.json"
network_project = "sample-project-001"
project_id = "service-project-001"
org_id = 100000000000
domain = "company.domain.com"
network = "shared-vpc"
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
bundle exec kitchen setup simple-example

# Invoke the building of the cloud assets defined in the terraform code
bundle exec kitchen converge simple-example

# Execute the integration test suite
bundle exec kitchen verify simple-example

# Tear down the working environment
bundle exec kitchen destroy simple-example
```

If you want to run the full lifecycle suite at once

```bash
bundle exec kitchen test simple-example
```
