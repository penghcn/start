## 1、git简单使用
### git clone
    git clone git@10.0.0.0:docker_conf
    git clone git123:docker_conf
### git 强制覆盖更新本地
    git fetch --all && git reset --hard origin/master
### git 提交到主干
    git add . && git status && git commit -a -m "提交的一些说明" && git push --all origin
### git 查看、创建分支 test
    git branch
    git branch test
    git branch development
    git branch release    
    git branch hotfix
### git 切换分支
    git checkout test
    git checkout master
### git 合并分支
#### 把development合并到master
    git checkout master
    git merge development
### git 删除分支
    git branch -d test-3.0.1
    git branch -D hotfix-3.0.5    
    
## 2、git服务器搭建
### docker gitolite
    sudo docker run -ti -h 'dc_git' -p 40022:22 -v /etc/localtime:/etc/localtime:ro -v /data:/data -w /data/docker_conf/git --name=dc_git pengh/gitolite:0.2.0 /bin/bash
### gitlab
