#!/usr/bin/env bash

# set web server port
web_server_port=${1:-8080}

export PROVIDERS_REPO="${PROVIDERS_REPO:-git@bitbucket.org:crs4/partner-providers.git}"
export PROVIDERS_REPO_KEY="${PROVIDERS_REPO_KEY:-/portal-metadata-backend/keys/provider_repo_key}"
export PROVIDERS_DIR="${PROVIDERS_DIR:-/portal-metadata-backend/providers}"

## Set version of provider repository
if [[ -n "${PROVIDERS_VERSION}" ]]; then
    PROVIDERS_VERSION="master"
fi

## Clone provider repository
echo "Removing ${PROVIDERS_DIR} if it exists" >&2
rm -rf "${PROVIDERS_DIR}"
echo "Cloning providers repository ${PROVIDERS_REPO} (version: '${PROVIDERS_VERSION}'" >&2
GIT_SSH=/usr/local/bin/ssh_for_git git clone --depth 1 --single-branch --branch ${PROVIDERS_VERSION} "${PROVIDERS_REPO}" "${PROVIDERS_DIR}"
if [[ $? != 0 ]]; then
  echo "Failed to clone providers repository.  Check the previous log entries for clues." >&2
  echo "Starting container without partner providers" >&2
  PROVIDERS_DIR=""
fi

# update configuration files and initialise DB
"${SERVICE_PATH}/setup.sh"

# start the web server
"${SERVICE_PATH}/start.sh" ${web_server_port}
