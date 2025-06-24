#!/usr/bin/env sh
set -e

if [ ! -d "github" ]; then
    mkdir ./github
fi

cd github

if [ ! -d "rook/deploy/examples" ]; then
    git clone https://github.com/rook/rook.git
fi

cd rook/deploy/examples

NS=rook-ceph

kubectl apply -f crds.yaml
kubectl apply -f common.yaml
kubectl apply -f operator.yaml

##### update placement and storage base on your requirements
# storage:
#   useAllNodes: false
#   useAllDevices: false
#   nodes:
#     - name: c1
#       devices:
#         - name: "sdc"
#     - name: c2
#       devices:
#         - name: "sdc"
#     - name: c4
#       devices:
#         - name: "sdc"

kubectl apply -f cluster.yaml

kubectl -n $NS get pods
kubectl -n $NS get cephcluster