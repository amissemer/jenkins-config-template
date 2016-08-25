#!/bin/bash 

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $THIS_DIR
docker-compose exec jenkins sh -c "echo 'Initial Admin Password:' ; cat /var/jenkins_home/secrets/initialAdminPassword ; echo 'SSH Key to add to your git repository keys: ' ; cat ~/.ssh/id_rsa.pub"
popd
