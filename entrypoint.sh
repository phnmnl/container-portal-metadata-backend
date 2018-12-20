#!/usr/bin/env bash

# Set web server port
web_server_port=${1:-8080}

# Set providers directory
export PROVIDERS_DIR="${PROVIDERS_DIR:-/portal-metadata-backend/providers}"

# Set version of provider repository
PROVIDERS_REPO_VERSION="${PROVIDERS_REPO_VERSION:-master}"

# Remove existing provider repository
echo "Removing ${PROVIDERS_DIR} if it exists" >&2
rm -rf "${PROVIDERS_DIR}"

# Clone provider repository
if [[ -n "${PROVIDERS_REPO}" ]]; then
    echo "Cloning providers repository ${PROVIDERS_REPO} (version: '${PROVIDERS_REPO_VERSION}')" >&2
    GIT_SSH=/usr/local/bin/ssh_for_git git clone --depth 1 --single-branch --branch ${PROVIDERS_REPO_VERSION} "${PROVIDERS_REPO}" "${PROVIDERS_DIR}"
    if [[ $? != 0 ]]; then
        echo "Providers Repository: ${PROVIDERS_REPO}" >&2
        echo "Providers Repository Key: ${PROVIDERS_REPO_KEY}" >&2
        echo "Providers Repository Version: ${PROVIDERS_REPO_VERSION}" >&2
        echo "Failed to clone providers repository.  Check the previous log entries for clues." >&2
        # Unset Providers Directory to start the container without partners
        echo -e "\nStarting container without partner providers" >&2
        PROVIDERS_DIR=""
    fi
fi

# Update configuration files and initialise DB
"${SERVICE_PATH}/setup.sh"

# Start the web server
"${SERVICE_PATH}/start.sh" ${web_server_port}
