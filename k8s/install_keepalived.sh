#!/bin/bash

# yum install -y keepalived haproxy

yum install -y keepalived

# vi /etc/haproxy/haproxy.cfg

> /etc/keepalived/keepalived.conf

cat <<EOF > /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {     
    router_id lb02   
}

vrrp_instance VI_1 {
    state BACKUP
    interface bond0
    virtual_router_id 50
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 111111
    }
    virtual_ipaddress {
        192.168.8.120
    }
}
EOF

service keepalived start

ip addr
