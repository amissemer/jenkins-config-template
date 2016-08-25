#!/bin/bash
# Restart Jenkins from scratch (from the image). WARNING: This will erase all build data and all non committed configuration.
# This is for testing purpose only
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
docker-compose build --pull
docker-compose up -d
popd
