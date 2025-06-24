#!/usr/bin/env sh
set -e

cd /gluster/app/github/

NS=rook-ceph

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

if [ ! -d "rook/deploy/examples" ]; then
    git clone --single-branch --branch v1.17.4 https://github.com/rook/rook.git
fi

cd rook/deploy/examples

kubectl apply -f crds.yaml -f common.yaml -f operator.yaml -n $NS
kubectl apply -f cluster.yaml -n $NS

for device in sda sdc; do
  sudo sgdisk --zap-all /dev/$device
  sudo dd if=/dev/zero of=/dev/$device bs=1M count=1000 oflag=direct,dsync
  sudo wipefs -a /dev/$device
done

sudo pvremove --force --force /dev/sda
sudo pvremove --force --force /dev/sdc