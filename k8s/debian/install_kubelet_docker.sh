#!/bin/sh

# 参考 https://kuboard.cn/install/install-k8s.html#%E7%A7%BB%E9%99%A4worker%E8%8A%82%E7%82%B9%E5%B9%B6%E9%87%8D%E8%AF%95
# 使用 
# 或者腾讯云 
# https://mirror.ccs.tencentyun.com
# https://registry.cn-shanghai.aliyuncs.com https://registry.cn-hangzhou.aliyuncs.com
# export REGISTRY_MIRROR=https://registry.cn-shanghai.aliyuncs.com
# curl -sSL https://kuboard.cn/install-script/v1.20.x/install_kubelet.sh | sh -s 1.20.4


# sh install_kubelet.sh 1.20.4  http://192.168.8.71:29106

# 在 master 节点和 worker 节点都要执行
k8s_version="${1}-00"

## --------------------------
## 更新apt源
## --------------------------
sh update_source.sh $2


## --------------------------
## 启用ipvs
## --------------------------

apt-get install -y ipvsadm ipset sysstat conntrack libseccomp2

# 开机自启动加载ipvs内核
> /etc/modules-load.d/ipvs.conf
module=(
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
br_netfilter
)
for kernel_module in ${module[@]};do
    /sbin/modinfo -F filename $kernel_module |& grep -qv ERROR && echo $kernel_module >> /etc/modules-load.d/ipvs.conf || :
done
# systemctl enable --now systemd-modules-load.service

ipvsadm --clear


## --------------------------
## 安装 containerd
## --------------------------
# 参考文档如下
# https://github.com/containerd/containerd
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd


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
sudo apt-get remove -y  docker docker-engine docker.io containerd runc containerd.io

# 安装 containerd
#yum install -y containerd.io-1.4.12
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

cp /usr/share/bash-completion/completions/docker /etc/bash_completion.d/
mkdir  /etc/docker
> /etc/docker/daemon.json
cat >> /etc/docker/daemon.json <<EOF
{
  "data-root": "/var/lib/docker",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "200m",
    "max-file": "5"
  },
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 655360,
      "Soft": 655360
    },
    "nproc": {
      "Name": "nproc",
      "Hard": 655360,
      "Soft": 655360
    }
  },
  "live-restore": true,
  "oom-score-adjust": -1000,
  "max-concurrent-downloads": 10,
  "max-concurrent-uploads": 10,
  "storage-driver": "overlay2",
  "storage-opts": ["overlay2.override_kernel_check=true"],
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": [
    "https://mirror.ccs.tencentyun.com/",
    "http://docker.mirrors.ustc.edu.cn"
  ],
  "insecure-registries" : [
    "mirror.ccs.tencentyun.com",
    "docker.mirrors.ustc.edu.cn"
  ]
}
EOF


systemctl enable docker

# sed -i 's|#oom_score = 0|oom_score = -999|' /etc/containerd/config.toml

# systemctl enable --now containerd

#sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ \ \ endpoint = [\"${REGISTRY_MIRROR}\"]"  /etc/containerd/config.toml
#sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"registry.aliyuncs.com\"]"  /etc/containerd/config.toml

#registry.cn-hangzhou.aliyuncs.com


systemctl daemon-reload
systemctl restart docker

# 安装 crictl
#CRICTL_VERSION="v1.20.0"
#wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz
#sudo tar zxvf crictl-$CRICTL_VERSION-linux-amd64.tar.gz -C /usr/local/bin
#rm -f crictl-$CRICTL_VERSION-linux-amd64.tar.gz
#crictl -v

# 安装 nfs-utils
# 必须先安装 nfs-utils 才能挂载 nfs 网络存储
sudo apt-get install -y nfs-utils
sudo apt-get install -y wget

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

## --------------------------
## 安装 kubeadm
## --------------------------

# 卸载旧版本
sudo apt-get remove -y kubelet kubeadm kubectl  --allow-change-held-packages

# 安装kubelet、kubeadm、kubectl
# 将 $k8s_version 替换为 kubernetes 版本号，例如 1.22.4-00
sudo apt-get install -y kubelet=${k8s_version} kubeadm=${k8s_version} kubectl=${k8s_version} --allow-change-held-packages
#sudo apt-mark hold kubelet kubeadm kubectl

#crictl config runtime-endpoint unix:///run/containerd/containerd.sock

# 重启 docker，并启动 kubelet
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet 

containerd --version
docker -v
kubelet --version
