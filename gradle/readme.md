#gradle的一些使用
##介绍
1、java项目的构建工具常用的有ivy `build.xml`，maven `pom.xml`，gradle `build.gradle`
2、
##安装使用
1、安装。下载安装包，解压到某文件夹，把bin目录加入到系统环境变量
    比如 windows环境下，C:\www\resources\gradle-2.12\bin
2、运行。打开终端，运行 `gradle build` `gradle eclipse` `gradle check` `gradle clean`等命令
3、在第一次运行`gradle build`等命令去获取jar依赖的时候，如果是maven中心，国内速度比较慢，可以慢慢下载或使用vpn
以后再下载相同依赖，会使用本地的缓存，就比较快了
一般是放在 ~/.gradle/caches/modules-2/files-2.1/...，比如amqp-client-3.6.5.jar在下面的目录
C:/Users/pengh/.gradle/caches/modules-2/files-2.1/com.rabbitmq/amqp-client/3.6.5/59e11141636ba2469a6fdd8c986d622480c3e239

##build.gradle示例
    [https://github.com/penghcn/demo/blob/master/gradle/build.gradle](https://github.com/penghcn/demo/blob/master/gradle/build.gradle)    
##eclipse
1、一般的web项目，建立根目录，如C:\www\demo\test
2、把build.gradle放到根目录，根据项目需要修改
3、打开终端，切换到根目录下运行 `gradle dirs` 创建基本目录，再运行`gradle eclipse`添加一些jar依赖
4、打开eclipse，导入该项目
5、每次需要添加新的jar依赖时，只需修改build.gradle文件然后在项目根目录运行`gradle eclipse`即可
6、构建上线 运行`gradle build`
