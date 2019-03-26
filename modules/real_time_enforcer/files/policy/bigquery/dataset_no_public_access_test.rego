package gcp.bigquery.datasets.policy.no_public_access

test_valid_policies {
  valid with input as {
     "labels": {
     },
     "access": [
        {
           "role": "READER",
           "specialGroup": "somethingLegitimate"
        }
     ],
  }
}

test_valid_policies_with_override {
  valid with input as {
     "labels": {
        "forseti-enforcer": "disable",
     },
     "access": [
        {
           "role": "READER",
           "specialGroup": "somethingLegitimate"
        }
     ],
  }
}

test_valid_policies_missing_labels {
  valid with input as {
     "access": [
        {
           "role": "READER",
           "specialGroup": "somethingLegitimate"
        }
     ],
  }
}

test_invalid_policies {
  not valid with input as {
     "labels": {
     },
     "access": [
        {
           "role": "READER",
           "iamMember": "allUsers"
        }
     ],
  }
}

test_invalid_policies_with_override {
  valid with input as {
     "labels": {
        "forseti-enforcer": "disable",
     },
     "access": [
        {
           "role": "READER",
           "iamMember": "allUsers"
        }
     ],
  }
}

test_invalid_policies_missing_labels {
  not valid with input as {
     "access": [
        {
           "role": "READER",
           "iamMember": "allUsers"
        }
     ],
  }
}
