#!/bin/bash

# Install Docker
echo -e "----Install Docker----"
sudo apt-get update
sudo apt upgrade -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates containerd.io -y
