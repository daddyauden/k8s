#!/usr/bin/env sh
set -e

cd ./github/rook/deploy/examples

NS=rook-ceph

# Interactive Toolbox
kubectl apply -f toolbox.yaml -n $NS

kubectl -n $NS rollout status deploy/rook-ceph-tools

kubectl -n $NS exec -it deploy/rook-ceph-tools -- bash

# ceph status
# ceph osd status
# ceph osd tree
# ceph mgr services
# ceph df
# rados df
