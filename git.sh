#!/usr/bin/env bash

set -ue

USER=nruss
GIT_DIST_DIR=./
PROJECT_NAME=myproject
ROOT=/srv
GIT_LOCATION=/var/deployment
PROJECT_LOCATION=${ROOT}/${PROJECT_NAME}
GIT_PROJECT_LOCATION=${GIT_LOCATION}/${PROJECT_NAME}

mkdir ${PROJECT_LOCATION} -p
mkdir ${PROJECT_LOCATION}/www
chown -R ${USER} ${PROJECT_LOCATION}

mkdir ${GIT_PROJECT_LOCATION} -p
chown -R ${USER} ${GIT_PROJECT_LOCATION}
cd ${GIT_PROJECT_LOCATION}
git init --bare

touch ${GIT_PROJECT_LOCATION}/hooks/post-receive
cat > ${GIT_PROJECT_LOCATION}/hooks/post-receive << EOF
#!/bin/bash
git --work-tree=${PROJECT_LOCATION}/www --git-dir=${GIT_PROJECT_LOCATION} checkout -f -- ${GIT_DIST_DIR}
echo "Deployment complete"
EOF
chmod +x ${GIT_PROJECT_LOCATION}/hooks/post-receive
