package cn.pengh.demo.hello.mvc.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.util.ClassUtils;

/**
 * @author Created by pengh
 * @datetime 2018/11/15 11:02
 */
public class LogUtil {
    public static boolean isLog4j2 = ClassUtils.isPresent("org.apache.logging.log4j.Logger", LogUtil.class.getClassLoader());
    private static Logger logger = isLog4j2 ? LogManager.getLogger(LogUtil.class.getName()) : null;

    public static Logger getLogger(){
        if (!isLog4j2)
            throw new IllegalArgumentException("not support log4j2");
        return logger;
    }
}
