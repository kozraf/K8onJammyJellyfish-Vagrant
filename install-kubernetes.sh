#!/bin/bash

# Install Kubernetes components
sudo apt update

sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl
kubectl version --client && kubeadm version

# Disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -i '/swap/s/^/#/' /etc/fstab
sudo swapoff -a

# Enable kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Add some settings to sysctl
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload sysctl
sudo sysctl --system

#Installing CRI-O:
# Add Cri-o repo
#sudo su -
#OS="xUbuntu_20.04"
#VERSION=1.25
#echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
#echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
#curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | apt-key add -
#curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key add -

# Install CRI-O
#sudo apt update -y
#sudo apt install cri-o cri-o-runc -y

# Update CRI-O CIDR subnet
#sudo sed -i 's/10.85.0.0/192.168.0.0/g' /etc/cni/net.d/100-crio-bridge.conf

# Start and enable Service
#sudo systemctl daemon-reload
#sudo systemctl restart crio
#sudo systemctl enable crio


#Check if br_netfilter module is loaded
#lsmod | grep br_netfilter
#sudo systemctl enable kubelet

#sudo kubeadm config images pull

#sudo kubeadm config images pull --cri-socket unix:///var/run/crio/crio.sock
