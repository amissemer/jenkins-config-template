#!/bin/bash 
docker-compose exec jenkins sh -c "echo 'Initial Admin Password:' ; cat /var/jenkins_home/secrets/initialAdminPassword ; echo 'SSH Key to add to your git repository keys: ' ; cat ~/.ssh/id_rsa.pub"
