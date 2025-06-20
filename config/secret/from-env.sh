#!/usr/bin/env sh

cat << EOF > secret
username=admin
password=admin
EOF

kubectl create secret generic secret1 --from-env-file ./secret