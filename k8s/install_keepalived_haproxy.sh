#!/bin/bash

# keepalived haproxy
# https://www.jianshu.com/p/95cc6e875456

# yum remove -y keepalived haproxy
yum install -y keepalived haproxy

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
conf_ha=/etc/haproxy/haproxy.cfg

> $conf 
> $conf_ha 

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

cat <<EOF > $conf_ha
global 
    maxconn 51200 #最大连接数
    uid 99
    gid 99
    daemon #后台方式运行
    #quiet
    nbproc 1  #并发进程数


defaults  #默认部分的定义
        mode http #mode {http|tcp|health} 。
                  #http是七层模式，tcp是四层模式，health是健康检测返回OK
        #retries 2
        option redispatch
        option abortonclose
        timeout connect 5000ms   #连接超时
        timeout client 30000ms   #客户端超时
        timeout server 30000ms   #服务器超时
        #timeout check 2000      #心跳检测超时
        log 127.0.0.1 local0 err #[err warning info debug]
            #使用本机syslog服务的local3设备记录错误信息
        balance roundrobin

    # option httplog
    # option httpclose
    # option dontlognull
    # option forwardfor

 
listen admin_stats
        #定义一个名为status的部分，可以在listen指令指定的区域中定义匹配规则和后端服务器ip，
        bind 0.0.0.0:8888   # 定义监听的套接字
        option httplog
        stats refresh 30s   #统计页面的刷新间隔为30s
        stats uri /stats     #登陆统计页面是的uri
        stats realm Haproxy Manager
        stats auth admin:admin #登陆统计页面是的用户名和密码
        #stats hide-version  # 隐藏统计页面上的haproxy版本信息

listen tcp_test
        bind :12345
        mode tcp
        server t1 127.0.0.1:9000
        server t2 192.168.15.13:9000
        
listen zzs_dzfp_proxy:90
        mode http
        balance roundrobin   #轮询
        cookie LBN insert indirect nocache   
        option httpclose   
        server web01 192.168.15.12:9000 check inter 2000 fall 3 weight 20  
        server web02 192.168.15.13:9000 check inter 2000 fall 3 weight 20
EOF

service keepalived restart
service haproxy restart

cat $conf
cat $conf_ha

ip a

