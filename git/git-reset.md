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

### 删除历史文件
参考 [https://help.github.com/articles/removing-sensitive-data-from-a-repository/](https://help.github.com/articles/removing-sensitive-data-from-a-repository/)

[https://gitlab.com/gitlab-org/gitlab-ce/issues/30093](https://gitlab.com/gitlab-org/gitlab-ce/issues/30093)

[https://gitlab.com/gitlab-org/gitlab-ce/issues/19376](https://gitlab.com/gitlab-org/gitlab-ce/issues/19376)

[https://www.cnblogs.com/shines77/p/3460274.html](https://www.cnblogs.com/shines77/p/3460274.html)

**使用git filter-branch，比较慢，推荐下面的bfg**

    获取所有远程分支
    git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
    git pull --all

    删除历史文件或文件夹data/release，注意文件路径前面不能有/
    git filter-branch --force --index-filter 'git rm --cached -r --ignore-unmatch data/release' --prune-empty --tag-name-filter cat -- --all

    推到远程仓库
    git push origin --force --all
    git push origin --force --tags
   
    清理和回收空间
    du -h .git
    git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
    git reflog expire --expire=now --all
    git gc --prune=now
    du -h .git

**更快更强的方法，推荐bfg**

[https://rtyley.github.io/bfg-repo-cleaner/](https://rtyley.github.io/bfg-repo-cleaner/)
    
    下载bfg-1.13.0.jar

    cd /tmp
    git clone --mirror  git@192.168.8.251:ds/ds-wbp.git
    java -jar /data/app/bfg-1.13.0.jar --strip-blobs-bigger-than 5M ds-wbp.git
    或者 java -jar /data/app/bfg-1.13.0.jar --delete-files *.war ds-wbp.git

    注意运行中的提示，可以看到类似如下日志，gitlab会用到里面的文件进行清理
    In total, 100 object ids were changed. Full details are logged here:
    /private/tmp/ds-wbp.git.bfg-report/2019-01-07/10-09-47

    cd ds-wbp.git
    du -hs 
    git reflog expire --expire=now --all && git gc --prune=now --aggressive
    git push
    du -hs 

    进入gitlab，设置，仓库，cleanup，上传上文提到的目录中的object-id-map.old-new.txt文件，清理

    最后，删除临时文件，rm -rf /tmp/ds-wbp.git



