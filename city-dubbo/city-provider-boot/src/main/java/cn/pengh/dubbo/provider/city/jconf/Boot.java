package cn.pengh.dubbo.provider.city.jconf;

import java.io.IOException;

import org.springframework.boot.SpringApplication;

import cn.pengh.library.Log;

public class Boot {
	public static void main(String[] args) throws IOException {
		SpringApplication.run(AppConfig.class, args);
		Log.debug("Dubbo服务启动完毕, listening...");
		//System.in.read();//
	}
}
