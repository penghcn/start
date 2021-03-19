#!/bin/bash

# https://blog.51cto.com/3241766/2467865
# https://segmentfault.com/a/1190000016294818

# yum remove -y keepalived
yum install -y keepalived ipvsadm

# 在其他主机安装keepalived。若已安装在用，可参照修改配置兼容k8s master apiserver的负载均衡
# sh ka.sh 192.168.8.120 192.168.8.121,192.168.8.122,192.168.8.123 6443 bond0

vip=$1
ips=$2
port=$3
netId=$4

if [[ ! -n $vip ]]; then
    vip="192.168.8.120"
    echo "Set default VIP $vip"
fi
if [[ ! -n $netId ]]; then
    netId="eth0"
fi


iptail=$(echo $(ip addr | grep $netId  | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}') | awk '{print $1}'| awk -F '.' '{print $4}')


if [[ ! -n $iptail ]]; then
    iptail=$(date +%s)
fi

echo ""
echo "VIP $vip, router_id $iptail"
echo ""



arr=(${ips//\,/ })
rel_servers=""
tmp=""

for i in "${!arr[@]}"; do
    tmp="real_server ${arr[i]} $port { 
            weight 10
            TCP_CHECK {
                connect_timeout 5
                retry 3 
                delay_before_retry 1
                connect_port $port
            }
        }
        "
    rel_servers="$rel_servers$tmp"
done

#echo $rel_servers


conf=/etc/keepalived/keepalived.conf

> $conf 

cat <<EOF > $conf
! Configuration File for keepalived
global_defs {     
    router_id lb$iptail   
}

vrrp_instance VI_k8s {
    state BACKUP
    interface $netId
    virtual_router_id 50
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 111111@pass
    }
    virtual_ipaddress {
        $vip
    }
}

virtual_server $vip $port {
    delay_loop 6
    lb_algo wlc
    lb_kind DR
    protocol TCP  
    $rel_servers
}

EOF

service keepalived restart

cat $conf

ip a

ipvsadm
