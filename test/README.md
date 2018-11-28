# Forseti Infrastructure Tests

## Working with the testing framework

Technology being leveraged in this testing solution:

- kitchen-terraform
- kitchen-inspec
- inspec 3.x +
- terraform
- test-kitchen


## Update `attributes.yml.example` to point to your project for manual execution

Rename the `attributes.yml.example` to `attributes.yml`

```
gcp_project_id: 'my-gcp-project'
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

