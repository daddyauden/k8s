#!/usr/bin/env sh
set -e

# create tls cert secret
kubectl create secret tls ss-com-tls \
  --cert=./pem/fullchain.cer \
  --key=./pem/private.key

kubectl apply -f 01-rbac.yml \
              -f 02-traefik.yml \
              -f 03-whoami.yml \
              -f 04-ingress.yml