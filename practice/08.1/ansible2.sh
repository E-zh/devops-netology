#!/usr/local/env bash

docker-compose up -d
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file password.txt
sleep 30
echo "Stop and removing containers..."
docker-compose down
