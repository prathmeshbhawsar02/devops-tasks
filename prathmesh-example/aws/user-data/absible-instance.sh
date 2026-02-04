#!/bin/bash
sudo apt -y update 
sudo apt install -y git
sudo apt install -y ansible
cd /home/ubuntu/

git clone https://github.com/knaopel/docker-frontend-backend-db.git

git clone https://github.com/prathmeshbhawsar02/docker-todo.git
cd /home/ubuntu/docker-todo/
ansible-playbook -i inventory.ini playbook.yml

