package gcp.storage.buckets.iam.policy.disallow_allauthenticatedusers

test_valid_policies {
  valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "your_user@your_org.tld"
         ]
      }
    ],
   "_resource": {
      "labels": {
      }
    }
  }
}

test_valid_policies_with_override {
  valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "your_user@your_org.tld"
         ]
      }
   ],
   "_resource": {
      "labels": {
         "forseti-enforcer": "disable"
      }
    }
  }
}

test_valid_policies_missing_labels {
  valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "your_user@your_org.tld"
         ]
      }
   ]
  }
}

test_invalid_policies {
  not valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "allAuthenticatedUsers"
         ]
      }
    ],
   "_resource": {
      "labels": {
      }
    }
  }
}

test_invalid_policies_with_override {
  valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "your_user@your_org.tld",
            "allAuthenticatedUsers"
         ]
      }
   ],
   "_resource": {
      "labels": {
         "forseti-enforcer": "disable"
      }
    }
  }
}

test_invalid_policies_missing_labels {
  not valid with input as {
   "bindings": [
      {
         "role": "roles/storage.legacyBucketReader",
         "members": [
            "your_user@your_org.tld",
            "allAuthenticatedUsers"
         ]
      }
   ]
  }
}
