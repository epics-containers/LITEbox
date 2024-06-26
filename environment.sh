#!/bin/bash

# a bash script to source in order to set up your command line to in order
# to work with the bl-ec-test IOCs and Services.

# check we are sourced
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "ERROR: Please source this script"
    exit 1
fi

echo "Loading environment for beamline bl-ec-test IOC Instances and Services ..."

#### SECTION 1. Environment variables ##########################################

# a mapping between generic IOC repo roots and the related container registry
# use spaces or line breaks to separate multiple mappings by default this
# inlcudes mappings for github and DLS gitlab, add your own here.
export EC_REGISTRY_MAPPING_REGEX='
.*github.com:(.*)\/(.*) ghcr.io/\1/\2
.*gitlab.diamond.ac.uk.*\/(.*) gcr.io/diamond-privreg/controls/prod/ioc/\1
'
# the namespace to use for kubernetes deployments - use local for local docker/podman
export EC_K8S_NAMESPACE=local
# the git repo for this project
export EC_SERVICES_REPO=https://github.com/diamondlightsource/LITEbox
# declare your centralised log server Web UI
export EC_LOG_URL="https://graylog.diamond.ac.uk/search?rangetype=relative&fields=message%2Csource&width=1489&highlightMessage=&relative=172800&q=pod_name%3A{service_name}*"
# enforce a specific container cli - defaults to whatever is available
# export EC_CONTAINER_CLI=podman
# enable debug output in all 'ec' commands
# export EC_DEBUG=1

# THESE are for the local docker/podman deployment only
export EC_LOCAL_DATA_FOLDER=/data
# export EC_LOCAL_USER_ID=$(id -u)
# export EC_LOCAL_GROUP_ID=$(id -g)
# currently using root as we have not solved 'runtime' volume permissions issue yet.
export EC_LOCAL_USER_ID=0
export EC_LOCAL_GROUP_ID=0
export EC_LOCAL_OPI_FOLDER=/data/opi


#### SECTION 2. Install ec #####################################################

# check if epics-containers-cli (ec command) is installed
if ! ec --version &> /dev/null; then
    echo "ERROR: Please set up a virtual environment and: 'pip install edge-containers-cli'"
    return 1
fi

# enable shell completion for ec commands
source <(ec --show-completion ${SHELL})


#### SECTION 3. Configure Kubernetes Cluster ###################################


# no cofiguration in this section for local docker/podman deployments


