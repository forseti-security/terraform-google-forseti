package gcp.bigquery.datasets

policies [policy_name] {
    policy := data.gcp.bigquery.datasets.policy[policy_name]
}

violations [policy_name] {
    policy := data.gcp.bigquery.datasets.policy[policy_name]
    policy.valid != true
}
