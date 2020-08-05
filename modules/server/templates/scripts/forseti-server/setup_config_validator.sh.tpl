#!/bin/bash
set -eu

POLICY_LIBRARY_HOME="${policy_library_home}/policy-library"
POLICY_LIBRARY_SOURCE=""

# Create Policy Library home directory
sudo mkdir -m 777 -p "${policy_library_home}"

# Copy from GCS
if [ "${policy_library_sync_gcs_enabled}" == "true" ]; then
  echo "Forseti Startup - Copying Policy Library from GCS."
  POLICY_LIBRARY_SOURCE="GCS"

  sudo mkdir -m 777 -p "$POLICY_LIBRARY_HOME"
  gsutil -m rsync -d -r "gs://${storage_bucket_name}/policy-library" "$POLICY_LIBRARY_HOME" || echo "No policy available, continuing with Forseti installation"
fi

# Copy from Git
if [ "${policy_library_sync_enabled}" == "true" ] && [ -z $POLICY_LIBRARY_SOURCE ]; then
  echo "Forseti Startup - Copying Policy Library from git repository."
  POLICY_LIBRARY_SOURCE="Git"

  # Note: gsutil is using the -n flag so that once the SSH key is copied locally, it is not overwritten for any subsequent runs of terraform
  sudo mkdir -p /etc/git-secret
  sudo gsutil cp -n "gs://${storage_bucket_name}/${policy_library_sync_gcs_directory_name}/* /etc/git-secret/"
  systemctl start policy-library-sync
  sleep 10
fi

# Use Policy Bundle
if [ -n "${policy_library_bundle}" ] && [ -z $POLICY_LIBRARY_SOURCE ]; then
  echo "Forseti Startup - Using bundle ${policy_library_bundle} for the Policy Library."
  POLICY_LIBRARY_SOURCE="Bundle"

  # Install kpt via gcloud
  sudo apt-get update -y && sudo apt-get install --allow-downgrades -y google-cloud-sdk-kpt="${google_cloud_sdk_version}"

  # Get or update Policy Library repo
  if [[ ! -d "${policy_library_home}/policy-library" ]]; then
      kpt pkg get "${policy_library_repository_url}" "${policy_library_home}/policy-library"
      cd "${policy_library_home}/policy-library"
  else
      # Kpt pkg update requires relative path
      cd "${policy_library_home}/policy-library"
      kpt pkg update ./
  fi

  # Get the policy bundle
  kpt fn source ./samples/ |
    sudo kpt fn run --image gcr.io/config-validator/get-policy-bundle:latest -- bundle="${policy_library_bundle}" |
    kpt fn sink ./policies/constraints/

  # Customize policy bundle
  kpt cfg set ./policies/constraints/ target "${constraint_target}"
  if [ -n "${domain}" ]; then
    kpt cfg set ./policies/constraints/ domain "${domain}"
  fi

  # Commit local changes
  sudo chmod -R 777 ./
  if [[ ! -f ./.git ]]; then
    git init && git config user.name forseti
  fi
  git_user_name=$(git config --local user.name)
  if [ -z "$git_user_name" ]; then
    git config user.name forseti
  fi
  git add . && git commit -m "Policy bundle ${policy_library_bundle}"
fi

# Start the Config Validator service
systemctl start config-validator
sleep 5
