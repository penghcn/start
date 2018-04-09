# git message格式推荐
[原文地址](https://github.com/penghcn/demo/blob/master/git/git-message.md)

参考 

[https://www.cnblogs.com/deng-cc/p/6322122.html](https://www.cnblogs.com/deng-cc/p/6322122.html)

[http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

## 简单示例
    git commit -m 'init:初始化'
    git commit -m 'feat(#user):添加登录功能'
    git commit -m 'opt(#user):优化登录提示功能'
    git commit -m 'fix(#user):修复登录异常功能'
    git commit -m 'test(#user):添加测试用户逻辑，记得删除，不推荐'
    git commit -m 'test(#user):删除测试用户逻辑'
    git commit -m 'refactor(#ALL):重构成dubbo项目'
    git commit -m 'docs:添加前端调用文档'
    git commit -m 'docs(#user):添加登录接口文档'