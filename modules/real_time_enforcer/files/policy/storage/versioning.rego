package gcp.storage.buckets.policy.versioning

default valid = false

# Check if versioning is enabled
valid = true {
  input.versioning.enabled = true
}

# Even if versioning is disabled, allow override via bucket label
valid = true {
  input.labels["policy-override-versioning"] = true
}

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

overrides = o {
  split(input.labels["cleardata-override"], ",", o)
}
