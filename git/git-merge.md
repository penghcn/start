# git merge
[上一篇](https://github.com/penghcn/start/blob/master/git/git-flow.md) 
[原文地址](https://github.com/penghcn/start/blob/master/git/git-merge.md)

参考 

[Git 工具 - 高级合并](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%AB%98%E7%BA%A7%E5%90%88%E5%B9%B6)

[换行符转换](https://blog.csdn.net/maikforever/article/details/17630353)

[Git 换行符](https://segmentfault.com/q/1010000011799577)

## 中断合并
    git merge feature/test1
    Auto-merging hello.java
    CONFLICT (content): Merge conflict in hello.java
    Automatic merge failed; fix conflicts and then commit the result.
    ...

有时冲突文件太多，没办法(或不想立即)一个个手动解决。完全可以通过 git merge --abort 来简单地退出合并

    git status -sb
    git merge --abort
    git status -sb

当然，也可以使用回退来处理，参考这里 [git-reset.md](./git-reset.md)

## 单边合并
    git merge -Xtheirs 或者 git merge -Xours

#### 若有冲突，使用对方文件覆盖本地文件
feature/test1合并到develop。使用feature/test1分支 **覆盖** 合并到develop
    
    git checkout develop
    git merge -Xtheirs feature/test1

#### 误删文件夹，还原到某个提交点，相当于创建新文件，不会冲突
    git checkout 3e48555 /www/fuiou/ds/o2o/o2o-mch-web/src/main/java/com/fuiou/ds/o2o/data