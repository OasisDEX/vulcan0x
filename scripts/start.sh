#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cd ../docker_env

export ENV_FILE=.env.local

echo "Making sure that initial state is pristine:"
docker-compose -f ./docker-compose-local.yml down -v || true

docker-compose -f ./docker-compose-local.yml up