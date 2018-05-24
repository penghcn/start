# GC参数

## 配置

### 4G
JAVA_OPTS="
-Dfile.encoding=UTF-8
-server
-Djava.awt.headless=true
-Xms2g
-Xmx3g
-XX:NewSize=1g
-XX:MaxNewSize=2g
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



