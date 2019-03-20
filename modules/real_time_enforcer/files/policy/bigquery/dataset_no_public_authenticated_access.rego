package gcp.bigquery.datasets.policy.no_public_authenticated_access

#####
# Policy evaluation
#####

default valid = true

valid = false {
  # Check for bad acl
  input.access[_].specialGroup == "allAuthenticatedUsers"

  # Also, this must be false
  not data.exclusions.label_exclude(input.labels)
}

#####
# Remediation
#####

# Copy of the input, omitting the acls
remediate[key] = value {
 key != "access"
 input[key]=value
}

# Add the acls, as defined below
remediate[key] = value {
  key := "access"
  value := _access
}

# Return only valid acls using the function below
_access= [acl | acl := input.access[_]
  _valid_acl(acl)
]

_valid_acl(acl) = true {
  # If the specialGroup is anything other than "allAuthenticatedUsers"
  acl.specialGroup != "allAuthenticatedUsers"
}{
  # Or if there is no specialGroup key
  not acl["specialGroup"]
}
