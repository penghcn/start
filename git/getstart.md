## 开始一个新项目
### 开始前
推荐使用git flow工具。source tree图形工具 [https://www.sourcetreeapp.com](https://www.sourcetreeapp.com)

推荐git commit messege格式 [https://www.cnblogs.com/deng-cc/p/6322122.html](https://www.cnblogs.com/deng-cc/p/6322122.html)
    
    项目负责人m，开发人员a1、a2，测试人员t1

基本流程：

    负责人分配任务、开发人员领各自任务
    开发人员 基于任务创建feature分支、feature自测
    开发人员 结束feature，合并到develop。若有冲突，跟其他组员沟通后，先rebase 再merge合并到develop
    负责人  创建release分支
    测试人员(或者持续集成工具、负责人、开发人员)基于release代码，发布到测试(或者UAT、灰度)环境。release分支充分测试、修改结束后，代表可以发布到正式生产环境
    负责人结束release分支，合并到develop和master，并打上tag
    (可选) 开发人员 对于未结束的feature分支，merge合并此时develop的最新代码

### 1、项目负责人在gitlab上创建新项目test
    项目选择private类型
### 2、项目负责人在本地机器上克隆该项目
    cd /www/demo
    git clone http://192.168.8.251/ds/test.git
    输入用户名密码
    cd test
    git flow init
    都默认回车就好了
    git push --all origin
### 2.1、项目负责人对项目的基本操作(可选)
    写一些说明、构建文件，比如readme.md、build.gradle等
    基本框架的一些代码，比如spring mvc、mybatis等

### 3、其他开发人员开始干活了，推荐从分支develop上clone项目
    cd /www/demo
    git clone -b develop http://192.168.8.251/ds/test.git
    输入用户名密码
    git flow init
    都默认回车就好了

#### 3.1、开发人员a1开始一个小功能，比如用户登录模块
    git flow feature start f-user-login-module

开始写代码。。。写好了，提交到本地仓库
    
    git add . && git status && git commit -m "feat(#user):加了用户登录模块"
自测完毕，结束这个功能分支。以下命令，会删除该分支，切换到develop，把代码合并到develop分支
    
    git flow feature finish f-user-login-module
提交到远程仓库的develop分支上。若有冲突，自行解决或者与其他组员沟通后解决

    git push origin develop

#### 3.2、开发人员a2也开始一个小功能，比如商户添加、查询
    git flow feature start f-mch-add
    git add . && git status && git commit -am "feat(#mch):加了商户添加模块"
    git flow init feature finish f-mch-add
    git push origin develop

    git flow feature start f-mch-qry
    git add . && git status && git commit -am "feat(#mch):加了商户查询接口"
    git flow init feature finish f-mch-qry
    git push origin develop

#### 3.3、项目负责人创建release/1.0.0分支，提交测试
    git flow release start 1.0.0
若测试中，还需要进行修改，可以发布该分支到远程仓库，大家一起针对改分支来修改。
注意，尽量在feature分支开发时充分自测，在release分支测试时尽量做到小改动

    git flow release publish 1.0.0

其他开发人员基于release/1.0.0来修改，再提交到改分支上

    git flow release pull 1.0.0
    git add . && git status && git commit -am "test:修复登录异常" 
    git add . && git status && git commit -am "opt:优化排序" && git push origin release/1.0.0

结束release/1.0.0分支。以下命令，会删除release/1.0.0，代码会merge合并到master和develop分支

    git flow release finish 1.0.0
#### 3.4、项目负责人提交到远程master和develop分支，并tag
    git push --all origin && git push --tags
    
#### 3.5、(可选)生产版本发现了问题，需紧急修复，项目负责人启动hotfix分支
    git flow hotfix start 1.0.1 1.0.0
    git add . && git status && git commit -am "fix:修复登录提示异常" 
    git flow hotfix finish 1.0.1
    git push --all origin && git push --tags
