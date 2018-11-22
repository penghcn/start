--用户登录表
--mysql5.5+ boxdb
DROP TABLE t_user_login;
CREATE TABLE t_user_login(
        id                                      BIGINT(20)     UNSIGNED AUTO_INCREMENT NOT NULL COMMENT '主键',
        login_id                                VARCHAR(30)    BINARY     NOT NULL DEFAULT ''   COMMENT '登录账号/手机号',
        login_pwd                               VARCHAR(128)   BINARY     NOT NULL DEFAULT ''   COMMENT '登录密码',
        crt_ts                                  DATETIME(6)               NOT NULL DEFAULT '1900-01-01 00:00:00.000000' COMMENT '创建时间',
        upd_ts                                  DATETIME(6)               NOT NULL DEFAULT '1900-01-01 00:00:00.000000' COMMENT '最后修改时间',
    PRIMARY KEY (id) COMMENT '',
    UNIQUE KEY `iu_user_login_1` (login_id) COMMENT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;