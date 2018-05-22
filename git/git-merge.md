# git merge
[上一篇](https://github.com/penghcn/start/blob/master/git/git-flow.md) 
[原文地址](https://github.com/penghcn/start/blob/master/git/git-merge.md)

参考 

[Git 工具 - 高级合并](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%AB%98%E7%BA%A7%E5%90%88%E5%B9%B6)

[换行符转换](https://blog.csdn.net/maikforever/article/details/17630353)

[Git 换行符](https://segmentfault.com/q/1010000011799577)

## 单边合并
    git merge -Xtheirs 或者 git merge -Xours

#### 若有冲突，使用对方文件覆盖本地文件
feature/test1合并到develop。使用feature/test1分支 **覆盖** 合并到develop
    
    git checkout develop
    git merge -Xtheirs feature/test1