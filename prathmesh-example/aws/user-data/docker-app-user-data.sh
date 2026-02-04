#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo apt install -y docker-compose
sudo systemctl start docker
sudo systemctl enable docker
mkdir -p /home/ubuntu/pb
cd /home/ubuntu/pb

git clone https://github.com/knaopel/docker-frontend-backend-db.git
cd docker-frontend-backend-db/
docker-compose up -d
