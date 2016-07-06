# 这是一个dubbo的demo
    我这里随便写了个省市区代码对照表的查询，基于spring-jpa
## 1 dubbo原生是绑定了spring2.5.6.SEC03的，这里做了一点小升级，只是build脚本不一样而已
### 1.1 升级支持
gradle,spring4,netty,zkclient0.9,log4j2

ps：当然，你也可以参照：有人对dubbox的源码fork修改，直接支持上面这些，[点这里](http://www.cnblogs.com/yjmyzz/p/update-dubbo-to-spring-4-and-add-log4j2-support.html)或者[这里](https://github.com/yjmyzz/dubbox)

这个是dubbo的demo，支持jdk6，dubbox需要jdk7+

## 2 使用
### 2.1 zookeeper
    安装就不说了，启动先
### 2.2 api
    定义接口，这里就一个CityService
    定义请求与响应的父类，这里是 Request 和 Response
### 2.3 provider
    提供服务，见dubbo-provider.xml
    main方法启动 AppConfig.java
    或者使用tomcat启动，见web.xml
### 2.4 consumer 
    消费者，见dubbo-consumer.xml
    测试 Demo.java    

## 3 可以这样用
    把consumer打成jar，放到别的项目中
### 3.1 添加依赖(gradle)
    dubbo_version                   = '2.5.3'
    zookeeper_version               = '3.4.8'
    zkclient_version                = '0.9'
    javassist_version               = '3.20.0-GA'
    netty_version                   = '3.2.10.Final'

    compile file('city-dubbo-api-0.0.2.jar')
    compile file('city-dubbo-consumer-0.0.2.jar')
    compile (
        'javax.annotation:javax.annotation-api:1.2',
        'javax.ws.rs:javax.ws.rs-api:2.0.1',
        "org.jboss.netty:netty:$netty_version",
        "org.javassist:javassist:${javassist_version}"
    )
    compile ("org.apache.zookeeper:zookeeper:$zookeeper_version"){
        exclude(module: 'log4j')
        exclude(module: 'slf4j-log4j12')
        exclude(module: 'netty')
    }
    compile ("com.101tec:zkclient:$zkclient_version"){
        exclude(module: 'slf4j-api')
        exclude(module: 'slf4j-log4j12')
    }
    compile ("com.alibaba:dubbo:$dubbo_version"){
        exclude(module: 'log4j')
        exclude(module: 'slf4j-log4j12')
        exclude(module: 'logback-classic')
        exclude(module: 'spring')
    }
### 3.2 使用示例
代码片段见Demo.java,主要是这2行

    RegisterHelper.init();
    CityService cityService = AppCtxKeeper.getBean(CityService.class);
以上只是提供个大概，希望有用

