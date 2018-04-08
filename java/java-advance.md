# Java Web进阶
视空闲，持续更新中...

## 读写锁
    1、读锁锁定资源后，其他读锁也可以锁定资源，并行操作
    2、写锁加锁后，其他锁阻塞
    3、读锁锁定资源后，若写锁加锁，写锁阻塞等待，且再之后的读锁也等待，避免读锁长期占有资源，防止写锁饥饿问题

## 悲观锁、乐观锁

## CAS、ABA问题
    Compare and Swap, 比较并交换
    CAS有3个操作数，内存值V，旧的预期值A，要修改的新值B。当且仅当预期值A和内存值V相同时，将内存值V修改为B，否则什么都不做
    boolean CompareAndSet(current, next)
    使用者提供他自己某一时刻获取的当前值A，和需要修改成的值B。实际内存中的值V(共享值，其他人也可修改)与A比较，无变化，则V改成B并返回true；否则，不操作并返回false

    ABA问题 A-B-A，中间有变化，虽然值还是A
    一般通过版本号解决，每次变量更新的时候把版本号加一，参考乐观锁。1A-2B-3A
    JAVA通过AtomicStampedReference来解决ABA问题
    java调用jni来操作cas、cpu提供原子cas操作

## volatile
    原子性、可见性、有序性
    CPU总线锁、缓存一致性
    volatile保证可见性和部分有序性(不可指令重排)，不保证原子性

## 单例
最佳单例设计模式，延迟加载，保证所有jdk版本下，线程安全高效
    
    public class Singleton {
        private Singleton() {}

        private static class SingletonLazyHolder {
            private static final Singleton INSTANCE = new Singleton();
        }

        public static Singleton getInstance() {
            return SingletonLazyHolder.INSTANCE;
        }
    }

或者使用volatile和双重检测Double-Check，jdk1.5+
    
    public class Singleton {  
        private static volatile Singleton instance = null;  
        private Singleton() {}
        public static Singleton getInstance() {  
            if (instance == null) {  
                synchronized(Singleton.class) {  
                    if (instance == null) {  
                        instance = new Singleton();  
                    }  
                }  
            }  
            return instance;  
        }  
    }







