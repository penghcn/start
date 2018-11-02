# 测试环境搭建
## 下载
    tar -xzf kafka_2.11-2.0.0.tgz
    cd kafka_2.11-2.0.0
## 配置、启动
    vi config/server.properties

    broker.id=0
    zookeeper.connect=192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181
    listeners = PLAINTEXT://192.168.8.29:9092
    log.dirs=/tmp/kafka-logs

    bin/kafka-server-start.sh config/server.properties
    nohup sh bin/kafka-server-start.sh config/server.properties >logs/s.log 2>&1 &

## 集群
配置第2个节点，并启动

    cp config/server.properties config/server1.properties
    vi config/server1.properties
    broker.id=1
    zookeeper.connect=192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181
    listeners = PLAINTEXT://192.168.8.29:9093
    advertised.listeners=PLAINTEXT://192.168.8.29:9093
    log.dirs=/tmp/kafka-logs-1

    bin/kafka-server-start.sh config/server1.properties
    nohup sh bin/kafka-server-start.sh config/server1.properties >logs/s1.log 2>&1 &

配置第3个节点，并启动

    cp config/server1.properties config/server2.properties
    vi config/server2.properties
    broker.id=2
    zookeeper.connect=192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181
    listeners = PLAINTEXT://192.168.8.29:9094
    advertised.listeners=PLAINTEXT://192.168.8.29:9094
    log.dirs=/tmp/kafka-logs-2

    nohup sh bin/kafka-server-start.sh config/server2.properties >logs/s2.log 2>&1 &
## 创建主题
    bin/kafka-topics.sh --create --zookeeper 192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181  --replication-factor 3 --partitions 1 --topic my-replicated-topic
## 查看
    bin/kafka-topics.sh --describe --zookeeper 192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181 
    bin/kafka-topics.sh --delete --zookeeper 192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181  --topic __consumer_offsets

    bin/kafka-topics.sh --describe --zookeeper 192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181  --topic canal-boxdb-sjbhis-test3

## kafka-manager
下载[kafka-manager-1.3.3.18.tar.gz](https://github.com/yahoo/kafka-manager/releases)
    
    vi conf/application.conf

    kafka-manager.zkhosts="192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181"

    ./sbt clean dist

    cp target/universal/kafka-manager-1.3.3.18.zip .
    unzip kafka-manager-1.3.3.18.zip 
    cd kafka-manager-1.3.3.18
    pwd

    bin/kafka-manager
    nohup  bin/kafka-manager >logs/km.log 2>&1 &

进入web界面192.168.8.29:9000，Add Cluster填上需要管理的kafka集群




