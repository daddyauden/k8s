#!/usr/bin/env sh

echo -n admin > ./username.txt
echo -n admin > ./password.txt

kubectl create secret generic secret2 --from-file ./username.txt --from-file ./password.txt
