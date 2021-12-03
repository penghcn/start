#!/bin/bash

# 升级master单节点
# sh upgrade_k8s.sh 1.20.5 1
# 脚本出错时终止执行
set -e

k8s_version=$1
is_first_master=$2

if [[ ! -n $k8s_version ]]; then
    k8s_version=1.20.5
fi

#yum install -y kubeadm-1.20.4 kubelet-1.20.4 kubectl-1.20.4 --disableexcludes=kubernetes

yum install -y kubeadm-$k8s_version kubelet-$k8s_version kubectl-$k8s_version --disableexcludes=kubernetes

if [[ ! -n $is_first_master ]]; then
    echo "升级其他节点 $(hostname)"
    kubeadm upgrade node
else
    echo "升级第一台master节点 $(hostname)"
    kubeadm version
    kubeadm upgrade plan
    kubeadm upgrade apply v$k8s_version -y
fi


#kubeadm upgrade node

kubectl drain $(hostname) --ignore-daemonsets

# 重启 docker，并启动 kubelet
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet 

kubectl uncordon $(hostname)

kubelet --version
containerd --version
crictl -v

kubectl get cm -o yaml -n kube-system kubeadm-config

kubectl get nodes -o wide 
