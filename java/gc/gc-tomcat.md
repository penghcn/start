# GC参数

## 参考配置
保留参考，时区设置
-Duser.timezone=GMT-5

### 4G
JAVA_OPTS="
-Dfile.encoding=UTF-8
-server
-Djava.awt.headless=true
-Xms2g
-Xmx3g
-XX:NewSize=1g
-XX:MaxNewSize=2g
-XX:PermSize=512m 
-XX:MaxPermSize=512m 
-XX:MaxTenuringThreshold=15
-XX:NewRatio=2
-XX:+AggressiveOpts
-XX:+UseBiasedLocking
-XX:+UseConcMarkSweepGC
-XX:+UseParNewGC
-XX:+CMSParallelRemarkEnabled
-XX:LargePageSizeInBytes=128m
-XX:+UseFastAccessorMethods
-XX:+UseCMSInitiatingOccupancyOnly
-XX:+DisableExplicitGC
-XX:+PrintGCDetails 
-XX:+PrintGCTimeStamps
-Xloggc:/tmp/app-gc.log"


## 16G
JAVA_OPTS="
-Dfile.encoding=UTF-8 
-server 
-Xms13g 
-Xmx13g 
-XX:NewSize=3g
-XX:MaxNewSize=4g
-XX:PermSize=512m 
-XX:MaxPermSize=512m 
-XX:MaxTenuringThreshold=10 
-XX:NewRatio=2 
-XX:+DisableExplicitGC"

## 32G
JAVA_OPTS="
-Dfile.encoding=UTF-8 
-server 
-Xms29g
-Xmx29g
-XX:NewSize=6g
-XX:MaxNewSize=8g 
-XX:PermSize=1g
-XX:MaxPermSize=1g
-XX:MaxTenuringThreshold=10 
-XX:NewRatio=2 
-XX:+DisableExplicitGC"

## 8G
JAVA_OPTS="
-Dfile.encoding=UTF-8 
-server 
-Djava.awt.headless=true 
-Xms6g 
-Xmx6g
-XX:NewSize=1g 
-XX:MaxNewSize=2g
-XX:PermSize=512m 
-XX:MaxPermSize=512m 
-XX:MaxTenuringThreshold=15 
-XX:NewRatio=2 
-XX:+AggressiveOpts 
-XX:+UseBiasedLocking 
-XX:+UseConcMarkSweepGC
-XX:+UseParNewGC
-XX:+CMSParallelRemarkEnabled
-XX:LargePageSizeInBytes=128m
-XX:+UseFastAccessorMethods
-XX:+UseCMSInitiatingOccupancyOnly
-XX:+DisableExplicitGC"



