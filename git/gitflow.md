# git flow
[原文地址](https://github.com/penghcn/demo/blob/master/git/gitflow.md)

## I、简单介绍
先参考其他文档 

[https://www.cnblogs.com/cnblogsfans/p/5075073.html](https://www.cnblogs.com/cnblogsfans/p/5075073.html)

[https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/git-flow](https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/git-flow)

### 工具
    mac或者linux推荐终端命令使用git flow
    macOS安装：brew install git-flow
    windows 推荐使用图形工具 

1、source tree图形工具 [https://www.sourcetreeapp.com](https://www.sourcetreeapp.com)

2、eclipse 原生支持，但需要开启：help，install new ，搜索git flow 安装重启即可

3、推荐git commit messege格式 [https://www.cnblogs.com/deng-cc/p/6322122.html](https://www.cnblogs.com/deng-cc/p/6322122.html)
   
    git commit -m 'init:初始化'
    git commit -m 'feat(#user):添加登录功能'
    git commit -m 'opt(#user):优化登录提示功能'
    git commit -m 'fix(#user):修复登录异常功能'
    git commit -m 'test(#user):添加测试用户逻辑，记得删除，不推荐'
    git commit -m 'test(#user):删除测试用户逻辑'
    git commit -m 'refactor(#ALL):重构成dubbo项目'
    git commit -m 'docs:添加前端调用文档'
    git commit -m 'docs(#user):添加登录接口文档'
 

### master
### develop
### 其他
### 注意
    1、master 跟 develop分支是长期存在origin远程仓库里的
    2、其他类似feature、release分支，不推荐push 到 origin远程仓库里
    3、即使release分支测试的时候要push到远程origin里，也请在测试完成后删掉远程仓库里的分支

## II、权限
    这里是指远程仓库gitlab的权限(guest、reporter、developer、master)
    其实还有admin和owner(项目的创建人)
    在gitlab创建项目，master分支默认是受保护的

### developer
    开发人员配置该角色
### master
    项目负责人配置该角色

    
## III、开始一个新项目
[https://github.com/penghcn/demo/blob/master/git/getstart.md](https://github.com/penghcn/demo/blob/master/git/getstart.md) 

## IV、从老项目开始
### 1、从分支develop克隆项目
    cd /www/demo
    git clone -b develop http://192.168.8.251/ds/test.git
### 2、然后参考下文
[https://github.com/penghcn/demo/blob/master/git/getstart.md](https://github.com/penghcn/demo/blob/master/git/getstart.md) 

## V、冲突解决
待更新...