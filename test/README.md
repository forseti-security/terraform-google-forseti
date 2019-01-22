# Forseti Infrastructure Tests

## Configuring integration tests

Create a Terraform variables file based on the provided example:

```
cp test/fixtures/simple_example/terraform.tfvars.example test/fixtures/tf_module/terraform.tfvars
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

```
# Initialize the terraform providers and context
bundle exec kitchen setup

# Invoke the building of the cloud assets defined in the terraform code
bundle exec kitchen converge

# Execute the integration test suite
bundle exec kitchen verify

# Tear down the working environment
bundle exec kitchen destroy
```

If you want to run the full lifecycle suite at once

```
bundle exec kitchen test
```
