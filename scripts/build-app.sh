#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NONE='\033[0m'

DOCKER_USERNAME="quyvuacn"
DOCKER_REPO="jenkin_be"
DOCKER_TAG="latest"
DOCKERFILE="Dockerfile"

echo "Logging in to Docker Hub..."

docker login --username "$DOCKER_USERNAME"

echo -e "[${GREEN}START${NONE}] Building....."

docker build -f "$DOCKERFILE" -t "${DOCKER_USERNAME}/${DOCKER_REPO}" .

docker push "${DOCKER_USERNAME}/${DOCKER_REPO}"

echo -e "[${GREEN}DONE${NONE}] ${MODE} build and push successfully!"