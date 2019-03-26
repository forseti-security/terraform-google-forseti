package gcp.sqladmin.instances.policy.acl

test_good_acls {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "203.0.113.0/29",
              }
           ]
        },
        "userLabels": {
        }
     }
  }
}

test_good_acls_with_override {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "203.0.113.0/29",
              }
           ]
        },
        "userLabels": {
           "forseti-enforcer": "disable"
        }
     }
  }
}

test_good_acls_missing_labels {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "203.0.113.0/29",
              }
           ]
        }
     }
  }
}

test_bad_acl {
  not valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "0.0.0.0/0",
              }
           ]
        },
        "userLabels": {
        }
     }
  }
}

test_bad_acl_with_override {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "0.0.0.0/0",
              }
           ]
        },
        "userLabels": {
           "forseti-enforcer": "disable"
        }
     }
  }
}

test_bad_acl_missing_labels {
  not valid with input as {
     "settings": {
        "ipConfiguration": {
           "authorizedNetworks": [
              {
                 "value": "0.0.0.0/0",
              }
           ]
        }
     }
  }
}
