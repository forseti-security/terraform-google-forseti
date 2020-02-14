project_id = "forseti-gke-mango"
org_id     = "92932930834"
domain     = "orange.forsetisecurity.dev"
region     = "us-west1"

network_description     = "GKE Network"
auto_create_subnetworks = false
gke_node_ip_range       = "10.1.0.0/20"
# helm_repository_url     = "local"

k8s_forseti_orchestrator_image_tag = "master"
k8s_forseti_server_image_tag       = "master"

gsuite_admin_email            = "admin@orange.forsetisecurity.dev"
config_validator_enabled      = true
git_sync_private_ssh_key_file = "/usr/local/google/home/gkowalski/git_repos/gkowalski-github-ssh"
policy_library_repository_url = "git@github.com:gkowalski-google/policy-library-private"

