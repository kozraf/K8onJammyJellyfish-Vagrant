# K8onJammyJellyfish-Vagrant
3-node K8 cluster (contanierd CRI with "flannel" layer 3 fabric) on Ubuntu using VirtualBox and Vagrant

K8 used - 1.26

**Requirements**
- HashiCorp Vagrant - https://www.vagrantup.com/ (tested on 2.3.2)
- Oracle VirtualBox - https://www.virtualbox.org/ (tested on 7.0.2 r154219)
- PC with at least 32GB RAM (VM's are configured with 6GB RAM each + you need some RAM for your main OS but you can assign less RAM for VM's by modifying vb.memory field in vagrantfile)


**Instructions**
1. Clone repo to your local HDD
2. Use cmd to access that location
3. Run "vagrant up" 
