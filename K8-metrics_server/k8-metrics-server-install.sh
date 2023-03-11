#https://blog.zespre.com/deploying-metrics-server-on-kubernetes-cluster-installed-with-kubeadm.html
kubectl get csr | grep Pending | awk '{print $1}' | xargs -I {} kubectl certificate approve {}
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server

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



