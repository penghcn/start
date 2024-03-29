#!/bin/sh

# 安装master单节点
# sh install_master_k8s.sh apiserver.k8
# sh install_master_k8s.sh api.k8.fusjb,10.0.0.6,https://registry.cn-hangzhou.aliyuncs.com 1.22.4 aliyun https://github.com/penghcn/start

source ./init_cfg.sh 1.22.4,api.k8.fusjb,10.0.0.6,https://registry.cn-hangzhou.aliyuncs.com
sh install_kubelet.sh 1.22.4 aliyun

# 先卸载kube
#kubeadm reset -f
rm -rf ~/.kube/
rm -rf /etc/kubernetes/
#rm -rf /etc/systemd/system/kubelet.service.d
rm -rf /etc/systemd/system/kubelet.service
rm -rf /usr/bin/kube*
rm -rf /etc/cni
rm -rf /opt/cni
rm -rf /var/lib/etcd
rm -rf /var/etcd

# 脚本出错时终止执行
set -e

k8s_version=$2
repo_base_url=$3
git_base_url=$4

# if [[ ! -n $k8s_version ]]; then
#     k8s_version=1.22.4
# fi

# 一些配置或者环境变量
# source需要 /bin/bash，需要sudo dpkg-reconfigure dash 在界面中选择no
source ./init_cfg.sh $k8s_version,$1

# 安装 containerd和kubelet
sh install_kubelet.sh $k8s_version $repo_base_url


# 初始化master
sh init_master.sh $k8s_version $git_base_url
