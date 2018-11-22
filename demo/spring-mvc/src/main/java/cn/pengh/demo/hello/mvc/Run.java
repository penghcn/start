package cn.pengh.demo.hello.mvc;

import cn.pengh.demo.hello.mvc.config.AppConfig;
import cn.pengh.demo.hello.mvc.dao.hellodb.UserLoginDao;
import cn.pengh.demo.hello.mvc.req.UserLoginReq;
import cn.pengh.demo.hello.mvc.util.LogUtil;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

/**
 * @author Created by pengh
 * @datetime 2018/11/15 10:47
 */
public class Run {
    public static void main(String[] args) {
        LogUtil.getLogger().debug("Run..");
        ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);

        UserLoginReq req = new UserLoginReq();
        req.setLoginId("test");
        ctx.getBean(UserLoginDao.class).getOne(req);
    }
}
