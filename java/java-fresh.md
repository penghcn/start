# Java Web入门
视空闲，持续更新中...

## 工具
### jdk
推荐使用jdk1.8 [下载地址](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

jdk1.6，很多公司很多老项目都是基于这个版本，请自行安装

我电脑里面目前是装了这2个版本，1.8为主，1.6为辅

### eclipse 
掌握基本使用 [下载地址](https://www.eclipse.org/downloads/eclipse-packages/?osType=win32&release=undefined)
 
### idea 
推荐使用

### 其他
tomcat、jetty、maven、gradle、 git

## 变量
### 0、八种基本数据类型
基本数据类型的数据是在 **方法的** 栈空间中分配。栈在性能上高于堆。注意，**类** 对象中基本类型域还是分配在堆空间中

以下涉及位数计算的，建议 **熟悉** **二进制(符号位、无符号)**

    byte,     1Byte, 2^7 -1,   [-128, 127]
    short,    2Byte, 2^15 -1,  [-32768, 32767]
    int,      4Byte, 2^31 -1,  [-2147483648, 2147483647]
    long,     8Byte, 2^63 -1,  [-9223372036854775808, 9223372036854775807]
    
    float,    4Byte, 1+8+32,   [-3.4028235E38, 3.4028235E38]
    double,   8Byte, 1+11+52   [-1.7976931348623157E308, 1.7976931348623157E308]

    char,     2Byte, 2^16 -1,  [0, 65535]
    
    boolean,  1bit, true,false [0, 1]

### 1、int 和 Integer 的区别
### 2、IntegerCache、LongCache等(-128 <= i <=  127)
        int a = 128, b = 128;
        System.out.println(a == b);

        Integer a1 = 127, b1 = 127;
        System.out.println(a1 == b1);

        Integer a2 = 128, b2 = 128;
        System.out.println(a2 == b2);
        System.out.println(a2.equals(b2));

### 3、Float.MIN_VALUE、Double.MIN_VALUE
    Float.MIN_VALUE == 1.4E-45; Double.MIN_VALUE == 4.9E-324
    上面代表float类型能够表示的最小精度，并非最小值
    Float的最小值 == -Float.MAX_VALUE

### 4、性能
基本类型的效率优于装箱类型

        long s1 = System.nanoTime();
        int c1 = 0;
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
            c1 += i;
        }
        System.out.println("int消耗时间："+ (System.nanoTime() - s1)/1e9 +"s");//0.75282627s

        long s2 = System.nanoTime();
        Integer c2 = 0;
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
            c2 += i;
        }
        System.out.println("Integer消耗时间："+ (System.nanoTime() - s2)/1e9 +"s");//6.308165414s

## 列表
### Map、HashMap、List、ArrayList、HashSet、Collection
### 排序、数据结构
    冒泡排序、快速排序、堆排序
    二叉树、B+树
    有向无环图

## 并发
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

## 目录
1、[工具](#工具)
    
&nbsp; &nbsp;1.1 [jdk](#jdk)

&nbsp; &nbsp;1.2 [eclipse](#eclipse)

&nbsp; &nbsp;1.3 [idea](#idea)

&nbsp; &nbsp;1.4 [gradle](#gradle)

&nbsp; &nbsp;1.5 [git](#git)

2、[基本变量](#基本变量)

3、[列表](#列表)

4、[并发](#并发)





