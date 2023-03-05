#!/bin/bash

# Initialize the Kubernetes control plane
echo -e "--------"
echo -e "----Initialize the Kubernetes control plane----"
sudo kubeadm init --apiserver-advertise-address 192.168.89.141 --pod-network-cidr 10.10.0.0/16 --control-plane-endpoint=node1.local

# Copy Kubernetes configuration files to user directory
echo -e "--------"
echo -e "----Copy Kubernetes configuration files to user directory----"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown  vagrant:vagrant /home/vagrant/.kube/config
export KUBECONFIG=/home/vagrant/.kube/config
sleep 30

# Install Calico pod network add-on
echo -e "--------"
echo -e "----Install Calico pod network add-on----"
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

#Confirm master node is ready
echo -e "--------"
echo -e "----Confirm master node is ready----"
kubectl get nodes -o wide
kubectl get pods --all-namespaces

# Print the kubeadm join command for the worker nodes
echo -e "--------"
echo -e "----Print the kubeadm join command for the worker nodes----"
kubeadm token create --print-join-command > /vagrant/K8/join-command.sh
