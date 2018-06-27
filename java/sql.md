# SQL优化

## 参考
https://segmentfault.com/a/1190000008643974

## 谓词下推
    select * from t join s on t.id = s.id where t.c1 < 10
    select * from (select * from t where t.c1 < 10) as t join s on t.id = s.id

## 关联子查询消除
    select * from t where t.id in (select id from s where s.c1 < 10 and s.name = t.name)
    select * from t semi join s on t.id = s.id and s.name = t.name and s.c1 < 10

## 聚合下推
    select count(s.id) from t join s on t.id = s.t_id
    select sum(agg0) from t join (select count(id) as agg0, t_id from s group by t_id) as s on t.id = s.t_id

## 综合
    select s.c2 from s where 0 = (select count(id) from t where t.s_id = s.id)
    select s.c2 from s left outer join t on t.s_id = s.id group by s.id where 0 = count(t.id)
    select s.c2 from s left outer join (select count(t.id) as agg0 from t group by t.s_id) t on t.s_id = s.id group by s.id where 0 = sum(agg0)
    select s.c2 from s left outer join (select count(t.id) as agg0 from t group by t.s_id) t on t.s_id = s.id where 0 = agg0

