#!/bin/bash

# 安装master单节点
# sh install_master_k8s.sh apiserver.k8

# 先卸载kube
kubeadm reset -f
rm -rf ~/.kube/
rm -rf /etc/kubernetes/
rm -rf /etc/systemd/system/kubelet.service.d
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

if [[ ! -n $k8s_version ]]; then
    k8s_version=1.22.3
fi

# 一些配置或者环境变量
source ./init_cfg.sh $k8s_version,$1

# 安装 containerd和kubelet
sh install_kubelet.sh $k8s_version $repo_base_url


# 初始化master
sh init_master.sh $k8s_version $git_base_url
