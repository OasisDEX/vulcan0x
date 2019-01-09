#!/usr/bin/env bash
set -ex
cd "$(dirname "$0")"

cd ../docker_env

export ENV_FILE=.env.local
docker-compose -f ./docker-compose.yml up
