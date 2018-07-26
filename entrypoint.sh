#!/usr/bin/env bash

# set web server port
web_server_port=${1:-8080}

export PROVIDERS_REPO="${PROVIDERS_REPO:-git@bitbucket.org:crs4/partner-providers.git}"
export PROVIDERS_REPO_KEY="${PROVIDERS_REPO_KEY:-/portal-metadata-backend/keys/provider_repo_key}"
export PROVIDERS_DIR="${PROVIDERS_DIR:-/portal-metadata-backend/providers}"

## Clone provider repository
echo "Cloning providers repository ${PROVIDERS_REPO}" >&2
GIT_SSH=/usr/local/bin/ssh_for_git git clone --depth 1 --single-branch --branch master "${PROVIDERS_REPO}" "${PROVIDERS_DIR}"
if [[ $? != 0 ]]; then
  echo "Failed to clone providers repository.  Check the previous log entries for clues." >&2
  echo "Starting container without partner providers" >&2
  PROVIDERS_DIR=""
fi

# update configuration files and initialise DB
"${SERVICE_PATH}/setup.sh"

# start the web server
"${SERVICE_PATH}/start.sh" ${web_server_port}
