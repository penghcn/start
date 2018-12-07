# github flow
[原文地址](https://github.com/penghcn/start/blob/master/git/github-flow.md)

## I、简单介绍
先参考其他文档 

[http://www.cnblogs.com/sloong/p/5868292.html](http://www.cnblogs.com/sloong/p/5868292.html)

### master分支
    项目负责人、admin才能合并该远程分支。其他人只有查看、下载权、发起Pull Request，不能提交

### 其他分支
    开发人员每次从master为基础创建新的功能分支，push 到 远程仓库
    
### 流程
    1、master分支时常保持可以部署的状态
    2、进行新的作业时要从master 分支创建新的分支，新分支名称要具有描述性
    3、新分支随时push到远程仓库
    4、需要帮助、反馈，或者新分支已经准备merge合并时，创建Pull Request，以Pull Request进行交流
    5、让其他开发者进行审查，确认作业完成后，负责人将master分支进行合并(合并的代码一定要测试)
    6、与master分支合并后，自动部署，自动测试
    7、删除远程和本地的功能分支

## II、权限
    这里是指远程仓库gitlab的权限(guest、reporter、developer、master)
    其实还有admin和owner(项目的创建人)
    在gitlab创建项目，master分支默认是受保护的

### master权限
    项目负责人配置该角色

## III、来一个项目
[start-project.md](./start-project.md) 

## IV、冲突解决
推荐git rebase解决提交冲突 [参考这里](https://blog.csdn.net/wh_19910525/article/details/7554489)， 或者使用eclipse等图形工具比较

详见这里[git-merge.md](./git-merge.md)


