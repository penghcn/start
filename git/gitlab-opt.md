# gitlab 调优
[参考](https://blog.csdn.net/ouyang_peng/article/details/84066417)

## 减少进程数
    vi /etc/gitlab/gitlab.rb

    gitlab_rails['time_zone'] = 'Asia/Shanghai'
    
    puma['worker_processes'] = 5
    puma['worker_timeout'] = 60

    # 0.98 * ( 800 + ( worker_processes * 1024MB ) ) = 0.98 * ( 800 + ( 5 * 1024 ) ) = 5018
    puma['per_worker_max_memory_mb'] = 5018

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
    # https://gitlab.com/gitlab-org/gitlab/-/tags
    # https://docs.gitlab.com/ee/update/index.html#upgrade-paths
    # ... 12.0.12 -> 12.10.14 -> 13.0.14 -> 13.1.11 -> 13.9.4 -> 13.12.12
    #  -> 13.12.15 -> 14.0.12 -> 14.3.6 -> 14.9.5 -> 14.10.5
    #  -> 15.0.2 -> 15.1.6 -> 15.4.6 -> 15.11.3 -> 15.11.8  -> 15.11.12 -> latest 15.Y.Z
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
    yum install -y gitlab-ee-13.12.15-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-14.0.12-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-14.3.6-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum install -y gitlab-ee-14.9.5-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-14.10.5-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.0.2-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.1.6-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.4.6-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.11.3-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.11.8-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

    yum update 
    yum install -y gitlab-ee-15.11.12-ee.0.el7.x86_64
    SKIP_POST_DEPLOYMENT_MIGRATIONS=true gitlab-ctl reconfigure
    gitlab-rake db:migrate

## 问题
 1、 `gitlab-ctl status`  发现redis down
    
    rm -f /var/opt/gitlab/redis/dump.rdb

    gitlab-rake cache:clear

2、访问时返回500/502，并稍等一下

    gitlab-ctl restart

    或者

    gitlab-ctl reconfigure

3、升级到14错误 `Checking for unmigrated data on legacy storage`

    gitlab-rake gitlab:check SANITIZE=true

    gitlab-rake gitlab:storage:list_legacy_projects
    gitlab-rake gitlab:storage:list_legacy_attachments
    gitlab-rake gitlab:storage:migrate_to_hashed

4、`gitlab-psql` 进入PG数据库

    参考https://gitlab.com/gitlab-org/gitlab/-/issues/323113
    
    select * from schema_migrations order by version desc;

    delete from schema_migrations where version ='20200722202318';
    insert into schema_migrations VALUES (20200722202318),(20200724100421),(20200810100921),(20200819113644),(20200904174901),(20200929113254);
    insert into schema_migrations VALUES (20200727100631);
    insert into schema_migrations VALUES (20200727114147);
    insert into schema_migrations VALUES (20200810101029);
    insert into schema_migrations VALUES (20200819082334);

    insert into schema_migrations VALUES (20200903064431);
    insert into schema_migrations VALUES (20201015154527);
    insert into schema_migrations VALUES (20210105030125);

    insert into schema_migrations VALUES (20210210221006);
    insert into schema_migrations VALUES (20210306121310);
    insert into schema_migrations VALUES (20210326121537);
    insert into schema_migrations VALUES (20210413130011);






