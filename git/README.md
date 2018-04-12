## 1、git简单使用
[原文地址](https://github.com/penghcn/start/blob/master/git)
### git clone
    git clone git@10.0.0.0:docker_conf
    git clone git123:docker_conf
### 强制覆盖更新本地
    git fetch --all && git reset --hard origin/master
### 提交到主干
    git add . && git status && git commit -a -m "提交的一些说明" && git push --all origin
    git push --all origin && git push --tags
    
### 查看、创建分支 test
    git branch
    git branch develop
    git branch release 
    git branch hotfix
### 提交分支
    git push origin develop
### 切换分支
    git checkout test
    git checkout master
### 合并分支
#### 把development合并到master
    git checkout master
    git merge develop
### 删除分支
    git branch -a
    git branch -d test/3.0.1 && git push origin --delete test/3.0.1
    git branch -D hotfix/3.0.5    

### 删除tag
    git tag -d 3.0.1  && git push origin --delete tag 3.0.1
    git tag
    
## 2、git服务器搭建
### docker gitolite
    sudo docker run -ti -h 'dc_git' -p 40022:22 -v /etc/localtime:/etc/localtime:ro -v /data:/data -w /data/docker_conf/git --name=dc_git pengh/gitolite:0.2.0 /bin/bash
### gitlab
#### 新项目
    git clone http://192.168.8.251/ds/test.git
    cd box-contract
    touch README.md
    git add README.md
    git commit -m "add README"
    git push -u origin master

#### 老项目提交到远程的空仓库
    cd existing_folder
    git init
    git remote add origin http://192.168.8.251/ds/test.git
    git add .
    git commit -m "Initial commit"
    git push -u origin master

#### 切换远程仓库
    cd existing_repo
    git remote rename origin old-origin
    git remote add origin http://192.168.8.251/ds/test.git
    git push -u origin --all
    git push -u origin --tags

## 3、配置
### 查看配置，系统、用户、某项目本地仓库
    git config --system  --list
    git config --global  --list
    git config --local  --list

### 设置本地用户
    git config --global user.name "pengh-mbp"
    git config --global user.email "peng@test.com"

### 换行符
团队统一规范代码的换行符为类unix格式，即LF。图形工具安装的时候选择“不自动转换，保持原样”，若选错，可以使用下面命令修改
    
    git config --global core.autocrlf false
    git config --global core.safecrlf true
