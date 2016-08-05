package cn.pengh.dubbo.provider.city.jconf.ioc;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import cn.pengh.dubbo.provider.city.cache.CityCache;
import cn.pengh.dubbo.provider.city.cache.PhoneBinCache;
import cn.pengh.dubbo.provider.city.service.PhoneBinRealtimeQuery;

@Configuration
public class ServiceConfig {
	
		
	@Bean
	public CityCache cityCache(){
		return new CityCache();
	}
	
	@Bean(initMethod="initSelf")
	public PhoneBinCache phoneBinCache(){
		return new PhoneBinCache();
	}
	
	@Bean
	public PhoneBinRealtimeQuery PhoneBinRealtimeQuery(){
		return new PhoneBinRealtimeQuery();
	}
}
