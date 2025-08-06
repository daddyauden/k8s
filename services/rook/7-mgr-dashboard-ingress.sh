#!/usr/bin/env sh
set -e

# kubectl get secret tls-domain -n $NS -o yaml \
# | sed "s/namespace: $NS/namespace: rook-ceph/" \
# | kubectl apply -n rook-ceph -f -

kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rook-ceph-mgr-dashboard
  namespace: rook-ceph # namespace:cluster
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: "nginx"
  tls:
    - secretName: tls-domain
  rules:
    - host: "rook-ceph.${DOMAIN}"
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: rook-ceph-mgr-dashboard
                port:
                  name: http-dashboard

EOF

# get default user admin password for login dashboard
kubectl -n rook-ceph get secret rook-ceph-dashboard-password -o jsonpath="{['data']['password']}" | base64 --decode && echo