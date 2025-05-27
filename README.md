# Common commands

```
k config view --raw > kubeconfig.yaml
```

# Kubernetes (k8s) 常用命令大全

<br />

## 集群信息命令


### 查看集群信息
```
# 显示集群基本信息
kubectl cluster-info

# 显示客户端和服务器版本
kubectl version

# 查看组件状态
kubectl get componentstatuses
```

### 节点管理
```
# 查看所有节点
kubectl get nodes

# 查看节点详细信息
kubectl describe node <node-name>

# 查看节点资源使用情况
kubectl top node

# 标记节点为不可调度
kubectl cordon <node-name>

# 标记节点为可调度
kubectl uncordon <node-name>

# 排空节点(准备维护)
kubectl drain <node-name>
```

<br />

## 资源管理命令

### Pod 操作
```
# 查看Pod列表
kubectl get pods [-n namespace]

# 查看Pod列表(带节点信息)
kubectl get pods -o wide

# 查看Pod详细信息
kubectl describe pod <pod-name>

# 查看Pod日志
kubectl logs <pod-name>

# 实时查看Pod日志
kubectl logs -f <pod-name>

# 进入Pod容器
kubectl exec -it <pod-name> -- /bin/bash

# 删除Pod
kubectl delete pod <pod-name>

# 查看Pod资源使用
kubectl top pod <pod-name>
```

### Deployment 操作
```
# 查看Deployment列表
kubectl get deployments

# 查看Deployment详情
kubectl describe deployment <deploy-name>

# 查看滚动更新状态
kubectl rollout status deployment/<deploy-name>

# 查看更新历史
kubectl rollout history deployment/<deploy-name>

# 回滚到上一版本
kubectl rollout undo deployment/<deploy-name>

# 扩展副本数
kubectl scale deployment <deploy-name> --replicas=3

# 编辑Deployment配置
kubectl edit deployment <deploy-name>

# 查看StatefulSet列表
kubectl get statefulsets
```

### Service 操作
```
# 查看Service列表
kubectl get services

# 查看Service详情
kubectl describe service <service-name>

# 创建Service
kubectl expose deployment <deploy-name> --port=80 --target-port=8080

# 查看Ingress规则
kubectl get ingress
```

### ConfigMap 和 Secret
```
# 查看ConfigMap列表
kubectl get configmaps

# 从文件创建ConfigMap
kubectl create configmap <name> --from-file=path/to/file

# 查看Secret列表
kubectl get secrets

# 创建Secret
kubectl create secret generic <name> --from-literal=key=value
```

<br />

## 调试和故障排查

### 查看资源使用情况
```
# 查看节点资源使用
kubectl top nodes

# 查看Pod资源使用
kubectl top pods
```

### 事件查看
```
# 查看集群事件
kubectl get events

# 按时间排序事件
kubectl get events --sort-by='.metadata.creationTimestamp'
```

### 网络诊断
```
# 启动调试容器
kubectl run -it --rm --image=busybox debug --restart=Never -- sh

# 端口转发
kubectl port-forward <pod-name> 8080:80
```

<br />

## 命名空间操作
```
# 查看命名空间
kubectl get ns

# 创建命名空间
kubectl create ns <namespace>

# 删除命名空间
kubectl delete ns <namespace>

# 切换当前命名空间
kubectl config set-context --current --namespace=<namespace>
```

<br />

## 实用技巧

### 批量操作
```
# 删除所有Pod
kubectl delete pods --all

# 删除当前命名空间所有资源
kubectl delete all --all

# 查看所有资源
kubectl get all
```

### YAML 操作
```
# 应用YAML配置
kubectl apply -f file.yaml

# 删除YAML定义的资源
kubectl delete -f file.yaml

# 获取资源配置(YAML格式)
kubectl get <resource> <name> -o yaml

# 编辑资源配置
kubectl edit <resource> <name>
```

### 上下文管理
```
# 查看所有上下文
kubectl config get-contexts

# 切换上下文
kubectl config use-context <context-name>

# 查看当前上下文
kubectl config current-context
```

<br />

## 高级命令

### 污点和容忍度
```
# 添加污点
kubectl taint nodes <node-name> key=value:NoSchedule

# 移除污点
kubectl taint nodes <node-name> key:NoSchedule-
```

### 亲和性和反亲和性
```
# 查看Pod亲和性设置
kubectl get pods -o json | jq '.items[].spec.affinity'
```

### CRD 操作
```
# 查看自定义资源定义
kubectl get crd

# 查看自定义资源
kubectl get <custom-resource>
```

<br />

## 常用命令组合

```
# 查看Pod及其所在节点
kubectl get pods -o wide

# 查看Pod日志并实时刷新
kubectl logs -f <pod-name> --tail=100

# 查看Pod中特定容器的日志
kubectl logs <pod-name> -c <container-name>

# 强制删除卡在Terminating状态的Pod
kubectl delete pod <pod-name> --grace-period=0 --force

# 查看Pod的标签
kubectl get pods --show-labels

# 根据标签筛选Pod
kubectl get pods -l app=nginx

# 查看Pod的详细状态变化
kubectl get pods -w

# 导出资源配置
kubectl get deployment <name> -o yaml > deploy.yaml
```
