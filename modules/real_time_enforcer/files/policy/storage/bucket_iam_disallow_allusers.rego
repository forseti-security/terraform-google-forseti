package gcp.storage.buckets.iam.policy.disallow_allusers

#####
# Resource metadata
#####

labels = input._resource.labels

#####
# Policy evaluation
#####

default valid = true

# Check if there is a binding for *allUsers*
valid = false {
  # Check for bad policy
  input.bindings[_].members[_] == "allUsers"

  # Just in case labels are not in the input
  not labels
} else = false {
  input.bindings[_].members[_] == "allUsers"

  # Also, make sure this resource isn't excluded by label
  not data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Make a copy of the input, omitting the bindings
remediate[key] = value {
 key != "bindings"
 input[key]=value
}

# Now rebuild the bindings
remediate[key] = value {
  key := "bindings"
  value := [binding | binding := _bindings[_]
    # Remove any binding that no longer have any members
    binding.members != []
  ]
}

# Pass all binding through the fix_binding function
_bindings = [_fix_binding(binding) | binding := input.bindings[_]]

# The fixed bindings are just the expected fields with members filtered
_fix_binding(b) = {"members": _remove_bad_members(b.members), "role": b.role}

# Given a list of members, remove the bad one(s)
_remove_bad_members(members) = m {
  m = [member | member := members[_]
    member != "allUsers"
  ]
}