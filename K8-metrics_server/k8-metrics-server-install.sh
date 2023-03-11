#https://blog.zespre.com/deploying-metrics-server-on-kubernetes-cluster-installed-with-kubeadm.html
kubectl get csr | grep Pending | awk '{print $1}' | xargs -I {} kubectl certificate approve {}
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server
kubectl get po -A


