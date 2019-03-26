package gcp.sqladmin.instances.policy.backups

#####
# Resource metadata
#####

labels = input.settings.userLabels

#####
# Policy evaluation
#####

default valid=false

# Check if backups are enabled
valid = true {
  input.settings.backupConfiguration.enabled == true
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(labels)
}

#####
# Remediation
#####

# Copy the input object, omitting the settings key
remediate[key] = value {
 key != "settings"
 input[key]=value
}

# Add the settings key, as defined below
remediate[key] = value {
 key := "settings"
 value := _settings
}

# Copy the settings key, minus the backupConfiguration key
_settings[key]=value{
  key != "backupConfiguration"
  input.settings[key]=value
}

# Add the backupConfiguration key, as defined below
_settings[key]=value{
  key := "backupConfiguration"
  value := _backupConfiguration
}

# Copy the backupConfiguration, minus the enabled key
_backupConfiguration[key] = value {
  key != "enabled"
  input.settings.backupConfiguration[key] = value
}

# Add the enabled key
_backupConfiguration[key] = value {
  key := "enabled"
  value := true
}