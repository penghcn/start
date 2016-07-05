package cn.pengh.dubbo.provider.city.jconf.ioc;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import cn.pengh.dubbo.provider.city.cache.CityCache;

@Configuration
public class ServiceConfig {
	
		
	@Bean
	public CityCache cityCache(){
		return new CityCache();
	}
}
