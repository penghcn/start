#!/bin/bash

k8s_version=$1

local_ip=$(ip addr | grep eth0 | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')| awk '{print $1}'

if [[ ! -n $local_ip ]]; then
    local_ip=$(ip addr | grep bond0 | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}')| awk '{print $1}'
fi 

api_server=$2
api_server_ip=$3
mirror=$4

if [[ ! -n $api_server ]]; then
    echo "api_server 不能为空，如使用sh install_master_k8s.sh apiserver.k8s"
    exit 1;
fi

# 此时是初始化第一个master节点，默认取本机IP为api server的集群代理ip
if [[ ! -n $api_server_ip ]]; then
    api_server_ip=$local_ip
fi

if [[ ! -n $mirror ]]; then
    mirror="https://registry.cn-shanghai.aliyuncs.com"
    mirror="http://192.168.8.71:29108"
fi



# 参数
# pod cidr网段 默认172.16.1.0/24
# service cidr 默认172.31.0.0/16

export REGISTRY_MIRROR=$mirror
export APISERVER_IP=$api_server_ip
export APISERVER_NAME=$api_server
export POD_SUBNET=172.20.0.0/16
export SERVICE_SUBNET=172.31.0.0/16


#echo "192.168.8.121    apiserver.k8s" >> /etc/hosts
echo "${APISERVER_IP} ${APISERVER_NAME}" >> /etc/hosts
echo "nameserver 202.96.209.5" >> /etc/resolv.conf 

echo ""
echo "k8s安装版本$k8s_version，参数如下："
echo "镜像 $REGISTRY_MIRROR"
echo "本机IP $local_ip"
echo "api server集群代理ip $APISERVER_IP"
echo "api server内部域名 $APISERVER_NAME"
echo "pod cidr网段 $POD_SUBNET"
echo "service cidr网段 $SERVICE_SUBNET"

wait_seconds=5
echo "wait $wait_seconds s.."
for (( i = 0; i < $wait_seconds; i++ )); do
    echo -n "."
    sleep 1
done
echo ""
