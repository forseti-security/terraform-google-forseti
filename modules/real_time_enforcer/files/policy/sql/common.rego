package gcp.sqladmin.instances

policies [policy_name] {
    policy := data.gcp.sqladmin.instances.policy[policy_name]
}

violations [policy_name] {
    policy := data.gcp.sqladmin.instances.policy[policy_name]
    policy.valid != true
}
