kubectl create namespace k8-dashboard
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm install k8s-dashboard kubernetes-dashboard/kubernetes-dashboard --namespace k8-dashboard
sleep 60

export POD_NAME=$(kubectl get pods -n k8-dashboard -l  "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=k8s-dashboard" -o jsonpath="{.items[0].metadata.name}")

mkdir /home/vagrant/K8-dashboard
sudo tee /home/vagrant/K8-dashboard/sa_cluster_admin.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: dashboard-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-admin-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: dashboard-admin
  namespace: kube-system
EOF

kubectl create -f /home/vagrant/K8-dashboard/sa_cluster_admin.yaml
kubectl -n kube-system describe sa dashboard-admin

