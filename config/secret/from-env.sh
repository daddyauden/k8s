#!/usr/bin/env sh

cat << EOF > secret3
username=admin
password=admin
EOF

kubectl create secret generic secret3 --from-env-file ./secret3