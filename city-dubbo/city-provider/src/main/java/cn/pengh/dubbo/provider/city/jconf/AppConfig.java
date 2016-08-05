package cn.pengh.dubbo.provider.city.jconf;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ImportResource;
import org.springframework.context.annotation.Profile;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

import cn.pengh.dubbo.provider.city.cache.CityCache;
import cn.pengh.dubbo.provider.city.cache.PhoneBinCache;
import cn.pengh.dubbo.provider.city.jconf.ioc.ServiceConfig;
import cn.pengh.library.ConfigReader;
import cn.pengh.library.Log;
import cn.pengh.mvc.core.listener.AppCtxKeeper;
import cn.pengh.util.CurrencyUtil;

@Configuration
@Profile("default")
@PropertySource({"classpath:consts/persistence-"+AppConfig.ENVIRONMENT+".properties"}) 
@Import({ServiceConfig.class})
@ImportResource({"classpath:jpa/spring-jpa.xml",
				"classpath:jpa/spring-ds-"+AppConfig.ENVIRONMENT+".xml",
				"classpath:dubbo-provider.xml"})//加载xml混用的配置

public class AppConfig {
	public static final String ENVIRONMENT = ConfigReader.ENVIRONMENT.DEVELOPMENT;
	/**
	 * 若加载资源文件，必须声明且为static
	 * @return
	 */
	@Bean
	public static PropertySourcesPlaceholderConfigurer placeHodlerConfigurer(){
		initPlaceholderConfig();
		return new PropertySourcesPlaceholderConfigurer();
	}
	
	@Bean
	public ConfigReader configReader(){
		ConfigReader c = new ConfigReader();
		c.setEnvironment(ENVIRONMENT);
		c.setRoot("consts");
		return c;
	}
	
	/**
	 * PropertySourcesPlaceholderConfigurer加载的时候
	 * 若资源文件没有，可以设置在System的Property里面
	 * 优先级System > *.properties > private String pass = "ccsuser2"
	 * 即最终以System为准，参考XmemcachedConfig
	 */
	private static void initPlaceholderConfig(){
		//System.setProperty("memcache.user", "ccsuser2");
	}
	
	public static void main(String[] args) throws Exception {
		long benchmark = System.nanoTime();
		ApplicationContext ctx = new AnnotationConfigApplicationContext(AppConfig.class);
		AppCtxKeeper.init(ctx);
		
		//
		ctx.getBean(CityCache.class).refreshCache();
		ctx.getBean(PhoneBinCache.class).refreshCache();
		
		Log.debug("Time elapsed: " + CurrencyUtil.divide((System.nanoTime() - benchmark),1e9,6)+"s");		
		/*benchmark = System.nanoTime();
		
		CityCache s = ctx.getBean(CityCache.class);
		s.refreshCache();
		Log.debug(CityCache.getNm(36));
		Log.debug(CityCache.getNm(3607));
		Log.debug(CityCache.getNm(360781));
		Log.debug(CityCache.getNm(310115));
		
		Log.debug("Time elapsed: " + CurrencyUtil.divide((System.nanoTime() - benchmark),1e9,6)+"s");*/
		
		Log.debug(CityCache.getCityId(330000, "杭州"));		
		//ClazzHelper.print(PhoneBinCache.get("1730168"));
		
		Log.debug("Dubbo服务启动完毕, listening...");
		System.in.read();//
	}
}
