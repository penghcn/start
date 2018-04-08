# git flow
[原文地址](https://github.com/penghcn/demo/blob/master/git/gitflow.md)

## 简单介绍

### master
### develop
### 其他
### 注意
    1、master 跟 develop是长期存在origin远程仓库里的
    2、其他类似feature、release之类的，不推荐push 到 origin
    3、即使release分支测试的时候要push到远程origin里，也请在测试完成后删掉远程仓库里的分支

## 权限
这里是指远程仓库gitlab的权限(guest、reporter、developer、master)
其实还有admin和owner(项目的创建人)
在gitlab创建项目，master分支默认是受保护的

### developer
    开发人员配置该角色
### master
    项目负责人配置该角色

    
## 开始一个新项目
[https://github.com/penghcn/demo/blob/master/git/getstart.md](https://github.com/penghcn/demo/blob/master/git/getstart.md) 

## 从老项目开始
### 从分支develop克隆项目
    cd /www/demo
    git clone -b develop http://192.168.8.251/ds/test.git
### 参考下文
[https://github.com/penghcn/demo/blob/master/git/getstart.md](https://github.com/penghcn/demo/blob/master/git/getstart.md) 