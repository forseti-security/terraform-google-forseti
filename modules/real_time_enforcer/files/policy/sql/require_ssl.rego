package gcp.sqladmin.instances.policy.require_ssl

default valid=false

valid = true {
  input.settings.ipConfiguration.requireSsl == true
}

valid = true {
  input.settings.userLabels["policy-override-ssl"] == true
}

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
