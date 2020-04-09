#!/bin/bash
## 某java程序down后，先用sh dump.sh保存现场信息，再kill重启
## 参考https://dubbo.gitbooks.io/dubbo-dev-book/principals/dummy.html
## 参考http://javatar.iteye.com/blog/804187

##根据自己项目的java目录，修改下面JAVA_HOME值

JAVA_HOME=/usr/java/jdk1.6.0_31/bin/
JAVA_HOME=/usr/java/jdk1.8.0_101/bin/
JAVA_HOME=$HOME/jdk1.8.0_101/bin/ 

OUTPUT_HOME=$HOME/output  

DEPLOY_HOME=`dirname $0`  
HOST_NAME=`hostname`  

APP_USER=`who am i |awk '{print $1}'`

if [ ! -n "$1" ] ;then
    DUMP_PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$APP_USER" | grep "tomcat" | grep "$DEPLOY_HOME" |awk '{print $2}'` 
    echo "默认过滤 grep java | grep tomcat | grep <user>"
elif [ "user" = "$1" ] ;then
    DUMP_PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$APP_USER" | grep "$DEPLOY_HOME" |awk '{print $2}'` 
    echo "user参数过滤 grep java | grep <user>"
elif [ "all" = "$1" ] ;then
    DUMP_PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$DEPLOY_HOME" |awk '{print $2}'` 
    echo "all参数过滤 grep java"
else
    DUMP_PIDS=`ps  --no-heading -C java -f --width 1000 | grep "$APP_USER" | grep "tomcat" | grep "$DEPLOY_HOME" |awk '{print $2}'` 
    echo "不支持的参数：$1 使用默认过滤 grep java | grep tomcat | grep <user>"
fi

 
if [ -z "$DUMP_PIDS" ]; then  
    echo "The server $HOST_NAME is not started!"  
    exit 1;  
fi
echo "pids: $DUMP_PIDS"

if [ -z "$DUMP_PIDS" ]; then  
    echo "The server $HOST_NAME is not started!"  
    exit 1;  
fi  

DUMP_ROOT=$OUTPUT_HOME/dump  
if [ ! -d $DUMP_ROOT ]; then  
    mkdir -p $DUMP_ROOT  
fi  

DUMP_DATE=`date +%Y%m%d%H%M%S`  
DUMP_DIR=$DUMP_ROOT/dump-$DUMP_DATE  
echo "output: $DUMP_DIR"

if [ ! -d $DUMP_DIR ]; then  
    mkdir $DUMP_DIR  
fi  

echo -e "Dumping the server $HOST_NAME ...\c"  
for PID in $DUMP_PIDS ; do  
    $JAVA_HOME/jstack $PID > $DUMP_DIR/jstack-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jinfo $PID > $DUMP_DIR/jinfo-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jstat -gcutil $PID > $DUMP_DIR/jstat-gcutil-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jstat -gccapacity $PID > $DUMP_DIR/jstat-gccapacity-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jmap $PID > $DUMP_DIR/jmap-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jmap -heap $PID > $DUMP_DIR/jmap-heap-$PID.dump 2>&1  
    echo -e ".\c"  
    $JAVA_HOME/jmap -histo $PID > $DUMP_DIR/jmap-histo-$PID.dump 2>&1  
    echo -e ".\c"  
    if [ -r /usr/sbin/lsof ]; then  
    /usr/sbin/lsof -p $PID > $DUMP_DIR/lsof-$PID.dump  
    echo -e ".\c"  
    fi  
done  
if [ -r /usr/bin/sar ]; then  
/usr/bin/sar > $DUMP_DIR/sar.dump  
echo -e ".\c"  
fi  
if [ -r /usr/bin/uptime ]; then  
/usr/bin/uptime > $DUMP_DIR/uptime.dump  
echo -e ".\c"  
fi  
if [ -r /usr/bin/free ]; then  
/usr/bin/free -t > $DUMP_DIR/free.dump  
echo -e ".\c"  
fi  
if [ -r /usr/bin/vmstat ]; then  
/usr/bin/vmstat > $DUMP_DIR/vmstat.dump  
echo -e ".\c"  
fi  
if [ -r /usr/bin/mpstat ]; then  
/usr/bin/mpstat > $DUMP_DIR/mpstat.dump  
echo -e ".\c"  
fi  
if [ -r /usr/bin/iostat ]; then  
/usr/bin/iostat > $DUMP_DIR/iostat.dump  
echo -e ".\c"  
fi  
if [ -r /bin/netstat ]; then  
/bin/netstat > $DUMP_DIR/netstat.dump  
echo -e ".\c"  
fi  
echo "OK!"