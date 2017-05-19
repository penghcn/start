## 简介
### 1、生产
发送到topic，实际是topic中的不同物理分区partition中。理论上，相同消费者消费同一个partition。

按 mod(hash(key),partition)划分消息分区。若不指定key，则随机分区，并缓存(默认每10分钟或更新topic元数据时刷新)
  
### 2、消费
消费者 消费同一个groupId下的所有数据，更新offset
  
### 3、数据清理
磁盘永久保存。删除设置：时间(16小时前的不保留之前的)，容量(超过1G不保留之前的)
  
      log.cleanup.policy=delete ## 启用删除策略
      log.retention.hours=16 ## 超过指定时间清理
      log.retention.bytes=1073741824 ## 超过指定大小后，删除老数据
      
  
## 安装使用
下载 http://kafka.apache.org/downloads

参考官方文档 http://kafka.apache.org/quickstart

1、解压到指定目录，例如

    tar zxvf kafka_2.12-0.10.2.1.tgz -C /data/app/kafka_2.12-0.10.2.1    
    cd /data/app/kafka_2.12-0.10.2.1 

2、修改配置文件`config/server.properties`，这里使用已有zookeeper环境

    zookeeper.connect=192.168.8.27:2181,192.168.8.28:2181,192.168.8.29:2181

3、启动kafka

    bin/kafka-server-start.sh config/server.properties &
    //发送
    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic TEST

4、消费端，查看指定topic的所有消息

    bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic TEST-TOPIC --from-beginning
    或者
    bin/kafka-console-consumer.sh --zookeeper 192.168.8.27:2181 --topic TEST-TOPIC --from-beginning
    //查看topic列表
    bin/kafka-topics.sh --list --zookeeper 192.168.8.27:2181
