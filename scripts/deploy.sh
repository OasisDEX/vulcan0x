#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

echo "Pushing as oasisdexorg/vulcan0x"

echo "$DOCKER_PASS" | docker login --username "$DOCKER_USER" --password-stdin
docker push oasisdexorg/vulcan0x
