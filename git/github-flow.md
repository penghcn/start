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

## III、试试看
    查看当前分支 git status
    从master分支创建some-bugfix-or-feature分支 git checkout -b some-bugfix-or-feature
    新建一个测试文件 vi test.md
    查看状态 git status
    提交修改到本地仓库 git add . && git commit -m 'test pull request'
    以防万一，再同步下远程master仓库 git pull origin master
    提交some分支到远程仓库 git push origin some-bugfix-or-feature -u

    在gitlab上选择some分支，右边有个“合并请求”按钮，发起pull request，可以修改标题、描述等
    注意 应该是 From some-bugfix-or-feature into master，最后提交合并请求，并通知项目负责人

    项目负责人会收到合并申请，合并或者拒绝

    自动触发，自动部署到测试环境、UAT环境，测试或者验收

    项目负责人手动触发，一键部署到生产环境，测试或者产品人员验收

    最后，把远程仓库的some-bugfix-or-feature分支和本地的some-bugfix-or-feature分支删掉 
    git checkout master && git branch -d some-bugfix-or-feature && git push origin --delete some-bugfix-or-feature

## IV、关于测试环境代码问题
    1、创建test分支，测试人员有合并权
    
    2、某开发人员基于master创建分支a，推到远程仓库a分支，个人或者多人在a分支上开发 
    某开发人员基于master创建分支b，推到远程仓库b分支，个人或者多人在b分支上开发 
    
    3、当要测试的时候 git fetch origin test 跟远程test对比下看是否冲突
    
    4、若无冲突，git push origin a ，再申请合并到test分支，自动部署到测试环境，比如 http://192.168.8.29:29032/dswbp
    
    5、若有冲突，自己从下列方案中选择一种
        a)、不合并到test，基于分支a打包a.war，自行手动部署到测试环境，webapps/a.war，访问地址比如：http://192.168.8.29:29032/a
        b)、
        基于本地a分支创建备份分支 git checkout -b a-test 
        a-test合并远程test分支，解决冲突 git pull origin test 
        a-test推送到远程git push origin a-test 
        a-test申请合并到test，自动部署到测试环境，比如 http://192.168.8.29:29032/dswbp
        测试完毕，删除本地和远程a-test分支

    6、测试完毕，a分支申请合并到master，走上线流程，参考上面

