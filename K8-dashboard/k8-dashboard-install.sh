#!/bin/bash

# Create a namespace for the dashboard
kubectl create namespace kubernetes-dashboard

mkdir /home/vagrant/K8-dashboard

# Deploy the dashboard using NodePort service
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl -n kubernetes-dashboard patch service kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":32321}]'

# Create admin-user Service Account
sudo tee /home/vagrant/K8-dashboard/k8-sa_admi-user.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
    name: admin-user
    namespace: kubernetes-dashboard
EOF
kubectl apply -f /home/vagrant/K8-dashboard/k8-sa_admi-user.yaml

# Create admin-user ClusterRole and ClusterRoleBinding
sudo tee /home/vagrant/K8-dashboard/k8dash-cr-crb_admin-user.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
kubectl apply -f /home/vagrant/K8-dashboard/k8dash-cr-crb_admin-user.yaml

#Create and display token to logon
echo -e "!!!"
kubectl -n kubernetes-dashboard create token admin-user
echo -e "!!!"
echo "Copy above between !!! but remember that output is wrapped!"


