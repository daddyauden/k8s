#!/usr/bin/env bash
set -e

CONTROL_PLANE_HOST=192.168.1.100

POD_NETWORK_CIDR=20.20.0.0/16

SERVICE_CIDR=30.30.0.0/16

sudo kubeadm init --v=10 --pod-network-cidr=$POD_NETWORK_CIDR --service-cidr=$SERVICE_CIDR --control-plane-endpoint=$CONTROL_PLANE_HOST:6443 --apiserver-advertise-address=$CONTROL_PLANE_HOST --upload-certs

# kubectl get nodes -o wide

# get tokens for worker node join
# kubeadm token create --print-join-command

###### after add worker node, update label
# kubectl label node s1 node-role.kubernetes.io/worker=worker
# kubectl label node s2 node-role.kubernetes.io/worker=worker
