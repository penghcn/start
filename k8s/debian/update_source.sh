#!/bin/sh

# debian 10.11
# sh update_source.sh http://192.168.8.71:29106

## --------------------------
## 更新apt源
## --------------------------
repo_base_url=$1

# 安装基本设施
sudo apt-get install -y apt-transport-https ca-certificates curl

# 配置debian源
mv /etc/apt/sources.list{,.bak}
cat > /etc/apt/sources.list <<EOF
deb $repo_base_url/repository/debian-buster buster main contrib non-free
deb-src $repo_base_url/repository/debian-buster/ buster main contrib non-free

deb $repo_base_url/repository/debian-buster buster-updates main contrib non-free
deb-src $repo_base_url/repository/debian-buster/ buster-updates main contrib non-free

deb $repo_base_url/repository/debian-buster buster-backports main

deb $repo_base_url/repository/debian-buster-sec/ buster/updates main contrib non-free
deb-src $repo_base_url/repository/debian-buster-sec/ buster/updates main contrib non-free
EOF

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

curl -fsSL $repo_base_url/repository/debian-docker-ce/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg

echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $repo_base_url/repository/debian-docker-ce \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list > /dev/null


#baseurl=http://mirrors.aliyun.com/kubernetes/apt/dists/kubernetes-xenial
# 配置K8S的源
curl -s $repo_base_url/repository/debian-k8s/doc/apt-key.gpg | apt-key add -

cat > /etc/apt/sources.list.d/kubernetes.list <<EOF 
deb $repo_base_url/repository/debian-k8s/ kubernetes-xenial main
EOF

sudo apt-get update
