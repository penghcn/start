#!/bin/bash

# 

yum install -y rpcbind nfs-utils


cat <<EOF > /etc/exports
/root/nfs_root/ *(insecure,rw,sync,no_root_squash)
EOF

mkdir /root/nfs_root

systemctl enable rpcbind
systemctl enable nfs-server

systemctl start rpcbind
systemctl start nfs-server
exportfs -r


# showmount -e 192.168.8.123
# mkdir /root/nfs_root/test/www
# 