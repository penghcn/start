## 1、git简单使用
[原文地址](https://github.com/penghcn/start/blob/master/git)

刚开始，不想看下面乱七八糟的，可以直接跳到最下面 **3、配置** 或 **4、git flow开发流**

### git clone
    git clone http://192.168.8.251/ds/test.git ## 这是最简单的用法，之后会提示输入用户名密码。也可以配置ssh key
### 强制覆盖更新本地
    git fetch --all && git reset --hard origin/master
### 提交到主干
    git add . && git status && git commit -a -m "提交的一些说明" && git push --all origin
    git add . && git status && git commit -a -m "update" && git push --all origin
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
    cd test
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

### .gitignore 配置参考
请特别注意，一定要配置.gitignore文件，配置参考 [gitignore.sample](./gitignore.sample)

### 换行符
团队统一规范代码的换行符为类UNIX格式，即LF

windows、mac系统都请配置

    ## 提交时转换为LF，检出时不转换
    ## 拒绝提交包含混合换行符的文件
    git config --global core.autocrlf input
    git config --global core.safecrlf true

eclipse、idea等ide开发工具配置换行符为LF，请自行百度谷歌，谢谢

mac下可以使用dos2unix批量转换某目录下的文件换行符为LF

    brew install dos2unix

    cd /target
    find . -name '*' -exec dos2unix {} \;

    或者只是转换指定的后缀文件
    find . -name '*.java' -exec dos2unix {} \;
    find . -name '*.xml' -exec dos2unix {} \;
    find . -name '*.pro*ies' -exec dos2unix {} \;

windows的git命令行工具也自带dos2unix，同样可以使用上面(或下面)命令，来转换当前目录下的所有文件，换行符改为LF

    find . -type f -exec dos2unix {} \;

## 4、git flow开发流
详见这里[git-flow.md](./git-flow.md)

## 5、git merge合并与冲突解决
详见这里[git-merge.md](./git-merge.md)

## 6、简单回退
详见这里[git-reset.md](./git-reset.md)
