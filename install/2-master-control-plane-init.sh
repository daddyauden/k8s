#!/usr/bin/env bash
set -e

CONTROL_PLANE_HOST=192.168.1.21

POD_NETWORK_CIDR=20.20.0.0/16

SERVICE_CIDR=30.30.0.0/16

sudo kubeadm init --v=10 --pod-network-cidr=$POD_NETWORK_CIDR --service-cidr=$SERVICE_CIDR --control-plane-endpoint=$CONTROL_PLANE_HOST:6443 --apiserver-advertise-address=$CONTROL_PLANE_HOST --upload-certs

# kubectl get nodes -o wide

# get tokens for worker node join
# kubeadm token create --print-join-command

# kubectl taint nodes c1 node-role.kubernetes.io/control-plane:NoSchedule
# kubectl taint nodes c2 node-role.kubernetes.io/control-plane:NoSchedule
# kubectl taint nodes c5 node-role.kubernetes.io/control-plane:NoSchedule

# kubectl taint nodes c1 node-role.kubernetes.io/control-plane:NoSchedule-
# kubectl taint nodes c2 node-role.kubernetes.io/control-plane:NoSchedule-
# kubectl taint nodes c5 node-role.kubernetes.io/control-plane:NoSchedule-

# kubectl describe node c1 | grep Taints
# kubectl describe node c2 | grep Taints
# kubectl describe node c5 | grep Taints

###### after add worker node, update label
# kubectl label node c2 node-role.kubernetes.io/worker=worker
# kubectl label node c4 node-role.kubernetes.io/worker=worker
# kubectl label node c5 node-role.kubernetes.io/worker=worker
