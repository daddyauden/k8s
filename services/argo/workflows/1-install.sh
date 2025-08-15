#!/usr/bin/env sh
set -e

NS=$ARGO_NS

helm repo add argo https://argoproj.github.io/argo-helm

kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NS
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argo-workflows-team-devops
  namespace: $NS
  annotations:
    workflows.argoproj.io/rbac-rule: "'${ORG_NAME}:DevOps' in groups"
    workflows.argoproj.io/rbac-rule-precedence: "10"
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argo-workflows-read-only
  namespace: $NS
  annotations:
    workflows.argoproj.io/rbac-rule: "true"
    workflows.argoproj.io/rbac-rule-precedence: "0"
---
apiVersion: v1
kind: Secret
metadata:
  name: argo-workflows-team-devops.service-account-token
  namespace: $NS
  annotations:
    kubernetes.io/service-account.name: argo-workflows-team-devops
type: kubernetes.io/service-account-token
EOF

kubectl create secret generic argo-workflows-minio --from-literal=accesskey=ead36fa2a638f64ce5c74885 --from-literal=secretkey=5ef0ebfcb0fd30c02170fb6baba6f6fb82661836407f25751c5ccb13ae1aa0f4 -n $NS

kubectl create secret generic argo-server-sso --from-literal=client-id=argo-workflows --from-literal=client-secret=c691081d35fe6a85bfadcb48de2d22f4c677e94f -n $NS

helm install argo-workflows argo/argo-workflows --version 0.45.22 --namespace $NS --create-namespace -f values.yaml --set server.ingress.hosts[0]="argoworkflows.${DOMAIN}" --set artifactRepository.s3.endpoint="s3.${DOMAIN}" --set server.sso.issuer="https://argocd.${DOMAIN}/api/dex" --set server.sso.redirectUrl="https://argoworkflows.${DOMAIN}/oauth2/callback"

kubectl create clusterrole argo-workflows-team-devops \
  --verb="*" \
  --resource=analysisruns.argoproj.io \
  --resource=analysistemplates.argoproj.io \
  --resource=applications.argoproj.io \
  --resource=applicationsets.argoproj.io \
  --resource=appprojects.argoproj.io \
  --resource=clusteranalysistemplates.argoproj.io \
  --resource=clusterworkflowtemplates.argoproj.io \
  --resource=cronworkflows.argoproj.io \
  --resource=eventbus.argoproj.io \
  --resource=eventsources.argoproj.io \
  --resource=experiments.argoproj.io \
  --resource=rollouts.argoproj.io \
  --resource=sensors.argoproj.io \
  --resource=workflowartifactgctasks.argoproj.io \
  --resource=workfloweventbindings.argoproj.io \
  --resource=workflows.argoproj.io \
  --resource=workflowtaskresults.argoproj.io \
  --resource=workflowtasksets.argoproj.io \
  --resource=workflowtemplates.argoproj.io

kubectl create clusterrolebinding argo-workflows-team-devops --clusterrole=argo-workflows-team-devops --serviceaccount=$NS:argo-workflows-team-devops

# helm upgrade argo-workflows argo/argo-workflows --namespace $ARGO_NS --create-namespace -f values.yaml --set server.ingress.hosts[0]="argoworkflows.${DOMAIN}" --set artifactRepository.s3.endpoint="s3.${DOMAIN}" --set server.sso.issuer="https://argocd.${DOMAIN}/api/dex" --set server.sso.redirectUrl="https://argoworkflows.${DOMAIN}/oauth2/callback"