## 下载
  http://kafka.apache.org/downloads 
## 安装使用
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
