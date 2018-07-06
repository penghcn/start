## Java面试题

### 基础
#### 1、分析结果，简要说明
    int a = 128, b = 128;
    System.out.println(a == b);

    Integer a1 = 127, b1 = 127;
    System.out.println(a1 == b1);

    Integer a2 = 128, b2 = 128;
    System.out.println(a2 == b2);

    Integer a3 = new Integer(127), b3 = new Integer(127);
    System.out.println(a3 == b3);

### 设计模式
#### 1、写出你常用或了解的3～5种设计模式


#### 2、写出一个单例模式
    

### 优化SQL
#### 1、提示：关联子查询消除
    
    select a.* from a where a.id in (select id from b where b.num < 10 and b.name = a.name)   


#### 2、提示：聚合下推

    select count(a.id) from a join b on a.id = b.order_id



#### 3、提示：综合上述

    select a.num from a where 0 = (select count(id) from b where b.order_id = a.id)


    

