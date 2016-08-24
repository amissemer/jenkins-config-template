#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
docker-compose build
docker-compose down
docker-compose -f docker-compose.yml -f docker-compose.upgrade.yml run jenkins
docker-compose up -d
popd
