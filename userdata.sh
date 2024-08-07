#!/bin/bash

sudo apt update
sudo apt install -y docker.io git golang-go kcat

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu

cd /home/ubuntu
mkdir kafka-setup-test
cd kafka-setup-test

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo snap install kafkactl
sudo snap install aws-cli --classic

sudo aws s3 cp s3://epm-prv-kafka-setup/ . --recursive

sudo chown -R ubuntu:ubuntu ../kafka-setup-test

#git clone https://github.com/gongled/kafka-workshop.git
#cd kafka-workshop
#cp .env.example .env

docker-compose --profile app pull
docker-compose --profile app build

