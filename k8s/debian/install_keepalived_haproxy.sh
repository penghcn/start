#!/bin/bash

# keepalived haproxy
# https://www.jianshu.com/p/95cc6e875456
# https://github.com/haproxy/haproxy/blob/master/examples/socks4.cfg

# keepalived默认日志
# tail -f /var/log/messages

# yum remove -y keepalived haproxy
yum install -y keepalived haproxy

# 在其他主机安装keepalived。若已安装在用，可参照修改配置兼容k8s master apiserver的负载均衡
# sh ka.sh 192.168.8.120 192.168.8.121,192.168.8.122,192.168.8.123 6443 bond0

vip=$1
ips=$2
port=$3
netId=$4

# http://192.168.8.120:8888/stats
ha_port=8888 # haproxy 的web页面端口
ha_user=admin
ha_pass=admin-ha

if [[ ! -n $port ]]; then
    echo "sh ka.sh 192.168.8.120 192.168.8.121,192.168.8.122,192.168.8.123 6443 bond0"
    exit
fi
if [[ ! -n $netId ]]; then
    netId="eth0"
fi


iptail=$(echo $(ip a | grep $netId  | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}') | awk '{print $1}'| awk -F '.' '{print $4}')


if [[ ! -n $iptail ]]; then
    iptail=$(date +%s)
fi

echo ""
echo "VIP $vip, router_id $iptail"
echo ""



arr=(${ips//\,/ })
tmp=""
ha_listen_servers=""

ha_listen_servers="
listen k8s-tcp-$port
        mode tcp
        bind *:$port

        option tcplog
        maxconn 20000
        option tcp-check
        "
for i in "${!arr[@]}"; do
    index=$[$i+1]
    tmp="server k8s-m$index-${arr[i]} ${arr[i]}:$port weight 10 check inter 2s maxconn 10000
        "
    ha_listen_servers="$ha_listen_servers$tmp"
done

# https 必须推荐tcp绑定，不用额外加载证书
# ha_listen_servers="$ha_listen_servers
# listen k8s-http-$port
#         mode http
#         balance roundrobin   
#         cookie LBN insert indirect nocache   
#         option httpclose   
#         "

# for i in "${!arr[@]}"; do
#     index=$[$i+1]
#     tmp="server k8s_http_$index ${arr[i]}:$port check inter 2000 fall 3 weight 20
#         "
#     ha_listen_servers="$ha_listen_servers$tmp"
# done
#echo $rel_servers


conf=/etc/keepalived/keepalived.conf
conf_ha=/etc/haproxy/haproxy.cfg
chk_ha=/etc/keepalived/chk_haproxy.sh

> $conf 
> $conf_ha 

cat <<EOF > $conf
! Configuration File for keepalived
global_defs {     
    router_id lb$iptail   
}

vrrp_script chk_haproxy {
    script "$chk_ha"
    interval 2   #每两秒进行一次
    timeout 2
    fall 3
    weight -20   #如果script中的指令执行失败，vrrp_instance的优先级会减少10个点
}

vrrp_instance VI_HAPROXY {
    state BACKUP
    interface $netId
    virtual_router_id 50
    priority $iptail
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 111111@pass
    }
    track_script {
        chk_haproxy
    }
    virtual_ipaddress {
        $vip
    }
}

EOF

cat <<EOF > $chk_ha
#!/bin/bash
LOGFILE="/var/log/messages"
status=\$(ps aux|grep haproxy | grep -v grep | grep -v bash | wc -l)
#echo "\$(date -R), chk_haproxy status: \${status}" >> \$LOGFILE

if [ "\${status}" = "0" ]; then
    echo "\$(date -R), chk_haproxy status: fail" >> \$LOGFILE
    service haproxy restart

    status2=\$(ps aux|grep haproxy | grep -v grep | grep -v bash |wc -l)

    if [ "\${status2}" = "0"  ]; then
        service keepalived stop
    fi
fi

EOF
chmod +x $chk_ha

cat <<EOF > $conf_ha
global 
    maxconn 51200 #最大连接数
    uid 99
    gid 99
    daemon #后台方式运行
    #quiet
    nbproc 1  #并发进程数


defaults  #默认部分的定义
        mode tcp #mode {http|tcp|health} 。
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

 
listen admin-stats
        #定义一个名为status的部分，可以在listen指令指定的区域中定义匹配规则和后端服务器ip，
        mode http
        bind 0.0.0.0:$ha_port  

        maxconn 10
        option httplog

        stats refresh 15s   #统计页面的刷新间隔为15s
        stats uri /stats     #登陆统计页面是的uri
        stats realm Haproxy Manager
        stats auth $ha_user:$ha_pass #登陆统计页面是的用户名和密码
        stats admin if TRUE # 可管理节点，上线、下线
        #stats hide-version  # 隐藏统计页面上的haproxy版本信息
        #stats enable
        stats show-node

$ha_listen_servers
        
EOF

service keepalived restart
service haproxy restart

echo ""
echo "cat $conf"
cat $conf

echo "cat $chk_ha"
cat $chk_ha

echo "cat $conf_ha"
cat $conf_ha

echo "sleep 5s, ip a"
sleep 5
ip a

