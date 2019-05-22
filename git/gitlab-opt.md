# gitlab 调优
[参考](https://blog.csdn.net/ouyang_peng/article/details/84066417)

## 减少进程数
    vi /etc/gitlab/gitlab.rb

    unicorn['worker_processes'] = 5
    unicorn['worker_timeout'] = 60

    unicorn['worker_memory_limit_min'] = "200 * 1 << 20"
    unicorn['worker_memory_limit_max'] = "300 * 1 << 20"

    官方建议cpu核数+1，超时60s
    200人左右规模，建议4核cpu、8GB内存

    配置生效
    gitlab-ctl reconfigure

    重启
    gitlab-ctl restart

## 减少sidekiq并发数
    sidekiq['concurrency'] = 8

## 备份
    gitlab-rake gitlab:backup:create