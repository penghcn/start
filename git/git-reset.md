# git 回退
[上一篇](https://github.com/penghcn/start/git) 
[原文地址](https://github.com/penghcn/start/blob/master/git/git-reset.md)

参考 

[http://gitbook.liuhui998.com/4_9.html](http://gitbook.liuhui998.com/4_9.html)

## 简单回退
develop分支，回退到本地仓库的某个历史提交版本，比如commit id为 d373d3c

    git checkout develop
    git reset --hard d373d3c

若同时需要覆盖远程仓库，则强制提交

    git push origin develop –-force

## 撤销
#### 撤销最近一次提交
    git revert HEAD

#### 撤销上上次提交
    git revert HEAD^

#### 修改最近的提交message
    git commit --amend