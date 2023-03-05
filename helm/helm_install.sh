mkdir /home/vagrant/helm
curl -fsSL -o /home/vagrant/helm/get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 /home/vagrant/helm/get_helm.sh
/home/vagrant/helm/get_helm.sh
helm version