#!/usr/bin/env bash
set -e

################################ all nodes ################################

VERSION="v1.33"

sudo apt install -y build-essential bash-completion

sudo swapoff -a
sudo sed -i '/swap/s/^\(.*\)$/#\1/g' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

sudo timedatectl set-timezone UTC

sudo apt-get update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

sudo apt-get update
sudo apt install -y apt-transport-https ca-certificates curl gpg iptables
curl -fsSL https://pkgs.k8s.io/core:/stable:/${VERSION}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${VERSION}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable kubelet

if [ ! -f "/etc/default/kubelet" ]; then
    sudo touch /etc/default/kubelet
    sudo chmod 644 /etc/default/kubelet
    sudo chown root:root /etc/default/kubelet
fi
echo 'KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"' | sudo tee /etc/default/kubelet
