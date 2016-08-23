#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
docker-compose build
docker-compose down
docker-compose run jenkins upgrade
docker-compose up -d
popd
