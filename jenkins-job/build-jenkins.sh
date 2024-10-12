#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NONE='\033[0m'

DOCKER_USERNAME="quyvuacn"
DOCKER_REPO="jenkins"
DOCKER_TAG="latest"
DOCKERFILE="setup-jenkins.Dockerfile"

echo "Logging in to Docker Hub..."

docker login --username "$DOCKER_USERNAME"

echo -e "[${GREEN}START${NONE}] Building....."

docker build -f "$DOCKERFILE" -t ${DOCKER_USERNAME}/${DOCKER_REPO}:${DOCKER_TAG} .

docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:${DOCKER_TAG}

echo -e "[${GREEN}DONE${NONE}] ${MODE} build and push successfully!"