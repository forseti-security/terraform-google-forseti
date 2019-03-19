package gcp.storage.buckets.iam.policy.disallow_allauthenticatedusers

default valid = true

# Check if there is a binding for *allAuthenticatedUsers*
valid = false {
  input.bindings[_].members[_] == "allAuthenticatedUsers"
}

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

# Basically pass all bindings through the
_bindings = [_fix_binding(binding) | binding := input.bindings[_]]

# The fixed bindings are just the expected fields with members filtered
_fix_binding(b) = {"members": _remove_bad_members(b.members), "role": b.role}

# Given a list of members, remove the bad one
_remove_bad_members(members) = m {
  m = [member | member := members[_]
    member != "allAuthenticatedUsers"
  ]
}
