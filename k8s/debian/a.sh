#!/bin/sh

# https://help.aliyun.com/document_detail/100410.html#title-fqd-t6d-in6
# debian 10.11
# sh update_source.sh http://192.168.8.71:29106
cat /etc/debian_version
## --------------------------
## 更新apt源
## --------------------------
# repo_base_url=$1

# url_debian=$repo_base_url/repository/debian-buster
# url_debian_sec=$repo_base_url/repository/debian-buster-sec
# url_debian_docker_ce=$repo_base_url/repository/debian-docker-ce
# url_debian_k8s=$repo_base_url/repository/debian-k8s

url_debian=http://mirrors.aliyun.com/debian
url_debian_sec=http://mirrors.aliyun.com/debian-security
url_debian_docker_ce=http://mirrors.aliyun.com/docker-ce/linux/debian/
url_debian_k8s=http://mirrors.aliyun.com/kubernetes/apt/

# 安装基本设施
sudo apt-get install -y apt-transport-https ca-certificates curl

# 配置debian源
# http://mirrors.aliyun.com/debian
# http://mirrors.aliyun.com/debian-security
mv /etc/apt/sources.list{,.bak}
cat > /etc/apt/sources.list <<EOF
deb $url_debian buster main contrib non-free
deb-src $url_debian/ buster main contrib non-free

deb $url_debian buster-updates main contrib non-free
deb-src $url_debian/ buster-updates main contrib non-free

deb $url_debian buster-backports main

deb $url_debian_sec/ buster/updates main contrib non-free
deb-src $url_debian_sec/ buster/updates main contrib non-free
EOF

sudo apt-get update

# debian 10 默认关闭了 cgroup hugetlb 可以通过更新内核开启
# debian 10 升级内核
sudo apt -t buster-backports  install linux-image-amd64

# reboot

uname -r
# 重启后，查看cgroup hugetlb
grep HUGETLB /boot/config-$(uname -r)    

# 配置docker-ce的源
sudo apt-get -y install ca-certificates curl gnupg lsb-release

curl -fsSL $url_debian_docker_ce/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $url_debian_docker_ce \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list > /dev/null


#baseurl=http://mirrors.aliyun.com/kubernetes/apt/dists/kubernetes-xenial
# 配置K8S的源
curl -s $url_debian_k8s/doc/apt-key.gpg | apt-key add -

cat > /etc/apt/sources.list.d/kubernetes.list <<EOF 
deb $url_debian_k8s/ kubernetes-xenial main
EOF

sudo apt-get update


## --------------------------
## 启用ipvs
## --------------------------

apt-get install -y ipvsadm ipset sysstat conntrack libseccomp2

# 开机自启动加载ipvs内核

ipvsadm --clear


cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Apply sysctl params without reboot
sysctl --system


# 卸载旧版本
sudo apt-get remove -y containerd.io runc
# 安装 containerd
#yum install -y containerd.io-1.4.12
sudo apt-get install -y containerd.io

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd
crictl config runtime-endpoint unix:///run/containerd/containerd.sock

# 关闭 防火墙
sudo apt-get install -y firewalld

systemctl stop firewalld
systemctl disable firewalld

# 关闭 SeLinux
sudo apt-get install -y selinux-utils selinux-basics setools

setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 关闭 swap
swapoff -a && sysctl -w vm.swappiness=0
#yes | cp /etc/fstab /etc/fstab_bak
#cat /etc/fstab_bak |grep -v swap > /etc/fstab
sudo sed -i '/ swap / s/^/#/' /etc/fstab

#reboot


cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system


kubeadm reset -f && rm -rf ~/.kube
rm -rf /etc/kubernetes 
rm -rf /var/lib/etcd

sudo apt remove -y --purge kubelet kubeadm kubectl  kubernetes-cni

sudo apt autoremove -y kubelet kubeadm kubectl  kubernetes-cni #--allow-change-held-packages

systemctl daemon-reload

# 安装kubelet、kubeadm、kubectl
# 将 $k8s_version 替换为 kubernetes 版本号，例如 1.22.4-00
sudo apt-get install -y kubelet kubeadm kubectl #--allow-change-held-packages

systemctl daemon-reload
systemctl enable kubelet && systemctl restart kubelet 
## systemctl status kubelet 

kubelet --version


cat /usr/lib/systemd/system/kubelet.service.d/*
cat /etc/systemd/system/kubelet.service.d/*


kubeadm reset -f && rm -rf ~/.kube

REGISTRY_MIRROR=https://registry.cn-shanghai.aliyuncs.com
REGISTRY_MIRROR=https://mirror.ccs.tencentyun.com/
APISERVER_NAME=t.k8
SERVICE_SUBNET=172.30.0.0/16
POD_SUBNET=172.31.0.0/16
echo "127.0.0.1 ${APISERVER_NAME}" >> /etc/hosts
echo 1 > /proc/sys/net/ipv4/ip_forward

# 镜像仓库设置参考
# https://github.com/zhangguanzhang/google_containers

# 查看完整配置选项 https://godoc.org/k8s.io/kubernetes/cmd/kubeadm/app/apis/kubeadm/v1beta2
# https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/#options
# 注意，该地址registry.cn-shanghai.aliyuncs.com/k8sxio 不存在
# imageRepository: registry.cn-hangzhou.aliyuncs.com/k8sxio

image_repository=registry.cn-hangzhou.aliyuncs.com/google_containers

image_aliyun='registry.cn-hangzhou.aliyuncs.com'

sed -i "s#k8s.gcr.io#$image_aliyun/google_containers#g"  /etc/containerd/config.toml
sed -i '/containerd.runtimes.runc.options/a\ \ \ \ \ \ \ \ \ \ \ \ SystemdCgroup = true' /etc/containerd/config.toml
sed -i "s#https://registry-1.docker.io#${REGISTRY_MIRROR}#g"  /etc/containerd/config.toml

systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd

# https://kubernetes.io/docs/reference/config-api/kubeadm-config.v1beta3/
# https://www.jianshu.com/p/50ce5ebced0c

rm -f ./kubeadm-config.yaml
cat <<EOF > ./kubeadm-config.yaml
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
imageRepository: $image_repository
controlPlaneEndpoint: "${APISERVER_NAME}:6443"
networking:
  serviceSubnet: "${SERVICE_SUBNET}"
  podSubnet: "${POD_SUBNET}"
  dnsDomain: "cluster.local"
apiServer:
  timeoutForControlPlane: 1m0s
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  criSocket: "unix:///run/containerd/containerd.sock"
  taints: null

---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
maxPods: 100 # 默认110

---
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
featureGates:
  SupportIPVSProxyMode: true
mode: ipvs
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


kubectl get nodes -o wide

sleep 5
kubectl get pods -o wide --all-namespaces


