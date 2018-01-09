#!/usr/bin/env bash

# set web server port
web_server_port=${1:-8080}

# update configuration files and initialise DB
"${SERVICE_PATH}/setup.sh"

# start the web server
"${SERVICE_PATH}/start.sh" ${web_server_port}