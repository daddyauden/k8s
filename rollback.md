### deploy v1.23
```
k apply -f config/deployment/nginx/v1.23.0.yaml --record
```

```
k get deployments -o wide
k get replicasets -o wide
k rollout history deployment nginx 
```

### deploy v1.24
```
k apply -f config/deployment/nginx/v1.24.0.yaml --record
```
k get
### deploy v1.25
```
k apply -f config/deployment/nginx/v1.25.0.yaml --record
```

### check revision
```
k rollout history deployment nginx
```

```
k describe deployments nginx


### rollout
```
k rollout undo deployment nginx --to-revision=2
```