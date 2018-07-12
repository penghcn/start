# SQL优化

## 参考
https://segmentfault.com/a/1190000008643974

## 谓词下推
    select * from t join s on t.id = s.id where t.c1 < 10
    select * from (select * from t where t.c1 < 10) as t join s on t.id = s.id

## 关联子查询消除
    select * from t where t.id in (select id from s where s.c1 < 10 and s.name = t.name)
    select * from t join s on t.id = s.id and s.name = t.name and s.c1 < 10

## 聚合下推
    select count(s.id) from t join s on t.id = s.t_id
    select sum(agg0) from t join (select count(id) as agg0, t_id from s group by t_id) as s on t.id = s.t_id

## 综合
    select s.c2 from s where 0 = (select count(id) from t where t.s_id = s.id)
    select s.c2 from s left outer join t on t.s_id = s.id group by s.id where 0 = count(t.id)
    select s.c2 from s left outer join (select count(t.id) as agg0 from t group by t.s_id) t on t.s_id = s.id group by s.id where 0 = sum(agg0)
    select s.c2 from s left outer join (select count(t.id) as agg0 from t group by t.s_id) t on t.s_id = s.id where 0 = agg0


## 例子
    DROP TABLE a;
    CREATE TABLE a (
            id                                      INT(11)        UNSIGNED   NOT NULL DEFAULT 0    COMMENT '主键',
            num                                     INT(11)        UNSIGNED   NOT NULL DEFAULT 0    COMMENT '',
            name                                    VARCHAR(1024)  BINARY     NOT NULL DEFAULT ''   COMMENT '',
        PRIMARY KEY (id) COMMENT ''
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    DROP TABLE b;
    CREATE TABLE b (
            id                                      INT(11)        UNSIGNED   NOT NULL DEFAULT 0    COMMENT '主键',
            num                                     INT(11)        UNSIGNED   NOT NULL DEFAULT 0    COMMENT '',
            order_id                                INT(11)        UNSIGNED   NOT NULL DEFAULT 0    COMMENT '',
            name                                    VARCHAR(1024)  BINARY     NOT NULL DEFAULT ''   COMMENT '',
        PRIMARY KEY (id) COMMENT ''
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

    select * from a;
    select * from b;
    insert into a values (1001,1,'t11'),(1002,102,'t12'),(1003,100,'t13'),(1004,10,'t14'),(1005,5,'t15');
    insert into b values(1,1,1002,'t11'),(2,102,1004,'t12'),(3,100,1003,'t13'),(4,5,1003,'t13'),(1001,6,1003,'t11'),(1002,7,1003,'t12');

    select a.* from a where a.id in (select id from b where num < 10 and name = a.name) ;
    select a.* from a join b on b.id = a.id and b.name = a.name and b.num < 10;
            
    select count(b.id) from a join b on a.id = b.order_id;
    select sum(agg0) from a inner join (select count(id) as agg0, order_id from b group by order_id) as b on a.id = b.order_id;

    select a.* from a where 0 = (select count(id) from b where b.order_id = a.id);
    select a.* from a left join (select count(id) as agg0, order_id from b group by order_id) b on a.id = b.order_id where agg0 is null;

