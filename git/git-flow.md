# git flow
[原文地址](https://github.com/penghcn/start/blob/master/git/git-flow.md)

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

3、git messege格式 [https://github.com/penghcn/demo/blob/master/git/git-message.md](https://github.com/penghcn/demo/blob/master/git/git-message.md)
   
    git commit -m 'init:初始化'
    git commit -m 'feat(#user):添加登录功能'
    git commit -m 'opt(#user):优化登录提示功能'
    git commit -m 'fix(#user):修复登录异常功能'
    git commit -m 'test(#user):添加测试用户逻辑，记得删除，不推荐'
    git commit -m 'test(#user):删除测试用户逻辑'
    git commit -m 'refactor(#ALL):重构成dubbo项目'
    git commit -m 'docs:添加前端调用文档'
    git commit -m 'docs(#user):添加登录接口文档'
 

### master分支
    项目负责人、admin才能修改该远程分支。其他人只有查看、下载权，不能提交
### develop分支
    开发人员可以修改该远程分支
### 其他
    feature分支
        开发人员可以修改，不推荐提交发布到远程仓库
    release分支
        项目负责人创建，push到远程仓库以方便下载测试、修改
        测试人员下载测试
        开发人员下载修改、提交
        项目负责人创建结束、删除本地和远程仓库
### 注意
    1、master 跟 develop分支是长期存在origin远程仓库里的
    2、其他类似feature、release分支，不推荐push 到 origin远程仓库里
    3、即使release分支测试的时候要push到远程origin里，也请在测试完成后删掉远程仓库里的分支

## II、权限
    这里是指远程仓库gitlab的权限(guest、reporter、developer、master)
    其实还有admin和owner(项目的创建人)
    在gitlab创建项目，master分支默认是受保护的

### developer权限
    开发人员配置该角色
### master权限
    项目负责人配置该角色

## III、来一个项目
[get-start.md](./get-start.md) 

## IV、冲突解决
git diff 查看不同，或者使用eclipse等图形工具比较

待更新...


