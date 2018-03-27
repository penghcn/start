## 1、git简单使用
### git clone
    git clone git138:docker_conf
### git 强制覆盖更新本地
    git fetch --all && git reset --hard origin/master
### git 提交到主干
    git add . && git status && git commit -a -m "..." && git push --all origin

## git服务器搭建
### docker gitolite
    sudo docker run -ti -h 'dc_git' -p 40022:22 -v /etc/localtime:/etc/localtime:ro -v /data:/data -w /data/docker_conf/git --name=dc_git pengh/gitolite:0.2.0 /bin/bash
