#!/usr/bin/env sh

helm repo add gitlab http://charts.gitlab.io/

helm install gitlab-runner gitlab/gitlab-runner --version 0.79.1 -f values.yaml --set gitlabUrl="https://gitlab.$DOMAIN/" 

# helm upgrade gitlab-runner gitlab/gitlab-runner -f values.yaml --set gitlabUrl="https://gitlab.$DOMAIN/" 
