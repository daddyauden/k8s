#!/usr/bin/env sh
set -e

####### in 2-import-ceph-config-to-rook.sh script, user and secret should be set, if not run the commands
# ######### run the commands from ceph admin node #########
# radosgw-admin user create \
# --uid=rgw-admin-ops-user \
# --display-name="RGW Admin Ops User" \
# --caps="buckets=*;users=*;usage=read;metadata=read;zone=read" \
# --rgw-realm=america \
# --rgw-zonegroup=us-east \
# --rgw-zone=us-east-a

# ######### run the commands in k8s control plane, make sure secret correct, remove it first then create again #########
kubectl -n rook-ceph delete secret rgw-admin-ops-user

kubectl -n rook-ceph create secret generic --type="kubernetes.io/rook" rgw-admin-ops-user --from-literal=accessKey=5WD2NS8IH4ZFVPT9IABZ --from-literal=secretKey=gRhXOpzSrMFksjNMpUv7eESxuFA7iPMd3HYuKC0T