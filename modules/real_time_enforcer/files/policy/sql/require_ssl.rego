package gcp.sqladmin.instances.policy.require_ssl

#####
# Policy evaluation
#####

default valid=false

# Check if non-ssl connections are allowed
valid = true {
  input.settings.ipConfiguration.requireSsl == true
}

# Check for a global exclusion based on resource labels
valid = true {
  data.exclusions.label_exclude(input.settings.userLabels)
}

#####
# Remediation
#####

remediate[key] = value {
 key != "settings"
 input[key]=value
}

remediate[key] = value {
 key := "settings"
 value := _settings
}

_settings[key]=value{
  key != "ipConfiguration"
  input.settings[key]=value
}

_settings[key]=value{
  key := "ipConfiguration"
  value := _ipConfiguration
}

_ipConfiguration[key]=value{
  key != "requireSsl"
  input.settings.ipConfiguration[key]=value
}

_ipConfiguration[key]=value{
  key := "requireSsl"
  value := true
}

