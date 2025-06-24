#!/usr/bin/env bash
set -e

sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F

kubectl delete deployments --all --all-namespaces
kubectl delete statefulsets --all --all-namespaces
kubectl delete daemonsets --all --all-namespaces
kubectl delete all --all --all-namespaces

kubectl delete pv --all
kubectl delete pvc --all

sudo kubeadm reset --force

sudo rm -rf /etc/cni/net.d/*

sudo rm -rf /etc/kubernetes /var/lib/kubelet /var/lib/etcd /etc/cni/net.d
sudo rm -rf $HOME/.kube

sudo apt-mark unhold kubelet kubeadm kubectl
sudo apt-get purge -y kubeadm kubectl kubelet kubernetes-cni
sudo apt-get -y autoremove

sudo rm -rf /var/lib/etcd
sudo rm -rf /var/lib/kubelet
sudo rm -rf /etc/default/kubelet
sudo rm -rf /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo rm -rf /var/lib/containerd

sudo ip route flush proto bird

ls -la ~/.kube /etc/kubernetes /var/lib/kubelet
