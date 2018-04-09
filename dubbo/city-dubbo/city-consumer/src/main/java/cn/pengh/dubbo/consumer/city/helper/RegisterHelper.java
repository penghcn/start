package cn.pengh.dubbo.consumer.city.helper;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.pengh.mvc.core.listener.AppCtxKeeper;

/**
 * 
 * @author pengh
 * @Date 2016年7月5日 下午3:09:09
 */
public class RegisterHelper {
	private static ApplicationContext context = null;
	public static void init(){
		if (context == null) {
			context = new ClassPathXmlApplicationContext("classpath:/dubbo-consumer.xml");
			AppCtxKeeper.init(context);
		}			
	}
}


