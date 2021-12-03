#!/bin/bash

# 只在第1个 master 节点执行

if [ ${#REGISTRY_MIRROR} -eq 0 ]; then
    REGISTRY_MIRROR="https://registry.cn-shanghai.aliyuncs.com"
    echo "当前REGISTRY_MIRROR=$REGISTRY_MIRROR"
fi

if [ ${#POD_SUBNET} -eq 0 ] || [ ${#APISERVER_NAME} -eq 0 ] || [ ${#SERVICE_SUBNET} -eq 0 ]; then
  echo -e "\033[31;1m请确保您已经设置了环境变量 POD_SUBNET、SERVICE_SUBNET 和 APISERVER_NAME \033[0m"
  echo "当前POD_SUBNET=$POD_SUBNET"
  echo "当前SERVICE_SUBNET=$SERVICE_SUBNET"
  echo "当前APISERVER_NAME=$APISERVER_NAME"
  exit 1
fi

# 若报错
# [ERROR FileContent--proc-sys-net-ipv4-ip_forward]: /proc/sys/net/ipv4/ip_forward contents are not set to 1
echo 1 > /proc/sys/net/ipv4/ip_forward

# 镜像仓库设置参考
# https://github.com/zhangguanzhang/google_containers

# 查看完整配置选项 https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2
# https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/#options
# 注意，该地址registry.cn-shanghai.aliyuncs.com/k8sxio 不存在
# imageRepository: registry.cn-hangzhou.aliyuncs.com/k8sxio

image_repository=registry.cn-hangzhou.aliyuncs.com/google_containers

rm -f ./kubeadm-config.yaml
cat <<EOF > ./kubeadm-config.yaml
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: v${1}
imageRepository: $image_repository
controlPlaneEndpoint: "${APISERVER_NAME}:6443"
networking:
  serviceSubnet: "${SERVICE_SUBNET}"
  podSubnet: "${POD_SUBNET}"
  dnsDomain: "cluster.local"

---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
maxPods: 100 # 默认110
EOF

# kubeadm init
# 根据您服务器网速的情况，您需要等候 3 - 10 分钟
echo ""
echo "$image_repository 抓取镜像，请稍候..."

# 默认配置
# kubeadm config print init-defaults

# 查看需要镜像
# kubeadm config images list --config kubeadm-config.yaml

kubeadm config images pull --config=kubeadm-config.yaml
echo ""
echo "初始化 Master 节点"
kubeadm init --config=kubeadm-config.yaml --upload-certs

# 配置 kubectl
rm -rf /root/.kube/
mkdir /root/.kube/
cp -i /etc/kubernetes/admin.conf /root/.kube/config

# 安装 calico 网络插件
# 参考文档 https://docs.projectcalico.org/v3.13/getting-started/kubernetes/self-managed-onprem/onpremises
# echo ""
# echo "安装calico-3.17.1"
# rm -f calico-3.17.1.yaml
# kubectl create -f https://kuboard.cn/install-script/v1.20.x/calico-operator.yaml
# wget https://kuboard.cn/install-script/v1.20.x/calico-custom-resources.yaml
# sed -i "s#192.168.0.0/16#${POD_SUBNET}#" calico-custom-resources.yaml
# kubectl create -f calico-custom-resources.yaml

# https://docs.projectcalico.org/getting-started/kubernetes/self-managed-onprem/onpremises
echo ""
echo "安装calico enterprise，使用tigera-operator"
# kubectl create -f https://docs.projectcalico.org/manifests/calico.yaml

# https://docs.tigera.io/manifests/tigera-operator.yaml
# https://docs.tigera.io/manifests/custom-resources.yaml
# kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml

kubectl create -f $2/open/doc/raw/master/k8s/tigera-operator.yaml

cat <<EOF > ./calico-custom-resources.yaml
apiVersion: operator.tigera.io/v1
kind: Installation
metadata:
  name: default
spec:
  # Configures Calico networking.
  calicoNetwork:
    # Note: The ipPools section cannot be modified post-install.
    ipPools:
    - blockSize: 26
      cidr: "${POD_SUBNET}"
      encapsulation: VXLANCrossSubnet
      natOutgoing: Enabled
      nodeSelector: all()
EOF
kubectl create -f calico-custom-resources.yaml


# 移除master污点
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get nodes -o wide

wait_seconds=10

for (( j = 0; j < 3; j++ )); do
    echo "wait $wait_seconds s, kubectl get pods -o wide --all-namespaces"
    for (( i = 0; i < $wait_seconds; i++ )); do
        echo -n "."
        sleep 1
    done
    echo ""

    kubectl get pods -o wide --all-namespaces
done

