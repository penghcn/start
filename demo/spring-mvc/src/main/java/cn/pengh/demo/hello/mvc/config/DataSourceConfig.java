package cn.pengh.demo.hello.mvc.config;

import cn.pengh.demo.hello.mvc.util.LogUtil;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * @author Created by pengh
 * @datetime 2018/11/15 11:12
 */
@Configuration
public class DataSourceConfig {
    @Value("${dataSource.hellodb.url}")
    private String url;
    @Value("${dataSource.hellodb.username}")
    private String username;
    @Value("${dataSource.hellodb.password}")
    private String password;

    //@Bean
    public HikariDataSource hello1_ds() {
        LogUtil.getLogger().debug("{},{},{}", url, username, password);
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(url);
        config.setUsername(username);
        config.setPassword(password);
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

        return new HikariDataSource(config);
    }
}
