#!/bin/bash

# Create a namespace for the dashboard
kubectl create namespace kubernetes-dashboard

mkdir /home/vagrant/K8-dashboard

# Deploy the dashboard using NodePort service
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl -n kubernetes-dashboard patch service kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":32321}]'

#!/bin/bash

# Define the animation
animation="-\|/"

while true; do
  for ns in $(kubectl get namespaces -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'); do
    for pod in $(kubectl get pods -n $ns -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'); do
      total=$(kubectl get pod $pod -n $ns -o=jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' | wc -l)
      running=$(kubectl get pod $pod -n $ns -o=jsonpath='{range .status.containerStatuses[*]}{.state.running}{end}' | grep -c true)
      if [[ $total -ne $running ]]; then
        for i in $(seq 0 3); do
          echo -ne "\r[${animation:$i:1}]"
          sleep 0.1
          done
        echo -e "\033[33m---\033[0m"
        echo -e "\033[33mWaiting for all containers to be running in pod $pod in namespace $ns \033[0m"
        sleep 1
      fi
    done
  done
  echo -e "\e[32mAll pods are ready!\e[0m"
  break
done


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
echo -e "\e[32mCopy above between !!! but remember that output is wrapped!!\e[0m"


