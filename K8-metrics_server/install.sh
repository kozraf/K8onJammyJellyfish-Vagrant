#https://blog.zespre.com/deploying-metrics-server-on-kubernetes-cluster-installed-with-kubeadm.html
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server
kubectl get po -A


