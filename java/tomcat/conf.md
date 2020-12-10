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

## conf/server.xml 
    <Server address="0.0.0.0" port="-1" shutdown="SHUTDOWN">

    小型WEB系统配置优化
    <Connector port="8080"   
          maxThreads="50" 
          minSpareThreads="5"   
          acceptCount="1"  
          maxConnections="200"  
          connectionTimeout="2000"  
          URIEncoding="UTF-8" />

    完整配置
    <Connector port="8080"   
          protocol="HTTP/1.1"
          maxThreads="50" 
          minSpareThreads="5"   
          acceptCount="1"  
          maxConnections="500"  
          connectionTimeout="2000"   
          maxHttpHeaderSize="8192"  
          tcpNoDelay="true"  
          compression="on"  
          compressionMinSize="2048"  
          disableUploadTimeout="true"  
          redirectPort="8443"  
          enableLookups="false"  
          URIEncoding="UTF-8" />

    集群中的配置优化
    <Connector port="8080"  
          maxThreads="100"    
          acceptCount="1"  
          maxConnections="500"  
          connectionTimeout="2000"   
          URIEncoding="UTF-8" />

    <Connector port="8080"  
          protocol="HTTP/1.1" 
          maxThreads="100"   
          minSpareThreads="10"   
          acceptCount="1"  
          maxConnections="500"  
          connectionTimeout="2000"   
          maxHttpHeaderSize="8192"  
          tcpNoDelay="true"  
          compression="on"  
          compressionMinSize="2048"  
          disableUploadTimeout="true"  
          redirectPort="8443"  
          enableLookups="false"  
          URIEncoding="UTF-8" />

