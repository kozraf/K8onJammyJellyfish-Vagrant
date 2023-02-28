#!/bin/bash

# Initialize the Kubernetes control plane
sudo kubeadm init --control-plane-endpoint=node1.local

# Copy Kubernetes configuration files to user directory
echo -e "----Copy Kubernetes configuration files to user directory----"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown  vagrant:vagrant /home/vagrant/.kube/config
export KUBECONFIG=/home/vagrant/.kube/config
sleep 30

# Install Calico pod network add-on
echo -e "----Install Calico pod network add-on----"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml
sleep 15

#Confirm master node is ready
echo -e "----Confirm master node is ready----"
kubectl get nodes -o wide
kubectl get pods --all-namespaces

# Print the kubeadm join command for the worker nodes
echo -e "----Print the kubeadm join command for the worker nodes----"
kubeadm token create --print-join-command > /vagrant/join-command.sh
