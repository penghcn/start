package cn.pengh.demo.hello.mvc.config;

import org.springframework.context.annotation.*;

/**
 * @author Created by pengh
 * @datetime 2018/4/19 09:43
 */
@Configuration
@Profile("default")
@PropertySource({"classpath:consts/persistence-development.properties"})

@ImportResource({
        "classpath:bootstrap/applicationContext.xml"/*,
        "classpath:ioc/*.xml"*/
})//加载xml混用的配置

@Import({DataSourceConfig.class})
//@EnableScheduling
@EnableAspectJAutoProxy(proxyTargetClass=true)
public class AppConfig {

}
