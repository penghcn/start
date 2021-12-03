#!/bin/bash

# curl -sSL http://192.168.8.251/open/doc/raw/master/k8s/dashboard.sh | sh


# 管理员账户名称
username=admin-user
node_port=30043

kubectl delete ns kubernetes-dashboard 

# https://blog.csdn.net/networken/article/details/85607593
# https://github.com/kubernetes/dashboard
curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml > recommended.yaml

#修改yaml配置超时时间12h
sed -i '/--namespace=kubernetes-dashboard/a\ \ \ \ \ \ \ \ \ \ \ \ - --token-ttl=43200' recommended.yaml

# 改成nodePort 暴露
sed -i "/targetPort: 8443/a\ \ \ \ \ \ nodePort: $node_port" recommended.yaml
sed -i "/nodePort: $node_port/a\ \ type: NodePort" recommended.yaml

kubectl apply -f recommended.yaml


#添加admin-user账户

rm dashboard-adminuser.yaml
cat > dashboard-adminuser.yaml << EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: $username
  namespace: kubernetes-dashboard

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $username
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: $username
  namespace: kubernetes-dashboard  

EOF

kubectl apply -f dashboard-adminuser.yaml


#查看admin-user账户的token
# kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')

kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep $username | awk '{print $1}')


local_ip=$(echo $(ip addr | grep bond0 | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')| awk '{print $1}')

# 使用firefox 访问
# curl -ki https://192.168.8.122:30043
echo "请使用firefox访问如下地址，登录token参考上文"
echo "https://$local_ip:$node_port"


