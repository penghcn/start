#!/bin/bash

# 在每一台master和worker节点上都执行

if [[ ! -n $1 ]]; then
    echo "需要设置的主机名不能为空，如使用sh init_host.sh k8s-m1"
    exit 1;
fi
    

# 查看操作系统 
cat /etc/redhat-release && uname -rs

echo ""
# 检查cpu核数 
lscpu

echo ""
# 永久修改主机名，如第1个master节点命名k8s-m1 
hostnamectl set-hostname $1
hostnamectl 
echo "127.0.0.1   $(hostname)" >> /etc/hosts

echo ""
# 检查网络设置
ip route show
ip address

# 注销退出再登录
echo "请注销退出，再重新登录"