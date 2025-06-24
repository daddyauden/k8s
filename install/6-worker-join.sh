#!/usr/bin/env bash
set -e

CONTROL_PLANE_HOST=192.168.1.22

TOKEN=""
HASH=""

################################ worker节点 ################################
if [ "$TOKEN" = "X" ] || [ "$HASH" = "X" ] || [ "$CERT_KEY" = "X" ]; then
    echo "you need to run 2-master-control-plane-init.sh first, and then get token and hash value or run the command in first control plane: kubeadm token create --print-join-command"
else
    sudo kubeadm join $CONTROL_PLANE_HOST:6443 --token $TOKEN --discovery-token-ca-cert-hash $HASH
fi
