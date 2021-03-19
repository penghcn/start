#!/bin/bash

# 服务节点服务器绑定VIP ，并抑制响应 VIP 的 ARP 请求
# sh realserver.sh 192.168.8.120

conf=/etc/init.d/realserver

SNS_VIP=$1
if [[ ! -n $SNS_VIP ]]; then
    echo "Usage: sh realserver.sh 192.168.8.120"
    exit 1
fi

> $conf

cat <<EOF > $conf
#!/bin/bash
source /etc/rc.d/init.d/functions

case "\$1" in

start)
    ifconfig lo:0 $SNS_VIP netmask 255.255.255.255 broadcast $SNS_VIP
    /sbin/route add -host $SNS_VIP dev lo:0
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
    sysctl -p >/dev/null 2>&1
    echo "RealServer Start OK"
    ;;
stop)
    ifconfig lo:0 down
    route del $SNS_VIP >/dev/null 2>&1
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
    echo "RealServer Stoped"
    ;;
restart|reload)
    cd "\$CWD"
    \$0 stop
    sleep 2
    \$0 start
    ;;
*)
    echo "Usage: \$0 {start|stop|restart}"
    exit 1
esac
exit 0
EOF

cat $conf

chmod u+x $conf
service realserver restart
systemctl daemon-reload

ip a
