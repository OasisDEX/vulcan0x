#!/usr/bin/env bash
set -ex
cd "$(dirname "$0")"

cd ../docker_env

export ENV_FILE=.env.dev
docker-compose -f ./docker-compose-dev.yml up -d

../docker_env/wait-for localhost:5432 -t 30

ENV=docker_env/.env.dev yarn migrate
ENV=docker_env/.env.dev yarn sync
