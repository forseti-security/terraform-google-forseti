package gcp.sqladmin.instances.policy.require_ssl

test_enabled {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": true
        },
        "userLabels": {
        }
     }
  }
}

test_enabled_with_override {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": true
        },
        "userLabels": {
           "forseti-enforcer": "disable"
        }
     }
  }
}

test_enabled_missing_labels {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": true
        }
     }
  }
}

test_disabled {
  not valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": false
        },
        "userLabels": {
        }
     }
  }
}

test_disabled_with_override {
  valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": false
        },
        "userLabels": {
           "forseti-enforcer": "disable"
        }
     }
  }
}

test_disabled_missing_labels {
  not valid with input as {
     "settings": {
        "ipConfiguration": {
           "requireSsl": false
        }
     }
  }
}
