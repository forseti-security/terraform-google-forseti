package gcp.storage.buckets.policy.versioning

#####
# Resource metadata
#####

labels = input.labels

#####
# Policy evaluation
#####

default valid = false

# Check if versioning is enabled
valid = true {
  input.versioning.enabled = true
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Make a copy of the input, omitting the versioning field
remediate[key] = value {
 key != "versioning"
 input[key]=value
}

# Set the versioning field such that the bucket adheres to the policy
remediate[key] = value {
  key:="versioning"
  value:={"enabled":true}
}