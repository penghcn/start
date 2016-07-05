package cn.pengh.dubbo.consumer.city;

import com.alibaba.dubbo.rpc.RpcContext;

import cn.pengh.dubbo.api.city.CityRequest;
import cn.pengh.dubbo.api.city.CityService;
import cn.pengh.dubbo.consumer.city.helper.RegisterHelper;
import cn.pengh.helper.ClazzHelper;
import cn.pengh.library.Log;
import cn.pengh.mvc.core.listener.AppCtxKeeper;

public class Demo {
	private CityService cityService ;
	public String get(int id){
		return cityService.get(new CityRequest(36)).getNm();
	}
	
	
	public static void main(String[] args) {
		//final String port = "8888";
		
		//测试常规服务
		RegisterHelper.init();
        CityService cityService = AppCtxKeeper.getBean(CityService.class);
        
        Log.debug(RpcContext.getContext().isConsumerSide());
        
        ClazzHelper.print(cityService.get(new CityRequest(36)));
        ClazzHelper.print(cityService.get(new CityRequest(3607)));
        ClazzHelper.print(cityService.get(new CityRequest(360782)));
        ClazzHelper.print(cityService.get(new CityRequest(310115)));
        
        Log.debug(RpcContext.getContext().isConsumerSide());
	}
}
