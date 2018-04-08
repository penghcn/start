# Java Web入门与实战
## 工具
### 选择jdk
推荐使用jdk1.8 [下载地址](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

jdk1.6，很多公司很多老项目都是基于这个版本，请自行安装

我电脑里面目前是装了这2个版本，1.8为主，1.6为辅

### eclipse 基本掌握 
[下载地址](https://www.eclipse.org/downloads/eclipse-packages/?osType=win32&release=undefined)
 
### idea 推荐使用

### tomcat 或者 jetty


## 基本变量
### 1、int 和 Integer 的区别
### 2、IntegerCache、LongCache等(-128 <= i <=  127)
        int a = 128, b = 128;
        System.out.println(a == b);

        Integer a1 = 127, b1 = 127;
        System.out.println(a1 == b1);

        Integer a2 = 128, b2 = 128;
        System.out.println(a2 == b2);
        System.out.println(a2.equals(b2));

## 列表
### Map、HashMap、List、ArrayList、HashSet、Collection
### 排序、数据结构
    冒泡排序、快速排序、堆排序
    二叉树、B+树
    有向无环图

## 并发 concurrent
在这个包里面 java.util.concurrent
### atomic
        AtomicInteger i = new AtomicInteger(1);
        i.addAndGet(2);
        System.out.println("i = [" + i + "]");
        i.decrementAndGet();
        System.out.println("i = [" + i + "]");

### lock
    ReentrantLock, ReadWriteLock

### 线程 Thread、线程池 ExecutorService
        new Thread(new Runnable() {
            @Override
            public void run() {
                //do something
            }
        }).start();
        new Thread(()->{/*do something*/}).start();//jdk1.8+ lambda写法

        ExecutorService es = Executors.newFixedThreadPool(3);
        es.submit(()->{
            //do something
        });
        es.shutdown();

### 队列
ConcurrentMap、CopyOnWriteArrayList、BlockingQueue、ConcurrentLinkedQueue





