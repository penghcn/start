# 这是一个dubbo的demo
    我这里随便写了个省市区代码对照表的查询，基于spring-jpa
## dubbo原生是绑定了spring3.2的，这里做了一点小升级，只是build脚本不一样而已
### 升级支持
    gradle,spring4,netty,zkclient0.9,log4j2
    ps：当然，你也可以参照：有人对dubbox的源码fork修改，直接支持上面这些，
    我这个是dubbo的demo，dubbox需要jdk7+

## 使用
### api
    定义接口，这里就一个CityService
    定义请求与响应的父类，这里是 Request 和 Response
### provider
    提供服务，见dubbo-provider.xml
### consumer 
    消费，见dubbo-consumer.xml
    

##可以这样用
我这里可以把consumer打成jar，放到别的项目中，
###1.添加依赖

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
###2.使用
代码片段见Demo.java,主要是这2行

    RegisterHelper.init();
    CityService cityService = AppCtxKeeper.getBean(CityService.class);
以上只是提供个大概，希望有用

