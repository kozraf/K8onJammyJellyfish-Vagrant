#!/bin/bash

# Initialize the Kubernetes control plane
echo -e "--------"
echo -e "----Initialize the Kubernetes control plane----"

# https://particule.io/en/blog/kubeadm-metrics-server/
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#kubelet-serving-certs
mkdir /home/vagrant/K8
sudo tee /home/vagrant/K8/config.yaml <<EOF
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  certSANs:
  - 192.168.89.141
  extraArgs:
    advertise-address: 192.168.89.141
controlPlaneEndpoint: node1.local
networking:
  podSubnet: 10.10.0.0/16
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
serverTLSBootstrap: true
EOF

sudo kubeadm init --config=/home/vagrant/K8/config.yaml

# Copy Kubernetes configuration files to user directory
echo -e "--------"
echo -e "----Copy Kubernetes configuration files to user directory----"
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown  vagrant:vagrant /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube/
export KUBECONFIG=/home/vagrant/.kube/config
sleep 30

# Install Calico pod network add-on
echo -e "--------"
echo -e "----Install Calico pod network add-on----"
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

#Confirm master node is ready
echo -e "--------"
echo -e "----Confirm master node is ready----"
sleep 15
kubectl get nodes -o wide
kubectl get pods --all-namespaces

#Serving Certificates Signed by Cluster CA - enable serverTLSBootstrap
echo -e "--------"
echo -e "----Approve certs that are still shown as Pending----"
kubectl get csr
kubectl get csr | grep Pending | awk '{print $1}' | xargs -I {} kubectl certificate approve {}


#Remove taint from node1
echo -e "--------"
echo -e "----Remove taint from node1----"
kubectl taint nodes node1 node-role.kubernetes.io/control-plane-


# Print the kubeadm join command for the worker nodes
echo -e "--------"
echo -e "----Print the kubeadm join command for the worker nodes----"
kubeadm token create --print-join-command > /vagrant/K8/join-command.sh
