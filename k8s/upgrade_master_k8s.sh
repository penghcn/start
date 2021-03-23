#!/bin/bash

# 升级master单节点
# sh upgrade_master_k8s.sh 1.20.5
# 脚本出错时终止执行
set -e

k8s_version=$1

if [[ ! -n $k8s_version ]]; then
    k8s_version=1.20.5
fi


yum install -y kubeadm-$k8s_version kubelet-$k8s_version kubectl-$k8s_version --disableexcludes=kubernetes
kubeadm version
kubeadm upgrade plan
kubeadm upgrade node v$k8s_version -y

# 重启 docker，并启动 kubelet
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet 

kubelet --version
containerd --version
crictl -v
