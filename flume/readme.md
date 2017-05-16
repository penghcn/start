## 安装使用
参考官方文档 https://cwiki.apache.org/confluence/display/FLUME/Getting+Started

1、下载 https://github.com/apache/flume/releases

2、安装 

3、几个概念 source、channel、sink

## 与 kafka 、hbase结合
kafka source + memory channel + (kafka sink、hbase sink)

1、日志流转PLAN A

log4j 推送到kafka队列，flume消费处理，落到sink出口(主要是2个出口：实时监控系统、日志存储)

1.1 实时处理

log4j -> kafka topic -> flume(kafka source > memory channel + kafka sink) -> spark -> kafka -> realtime -> log system 



1.2 保存一份

log4j -> kafka topic -> flume(kafka source > memory channel + hbase sink) -> log system
