package gcp.storage.buckets

policies [policy_name] {
    data.gcp.storage.buckets.policy[policy_name]
}

violations [policy_name] {
    policy := data.gcp.storage.buckets.policy[policy_name]
    policy.valid = false
}
