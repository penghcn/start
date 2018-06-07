# GC
参考

[专栏：GC性能优化](https://blog.csdn.net/column/details/14851.html)
[JVM性能调优监控工具](http://www.cnblogs.com/shangdongbin/p/7743976.html)

## 1、垃圾收集简介
[https://blog.csdn.net/renfufei/article/details/53432995](https://blog.csdn.net/renfufei/article/details/53432995)

### 标记、清除
    marking 遍历所有的可达对象,并在本地内存(native)中分门别类记
    sweeping 不可达对象所占用的内存, 在之后进行内存分配时可以重用
### STW
    stop the world pause 全线暂停
    一次垃圾收集过程中, 需要暂停应用程序的所有线程
    有很多原因会触发STW停顿, 其中垃圾收集是最主要的因素


