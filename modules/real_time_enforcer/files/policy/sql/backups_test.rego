package gcp.sqladmin.instances.policy.backups

test_enabled {
  valid with input as {
     "settings": {
        "backupConfiguration": {
           "enabled": true
        },
        "userLabels": {
        }
     }
  }
}

test_enabled_with_override {
  valid with input as {
     "settings": {
        "backupConfiguration": {
           "enabled": true
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
        "backupConfiguration": {
           "enabled": true
        }
     }
  }
}

test_disabled {
  not valid with input as {
     "settings": {
        "backupConfiguration": {
           "enabled": false
        },
        "userLabels": {
        }
     }
  }
}

test_disabled_with_override {
  valid with input as {
     "settings": {
        "backupConfiguration": {
           "enabled": false
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
        "backupConfiguration": {
           "enabled": false
        }
     }
  }
}
