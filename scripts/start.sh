#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"

cd ../docker_env

network=$1

if [ -z "$network" ]; then
    echo "Provide NETWORK argument"
    exit 1
fi

echo "Running with ${network} network"
export ENV_FILE=.env.${network}

if [ "$network" != "mainnet" ]; then 
  echo "Making sure that initial state is pristine:"
  docker-compose -f ./docker-compose-local.yml down -v || true
else
  echo "Mainnet detected. Skipping volume purge."
  docker-compose -f ./docker-compose-local.yml down || true
fi

docker-compose -f ./docker-compose-local.yml up