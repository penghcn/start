# 配置
## web.xml
### 禁用http其他请求类型，仅保留get、post、options
    <security-constraint>     
        <web-resource-collection>     
            <url-pattern>/*</url-pattern>     
            <http-method>PUT</http-method>     
            <http-method>DELETE</http-method>     
            <http-method>HEAD</http-method>        
            <http-method>TRACE</http-method>
        </web-resource-collection>     
        <auth-constraint></auth-constraint>     
    </security-constraint>     
    <login-config>     
        <auth-method>BASIC</auth-method>     
    </login-config>