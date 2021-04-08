#!/bin/bash

# k8s官方的ingress-nginx，基于nginx和openresty
# https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal
# https://kubernetes.github.io/ingress-nginx/deploy/baremetal/

wget -O ingress-nginx.yaml https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/baremetal/deploy.yaml


kubectl delete ns ingress-nginx

flag=daemonset.ingress

# k8s.gcr.io/ingress-nginx/controller:v0.44.0@sha256:3dd0fac48073beaca2d67a78c746c7593f9c575168a17139a9955a82c63c4b9a
# k8s.gcr.io/ingress-nginx/controller:v0.45.0@sha256:c4390c53f348c3bd4e60a5dd6a11c35799ae78c49388090140b9d72ccede1755
# registry.aliyuncs.com/google_containers/nginx-ingress-controller:v0.45.0
# siriuszg/nginx-ingress-controller:v0.44.0
# sed -i "/k8s.gcr.io/ingress-nginx/controller:v0.44.0/a\ \ \ \ \ \ \ \ \ \ image: registry.aliyuncs.com/google_containers/nginx-ingress-controller:v0.44.0"  ingress-nginx.yaml
sed -i "/3dd0fac48073beaca2d67a78c746c7593f9c575168a17139a9955a82c63c4b9a/a\ \ \ \ \ \ \ \ \ \ image: siriuszg/nginx-ingress-controller:v0.44.0"  ingress-nginx.yaml
sed -i '/3dd0fac48073beaca2d67a78c746c7593f9c575168a17139a9955a82c63c4b9a/d'  ingress-nginx.yaml

# hostNetwork模式
sed -i '/dnsPolicy: ClusterFirst/a\ \ \ \ \ \ hostNetwork: true' ingress-nginx.yaml
# DaemonSet
sed -i 's#kind: Deployment#kind: DaemonSet#g' ingress-nginx.yaml
#sed -i "/os: linux/a\ \ \ \ \ \ \ \ daemonset.ingress: 'true'" ingress-nginx.yaml

# 增加亲和性部署
sed -i "/os: linux/a\ \ \ \ \ \ \ \ $flag: 'true'" ingress-nginx.yaml

# 支持tcp代理
sed -i '/--ingress-class=nginx/a\ \ \ \ \ \ \ \ \ \ \ \ - --tcp-services-configmap=\$(POD_NAMESPACE)/tcp-services' ingress-nginx.yaml


# nginx配置优化

cat >> ingress-nginx.yaml << EOF
# https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#configuration-options
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: ingress-nginx-controller
  namespace: ingress-nginx
  labels:
    helm.sh/chart: ingress-nginx-3.23.0
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/instance: ingress-nginx
    app.kubernetes.io/version: 0.44.0
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/component: controller
data:
  # nginx 与 client 保持的一个长连接能处理的请求数量，默认 100，高并发场景建议调高。
  # 参考: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#keep-alive-requests
  keep-alive-requests: "10000"
  # nginx 与 upstream 保持长连接的最大空闲连接数 (不是最大连接数)，默认 32，在高并发下场景下调大，避免频繁建联导致 TIME_WAIT 飙升。
  # 参考: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#upstream-keepalive-connections
  upstream-keepalive-connections: "200"
  # 每个 worker 进程可以打开的最大连接数，默认 16384。
  # 参考: https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/#max-worker-connections
  max-worker-connections: "65536"
  worker-processes: "4"

EOF


kubectl apply -f ingress-nginx.yaml

# 增加亲和性部署，标签的节点才会部署该DaemonSet，
# 注意，master节点，已经有了污点的标签，从亲和性上就已经不再容忍任何pod运行到master上
kubectl label nodes k8s-w2 $flag=true
kubectl label nodes k8s-w1 $flag=true


# kubectl label nodes k8s-w1 daemonset.ingress=true




kubectl get pod -n ingress-nginx

# kubectl exec -it ingress-nginx-controller-8r66x -n ingress-nginx -- cat nginx.conf

# kubectl logs -f  ingress-nginx-controller-77f8b55d4c-vfzhf -n ingress-nginx



