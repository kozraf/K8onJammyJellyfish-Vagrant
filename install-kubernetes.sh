#!/bin/bash

# Disable swap
echo -e "--------"
echo -e "----Disable swap----"
#sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

# Install container.d
echo -e "--------"
echo -e "Install container.d"
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Install Kubernetes components
echo -e "--------"
echo -e "----Install Kubernetes components----"
sudo apt update
sudo apt install curl apt-transport-https  -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" -y

sudo apt update
sudo apt install kubeadm kubelet kubectl kubernetes-cni -y

sudo apt-mark hold kubelet kubeadm kubectl


