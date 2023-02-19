#!/bin/bash

# Initialize the Kubernetes control plane
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///var/run/crio/crio.sock

# Copy Kubernetes configuration files to user directory
mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico pod network add-on
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml 
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yam

#Confirm master node is ready

kubectl get nodes -o wide

# Print the kubeadm join command for the worker nodes
kubeadm token create --print-join-command > /vagrant/join-command.sh
