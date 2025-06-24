#!/usr/bin/env sh
set -e

cd ./github

if [ ! -d "rook/deploy/examples" ]; then
    git clone https://github.com/rook/rook.git
fi

cd rook/deploy/examples

NS=rook-ceph

kubectl apply -f crds.yaml
kubectl apply -f common.yaml
kubectl apply -f operator.yaml

##### update placement and storage base on your requirements
# placement:
#   osd:
#     nodeAffinity:
#       requiredDuringSchedulingIgnoredDuringExecution:
#         nodeSelectorTerms:
#         - matchExpressions:
#           - key: rook-ceph-osd
#             operator: In
#             values:
#             - "true"
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

kubectl label node c1 rook-ceph-osd=true
kubectl label node c2 rook-ceph-osd=true
kubectl label node c4 rook-ceph-osd=true

kubectl apply -f cluster.yaml

kubectl -n $NS get pods
kubectl -n $NS get cephcluster