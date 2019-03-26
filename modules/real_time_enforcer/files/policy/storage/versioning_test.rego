package gcp.storage.buckets.policy.versioning

test_versioning_enabled {
  valid with input as {"versioning": {"enabled": true}, "labels": {}}
}

test_versioning_enabled_and_override {
  valid with input as {"versioning": {"enabled": true}, "labels": {"forseti-enforcer":"disable"}}
}

test_versioning_disabled {
  not valid with input as {"versioning": {"enabled": false}, "labels": {}}
}

test_versioning_disabled_but_overridden {
  valid with input as {"versioning": {"enabled": false}, "labels": {"forseti-enforcer":"disable"}}
}
