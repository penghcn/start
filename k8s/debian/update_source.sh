#!/bin/sh

# debian 10.11
# sh update_source.sh http://192.168.8.71:29106

## --------------------------
## 更新apt源
## --------------------------
repo_base_url=$1

url_debian=$repo_base_url/repository/debian-buster
url_debian_sec=$repo_base_url/repository/debian-buster-sec
url_debian_docker_ce=$repo_base_url/repository/debian-docker-ce
url_debian_k8s=$repo_base_url/repository/debian-k8s

# url_debian=http://mirrors.aliyun.com/debian
# url_debian_sec=http://mirrors.aliyun.com/debian-security
# url_debian_docker_ce=http://mirrors.aliyun.com/docker-ce/linux/debian/
# url_debian_k8s=http://mirrors.aliyun.com/kubernetes/apt/

# 安装基本设施
sudo apt-get install -y apt-transport-https ca-certificates curl

# 配置debian源
# http://mirrors.aliyun.com/debian
# http://mirrors.aliyun.com/debian-security

mv /etc/apt/sources.list{,.bak}
cat > /etc/apt/sources.list <<EOF
deb $url_debian buster main contrib non-free
deb-src $url_debian/ buster main contrib non-free

deb $url_debian buster-updates main contrib non-free
deb-src $url_debian/ buster-updates main contrib non-free

deb $url_debian buster-backports main

deb $url_debian_sec/ buster/updates main contrib non-free
deb-src $url_debian_sec/ buster/updates main contrib non-free
EOF

# debian 11
# cat > /etc/apt/sources.list <<EOF
# deb http://mirrors.aliyun.com/debian bullseye main contrib non-free
# deb-src http://mirrors.aliyun.com/debian/ bullseye main contrib non-free

# deb http://mirrors.aliyun.com/debian bullseye-updates main contrib non-free
# deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main contrib non-free

# deb http://mirrors.aliyun.com/debian bullseye-backports main

# deb http://mirrors.aliyun.com/debian-security bullseye/updates main contrib non-free
# deb-src http://mirrors.aliyun.com/debian-security bullseye/updates main contrib non-free
# EOF

sudo apt-get update

# debian 10 默认关闭了 cgroup hugetlb 可以通过更新内核开启
# debian 10 升级内核
sudo apt -t buster-backports  install linux-image-amd64

# reboot

uname -r
# 重启后，查看cgroup hugetlb
grep HUGETLB /boot/config-$(uname -r)    

# 配置docker-ce的源
sudo apt-get -y install ca-certificates curl gnupg lsb-release

curl -fsSL $url_debian_docker_ce/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $url_debian_docker_ce \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list > /dev/null


#baseurl=http://mirrors.aliyun.com/kubernetes/apt/dists/kubernetes-xenial
# 配置K8S的源
curl -s $url_debian_k8s/doc/apt-key.gpg | apt-key add -

cat > /etc/apt/sources.list.d/kubernetes.list <<EOF 
deb $url_debian_k8s/ kubernetes-xenial main
EOF


