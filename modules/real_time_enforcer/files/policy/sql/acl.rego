package gcp.sqladmin.instances.policy.acl

#####
# Policy evaluation
#####

default valid=true

valid = false {
  # Check for bad acl
  input.settings.ipConfiguration.authorizedNetworks[_].value == "0.0.0.0/0"

  # Also, this must be false
  not data.exclusions.label_exclude(input.settings.userLabels)
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
  key != "authorizedNetworks"
  input.settings.ipConfiguration[key]=value
}

_ipConfiguration[key]=value{
  key := "authorizedNetworks"
  value := valid_authorized_networks
}

valid_authorized_networks = [net | net := input.settings.ipConfiguration.authorizedNetworks[_]
  net.value != "0.0.0.0/0"
]
