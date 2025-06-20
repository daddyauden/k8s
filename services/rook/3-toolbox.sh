#!/usr/bin/env sh
set -e

cd /tmp/rook/deploy/examples

# Interactive Toolbox
kubectl apply -f toolbox.yaml

kubectl -n rook-ceph rollout status deploy/rook-ceph-tools

kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash

# ceph status
# ceph osd status
# ceph osd tree
# ceph mgr services
# ceph df
# rados df
