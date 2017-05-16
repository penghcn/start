## 安装使用
参考官方文档 https://cwiki.apache.org/confluence/display/FLUME/Getting+Started

1、下载 https://github.com/apache/flume/releases

2、安装 tar

3、source、channel、sink

## 与 kafka 、hbase结合
kafka source + memory channel + (kafka sink、hbase sink)

1、日志流转

1.1 实时处理

log4j -> kafka topic -> flume(kafka source > memory channel + kafka sink) -> spark -> kafka -> realtime -> log system 

1.2 保存起来

log4j -> kafka topic -> flume(kafka source > memory channel + hbase sink) -> log system
