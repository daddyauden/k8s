#!/usr/bin/env sh
set -e

cd github/rook/deploy/examples

# change port from 80 to 7480, ip to c1 ip
kubectl apply -f external/object-external.yaml
### change objectStoreName from my-store to external-store
kubectl apply -f external/storageclass-bucket-delete.yaml
# change name from ceph-delete-bucket to ceph-bucket
kubectl apply -f external/object-bucket-claim-delete.yaml
# change name to rook-ceph-rgw-external-store-external, rook_cluster to rook-ceph-external, rook_object_store to external-store, targetPort to 7480, change type to ExternalName, and add externalName to c1 ip address
kubectl apply -f rgw-external.yaml


### get variable for config in k8s control plane
AWS_HOST=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_HOST}')
PORT=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_PORT}')
BUCKET_NAME=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_NAME}')
AWS_ACCESS_KEY_ID=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 --decode)
AWS_SECRET_ACCESS_KEY=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 --decode)


# toolbox-image
kubectl apply -f toolbox-operator-image.yaml

kubectl -n rook-ceph exec -it ${toolbox-image-pod} -- bash

# after in toolbox-image, change variable with the value in host
cat >> ~/.bashrc << EOF
export AWS_HOST=$AWS_HOST
export PORT=$PORT
export BUCKET_NAME=$BUCKET_NAME
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
alias s5cmd="s5cmd --endpoint-url http://$AWS_HOST:$PORT"
EOF


echo "Hello Rook" > /tmp/rookObj
s5cmd cp /tmp/rookObj s3://$BUCKET_NAME
s5cmd ls
s5cmd cat s3://$BUCKET_NAME/rookObj
