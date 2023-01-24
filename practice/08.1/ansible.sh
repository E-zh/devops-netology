#!/usr/local/env bash

docker run -dit --name centos7 pycontribs/centos:7 sleep 6000000
docker run -dit --name ubuntu pycontribs/ubuntu:latest sleep 6000000
docker run -dit --name fedora pycontribs/fedora:latest sleep 6000000

ansible-playbook -i inventory/prod.yml site.yml --vault-password-file password.txt

sleep 30

echo "Stop and removing containers..."

docker stop centos7 && docker rm centos7
docker stop ubuntu && docker rm ubuntu
docker stop fedora && docker rm fedora
