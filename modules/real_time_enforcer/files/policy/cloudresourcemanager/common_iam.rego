package gcp.cloudresourcemanager.projects.iam

policies [policy_name] {
    policy := data.gcp.cloudresourcemanager.projects.iam.policy[policy_name]
}

violations [policy_name] {
    policy := data.gcp.cloudresourcemanager.projects.iam.policy[policy_name]
    policy.valid != true
}
