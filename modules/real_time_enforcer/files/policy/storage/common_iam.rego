package gcp.storage.buckets.iam

policies [policy_name] {
    data.gcp.storage.buckets.iam.policy[policy_name]
}

violations [policy_name] {
    policy := data.gcp.storage.buckets.iam.policy[policy_name]
    policy.valid = false
}
