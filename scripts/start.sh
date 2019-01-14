#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cd ../docker_env

network=${1:-local}

echo "Running with ${network} network"
export ENV_FILE=.env.${network}

echo "Making sure that initial state is pristine:"
docker-compose -f ./docker-compose-local.yml down -v || true

docker-compose -f ./docker-compose-local.yml up