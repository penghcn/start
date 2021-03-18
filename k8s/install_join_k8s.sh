#!/bin/bash

# 安装master或者worker其他节点
# sh install_join_k8s.sh

# 脚本出错时终止执行
set -e

k8s_version=1.20.4

# 一些配置或者环境变量
source ./init_cfg.sh $k8s_version $1 $2 $3


# 安装 containerd和kubelet
sh install_kubelet.sh $k8s_version

