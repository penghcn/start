#!/bin/bash

# 参考 https://kuboard.cn/install/install-k8s.html#%E7%A7%BB%E9%99%A4worker%E8%8A%82%E7%82%B9%E5%B9%B6%E9%87%8D%E8%AF%95
# 使用 
# 或者腾讯云 
# https://mirror.ccs.tencentyun.com
# https://registry.cn-shanghai.aliyuncs.com https://registry.cn-hangzhou.aliyuncs.com
# export REGISTRY_MIRROR=https://registry.cn-shanghai.aliyuncs.com
# curl -sSL https://kuboard.cn/install-script/v1.20.x/install_kubelet.sh | sh -s 1.20.4


# sh install_kubelet.sh 1.20.4  http://192.168.8.71:29106

# 在 master 节点和 worker 节点都要执行

# 安装 containerd
# 参考文档如下
# https://github.com/containerd/containerd
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd
k8s_version=$1
repo_base_url=$2

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
yum remove -y containerd.io

# 设置 yum repository
yum install -y yum-utils device-mapper-persistent-data lvm2

# 配置centos7的yum源
cat <<EOF > /tmp/centos7.repo
[base]
name=Nexus
baseurl=$repo_base_url/repository/centos7/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/RPM-GPG-KEY-CentOS-7
 
[updates]
name=CentOS-\$releasever-Updates-custom
baseurl=$repo_base_url/repository/centos7/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/RPM-GPG-KEY-CentOS-7
 
[extras]
name=CentOS-\$releasever-Extras-custom
baseurl=$repo_base_url/repository/centos7/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/RPM-GPG-KEY-CentOS-7
 
[centosplus]
name=CentOS-\$releasever-Plus-custom
baseurl=$repo_base_url/repository/centos7/\$releasever/centosplus/\$basearch/
gpgcheck=1
enabled=0
gpgkey=$repo_base_url/repository/centos7/RPM-GPG-KEY-CentOS-7
EOF


# 配置docker-ce的yum源
cat <<EOF > /tmp/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=$repo_base_url/repository/centos7/\$releasever/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo $basearch
baseurl=$repo_base_url/repository/centos7/\$releasever/debug-\$basearch/stable
enabled=0
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=$repo_base_url/repository/centos7/\$releasever/source/stable
enabled=0
gpgcheck=1
gpgkey=$repo_base_url/repository/centos7/gpg
EOF

# yum-config-manager --add-repo http://192.168.8.251/open/doc/raw/master/k8s/centos7.repo
yum-config-manager --add-repo /tmp/centos7.repo
yum-config-manager --add-repo /tmp/docker-ce.repo

# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# yum-config-manager --add-repo https://mirror.ccs.tencentyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装 containerd
#yum install -y containerd.io-1.4.3
yum install -y containerd.io

mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml

sed -i "s#k8s.gcr.io#registry.aliyuncs.com/k8sxio#g"  /etc/containerd/config.toml
sed -i '/containerd.runtimes.runc.options/a\ \ \ \ \ \ \ \ \ \ \ \ SystemdCgroup = true' /etc/containerd/config.toml
sed -i "s#https://registry-1.docker.io#${REGISTRY_MIRROR}#g"  /etc/containerd/config.toml

#registry_mirrors=${REGISTRY_MIRROR}
#arr=(${registry_mirrors//\:\/\// })
#echo ${arr[1]}
# 私有仓库也加入代理
mirrors2=$(echo ${REGISTRY_MIRROR} | awk -F '://' '{ print $2}' )

# sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ \ \ endpoint = [\"http://192.168.8.71:29108\"]"  /etc/containerd/config.toml
# sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"192.168.8.71:29108\"]"  /etc/containerd/config.toml

sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ \ \ endpoint = [\"${REGISTRY_MIRROR}\"]"  /etc/containerd/config.toml
sed -i "/registry.mirrors]/a\ \ \ \ \ \ \ \ [plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"${mirrors2}\"]"  /etc/containerd/config.toml



systemctl daemon-reload
systemctl enable containerd
systemctl restart containerd

# 安装 crictl
#CRICTL_VERSION="v1.20.0"
#wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$CRICTL_VERSION/crictl-$CRICTL_VERSION-linux-amd64.tar.gz
#sudo tar zxvf crictl-$CRICTL_VERSION-linux-amd64.tar.gz -C /usr/local/bin
#rm -f crictl-$CRICTL_VERSION-linux-amd64.tar.gz
#crictl -v

# 安装 nfs-utils
# 必须先安装 nfs-utils 才能挂载 nfs 网络存储
yum install -y nfs-utils
yum install -y wget

# 关闭 防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭 SeLinux
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

# 关闭 swap
swapoff -a
yes | cp /etc/fstab /etc/fstab_bak
cat /etc/fstab_bak |grep -v swap > /etc/fstab

# 配置K8S的yum源
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
baseurl=$repo_base_url/repository/centos7-k8s
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
       http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 卸载旧版本
yum remove -y kubelet kubeadm kubectl

# 安装kubelet、kubeadm、kubectl
# 将 $k8s_version 替换为 kubernetes 版本号，例如 1.20.1
yum install -y kubelet-${k8s_version} kubeadm-${k8s_version} kubectl-${k8s_version}

crictl config runtime-endpoint /run/containerd/containerd.sock

# 重启 docker，并启动 kubelet
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet 

containerd --version
crictl -v
kubelet --version
