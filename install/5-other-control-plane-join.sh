#!/usr/bin/env bash
set -e


CONTROL_PLANE_HOST=192.168.1.21

TOKEN=""
HASH=""
CERT_KEY=""

if [ "$TOKEN" = "X" ] || [ "$HASH" = "X" ] || [ "$CERT_KEY" = "X" ]; then
    echo "you need to run 2-master-control-plane-init.sh first, and then get token and hash value or run the command in first control plane: kubeadm token create --print-join-command"
else
    sudo kubeadm join $CONTROL_PLANE_HOST:6443 --control-plane --token $TOKEN --discovery-token-ca-cert-hash $HASH --certificate-key $CERT_KEY
fi
