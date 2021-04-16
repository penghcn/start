# gitlab 调优
[参考](https://blog.csdn.net/ouyang_peng/article/details/84066417)

## 减少进程数
    vi /etc/gitlab/gitlab.rb

    gitlab_rails['time_zone'] = 'Asia/Shanghai'
    
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

## 备份、还原
    ## 备份
    gitlab-rake gitlab:backup:create

    ## 默认备份目录/var/opt/gitlab/backups/
    ## 还原 同版本才能还原
    gitlab-rake gitlab:backup:restore BACKUP=1569390992_2019_09_25_12.3.1-ee
    gitlab-rake gitlab:backup:restore BACKUP=1615896882_2021_03_16_12.3.1-ee

## 安装、卸载、升级
    ## 查看版本
    cat /opt/gitlab/embedded/service/gitlab-rails/VERSION
    
    ## 卸载
    rpm -e gitlab-ee

    ## 安装、升级
    ## 升级前，请阅读升级注意
    ## https://docs.gitlab.com/ee/policy/maintenance.html#upgrade-recommendations

    curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.rpm.sh | sudo bash
    wget --content-disposition https://packages.gitlab.com/gitlab/gitlab-ee/packages/el/7/gitlab-ee-12.3.1-ee.0.el7.x86_64.rpm/download.rpm
    rpm -i gitlab-ee-12.3.1-ee.0.el7.x86_64.rpm 

## 升级
    # https://docs.gitlab.com/ee/update/index.html#checking-for-background-migrations-before-upgrading
    # https://docs.gitlab.com/omnibus/update/README.html#zero-downtime-updates
    #... 12.0.12 -> 12.10.14 -> 13.0.14 -> 13.1.11 -> 13.9.4
    touch /etc/gitlab/skip-auto-reconfigure
    yum install -y gitlab-ee-12.10.14-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    # postgres先升级到11
    gitlab-ctl pg-upgrade -V 11

    yum install -y gitlab-ee-13.0.14-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum install -y gitlab-ee-13.1.11-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    # 推荐postgres先升级到12
    gitlab-ctl pg-upgrade -V 12

    yum install -y gitlab-ee-13.9.4-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-13.10.3-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

## 问题
 1、 `gitlab-ctl status`  发现redis down
    
    rm -f /var/opt/gitlab/redis/dump.rdb

2、访问时返回502

    gitlab-ctl reconfigure
