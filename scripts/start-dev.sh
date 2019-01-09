#!/usr/bin/env bash
set -ex
cd "$(dirname "$0")"

export ENV_FILE=.env.local

cd ../docker_env

docker-compose -f ./docker-compose-dev.yml down || true

(../docker_env/wait-for localhost:5432 -t 30 && sleep 5 && ENV=docker_env/.env.dev yarn migrate)&

docker-compose -f ./docker-compose-dev.yml up
