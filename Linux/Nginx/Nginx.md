# Nginx 

今天要讲的是Nginx最重要的一块——配置反向代理服务器。
 Nginx的负载均衡功能和代理功能是经常被用到的。本文会先将如何配置反向代理，然后讲一下负载均衡。

## 反向代理

反向代理（Reverse Proxy）方式是指以代理服务器来接受Internet上的连接请求，然后将请求转发给内部网络上的服务器；

反向代理的一个好处就是挺高网站性能啦。个人比较同意知乎上高票的[Nginx 反向代理为什么可以提高网站性能？的回答](https://link.jianshu.com?t=ttps://www.zhihu.com/question/19761434)

> Nginx 的优势是在于它的异步阻塞模型，可以通过基于事件的方式同时处理和维护多个请求，而后端只要去做逻辑计算，节约等待时间去处理更多请求。
>
> ![img](https:////upload-images.jianshu.io/upload_images/5611237-beceff419cadf925.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1006/format/webp)
>
> 20160202191131_71.jpg

## 配置说明

要想配置反向代理，首先要掌握基本配置规范，基本的反向代理配置很简单，但是如果要仔细配置也可以做到很复杂。
 官网给出反向代理的最简单的代码例子。([https://www.nginx.com/resources/admin-guide/reverse-proxy/](https://link.jianshu.com?t=https://www.nginx.com/resources/admin-guide/reverse-proxy/))



```cpp
 location /some/path/ {
    proxy_pass http://www.example.com/link/;
}
```

但是在互联网公司你看到的反向代理配置往往是这样的：



```php
upstream baidunode {
server 172.25.0.105:8081 weight=10 max_fails=3     fail_timeout=30s;
}
location / {
    add_header Cache-Control no-cache;
    proxy_redirect off;
    proxy_set_header   Host $host;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
   proxy_set_header   X-Real-IP        $remote_addr;
   proxy_pass         http://192.168.1.20;
   proxy_connect_timeout 30s;
 }
```

下面就代码里的配置做说明：
 nginx配置文件通过使用`add_header`指令来设置response header，response header一般都是以key：value的形式，例如：“Content-Encoding：gzip、Cache-Control:no-store”，设置的命令为：



```undefined
add_header Cache-Control no-store
add_header Content-Encoding gzip
```

nginx 为实现反向代理的需求增加了一个 [ngx_http_proxy_module 模块](https://link.jianshu.com?t=http://nginx.org/en/docs/http/ngx_http_proxy_module.html)。其中 proxy_set_header 指令就是该模块需要读取的配置。
 现在对每句配置做个说明

- `proxy_set_header Host local.baidu.com;`
   HTTP header 中的 Host 含义为所请求的目的主机名。当 nginx 作为反向代理使用，而后端真实 web 服务器设置有类似 **防盗链功能** ，或者根据 HTTP header 中的 Host 字段来进行 **路由** 或 **过滤** 功能的话，若作为反向代理的 nginx 不重写请求头中的 Host 字段，将会导致请求失败。
- `proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;`
   HTTP header 中的  X_Forward_For  表示该条 http 请求是由谁发起的。如果反向代理服务器不重写该请求头的话，那么后端真实 web 服务器在处理时会认为所有的请求都来自反向代理服务器。如果后端 web 服务器有防攻击策略的话，那么反向代理服务器对应的 ip 地址就会被封掉。
   上述配置的意思是增加一个 `$proxy_add_x_forwarded_for` 到 `X-Forwarded-For`里去，注意是增加，而不是覆盖。当然由于默认的 `X-Forwarded-For` 值是空的，所以我们总感觉 `X-Forwarded-For` 的值就等于 `$proxy_add_x_forwarded_for` 的值。
   `X-Forwarded-For`的格式为`X-Forwarded-For:real client ip, proxy ip 1, proxy ip N`，每经过一个反向代理就在请求头X-Forwarded-For后追加反向代理IP。
- `proxy_connect_timeout`
   nginx服务器与被代理的服务器建立连接的超时时间，默认60秒

### 例子

如果只看上面的配置解释不容易理解，下面给一个具体的关于获取客户端真实ip的例子
 下图所示是一个请求进来经过Nginx的流程示意图



![img](https:////upload-images.jianshu.io/upload_images/5611237-ad37e308472d53c5.jpeg?imageMogr2/auto-orient/strip|imageView2/2/w/524/format/webp)

20170106092746328.jpeg

如果我们把三个反向代理的配置如下：



```bash
Nginx Proxy
192.168.107.107 nginx.conf
location /test {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://192.168.107.112:8080;
}
192.168.107.112 nginx.conf
location /test {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://192.168.107.114:8080;
}
Nginx Backend
192.168.107.114 nginx.conf
location /test {
    default_type text/html;
    charset gbk;
    echo "$remote_addr ||$http_x_real_ip  ||$http_x_forwarded_for";
}
```

当访问服务的时候输出为



```ruby
192.168.107.112 || 192.168.162.16 || 192.168.162.16, 192.168.107.107
```

> 分析
>  1.在离用户最近的反向代理NginxProxy 1，通过`“proxy_set_header X-Real-IP $remote_addr”`把真实客户端IP写入到请求头X-Real-IP，在NginxBackend输出`$http_x_real_ip`获取到了真实客户端IP；而Nginx Backend的`“$remote_addr”`输出为最后一个反向代理的IP；
>  2.`“proxy_set_headerX-Forwarded-For $proxy_add_x_forwarded_for”`的是把请求头中的X-Forwarded-For与`$remote_addr`用逗号合起来，如果请求头中没有X-Forwarded-For则`$proxy_add_x_forwarded_for为$remote_addr`。
>  　`X-Forwarded-For`代表了客户端IP，反向代理如Nginx通过`$proxy_add_x_forwarded_for`添加此项，`X-Forwarded-For`的格式为`X-Forwarded-For:real client ip, proxy ip 1, proxy ip N`，每经过一个反向代理就在请求头X-Forwarded-For后追加反向代理IP。
>  　到此我们可以使用请求头X-Real-IP和X-Forwarded-For来获取客户端IP及客户端到服务端经过的反向代理IP了。这种方式还是很麻烦，$remote_addr并不是真实客户端IP。

为了更方便的获取真实客户端IP，可以使用nginx http_realip_module模块解决，在安装nginx时通过–with-http_realip_module安装该模块。NginxProxy配置和场景2一样。



```bash
Nginx Backend
192.168.107.114 nginx.conf
real_ip_header X-Forwarded-For; 
set_real_ip_from 192.168.0.0/16; 
real_ip_recursive on; 

location /test {
    default_type text/html;
    charset gbk;
    echo "$remote_addr || $http_x_real_ip  ||$http_x_forwarded_for";
}
```

具体分析可以参照该博客
 [http://blog.csdn.net/broadview2006/article/details/54570943](https://link.jianshu.com?t=http://blog.csdn.net/broadview2006/article/details/54570943)

其实还有很多配置 具体说明可以参考该博客[http://www.cnblogs.com/knowledgesea/p/5199046.html](https://link.jianshu.com?t=http://www.cnblogs.com/knowledgesea/p/5199046.html)



```csharp
include       mime.types;   #文件扩展名与文件类型映射表
    default_type  application/octet-stream; #默认文件类型，默认为text/plain
    #access_log off; #取消服务日志    
    log_format myFormat ' $remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
    access_log log/access.log myFormat;  #combined为日志格式的默认值
    sendfile on;   #允许sendfile方式传输文件，默认为off，可以在http块，server块，location块。
    sendfile_max_chunk 100k;  #每个进程每次调用传输数量不能大于设定的值，默认为0，即不设上限。
    keepalive_timeout 65;  #连接超时时间，默认为75s，可以在http，server，location块。
    proxy_connect_timeout 1;   #nginx服务器与被代理的服务器建立连接的超时时间，默认60秒
    proxy_read_timeout 1; #nginx服务器想被代理服务器组发出read请求后，等待响应的超时间，默认为60秒。
    proxy_send_timeout 1; #nginx服务器想被代理服务器组发出write请求后，等待响应的超时间，默认为60秒。
    proxy_http_version 1.0 ; #Nginx服务器提供代理服务的http协议版本1.0，1.1，默认设置为1.0版本。
    #proxy_method get;    #支持客户端的请求方法。post/get；
    proxy_ignore_client_abort on;  #客户端断网时，nginx服务器是否终端对被代理服务器的请求。默认为off。
    proxy_ignore_headers "Expires" "Set-Cookie";  #Nginx服务器不处理设置的http相应投中的头域，这里空格隔开可以设置多个。
    proxy_intercept_errors on;    #如果被代理服务器返回的状态码为400或者大于400，设置的error_page配置起作用。默认为off。
    proxy_headers_hash_max_size 1024; #存放http报文头的哈希表容量上限，默认为512个字符。
    proxy_headers_hash_bucket_size 128; #nginx服务器申请存放http报文头的哈希表容量大小。默认为64个字符。
    proxy_next_upstream timeout;  #反向代理upstream中设置的服务器组，出现故障时，被代理服务器返回的状态值。error|timeout|invalid_header|http_500|http_502|http_503|http_504|http_404|off
    #proxy_ssl_session_reuse on; 默认为on，如果我们在错误日志中发现“SSL3_GET_FINSHED:digest check failed”的情况时，可以将该指令设置为off。
```

> 总结：proxy_set_header 就是可设置请求头-并将头信息传递到服务器端。不属于请求头的参数中也需要传递时 重定义下就行啦。

## 负载均衡

Nginx提供了两种负载均衡策略：内置策略和扩展策略。内置策略为轮询，加权轮询，Ip hash。扩展策略，就是自己实现一套策略。
 大家可以通过upstream这个配置，写一组被代理的服务器地址，然后配置负载均衡的算法。

### 热备

当一台服务器发生事故时，才启用第二台服务器给提供服务。
 比如127.0.0.1 挂了，就启动192.168.10.121。



```bash
upstream mysvr { 
      server 127.0.0.1:7878; 
      server 192.168.10.121:3333 backup;  #热备     
    }
```

### 轮询

Nginx 轮询的默认权重是1。 所以请求顺序就是ABABAB....交替



```undefined
upstream mysvr { 
      server 127.0.0.1:7878;
      server 192.168.10.121:3333;       
    }
```

![img](https:////upload-images.jianshu.io/upload_images/5611237-89aab059c0277416.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

20160202191132_915.jpg

### 加权轮询

根据权重大小，分发给不同服务器不同数量请求。如下配置的请求顺序为：ABBABBABBABB.....。可以针对不同服务器的性能，配置不同的权重。



```undefined
 upstream mysvr { 
      server 127.0.0.1:7878 weight=1;
      server 192.168.10.121:3333 weight=2;
}
```

![img](https:////upload-images.jianshu.io/upload_images/5611237-461a0b28829f8164.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

20160202191133_979.jpg

### ip_hash

让相同客户端ip请求相同的服务器。对客户端请求的ip进行hash操作，然后根据hash结果将同一个客户端ip的请求分发给同一台服务器进行处理，**可以解决session不共享的问题**。



```undefined
upstream mysvr { 
      server 127.0.0.1:7878; 
      server 192.168.10.121:3333;
      ip_hash;
    }
```

![img](https:////upload-images.jianshu.io/upload_images/5611237-73b8d8cba44a31b8.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

20160202191133_379.jpg

------

感谢阅读nginx配置反向代理服务器，下一篇文章将介绍如何配置Nginx缓存。



作者：樂浩beyond
链接：https://www.jianshu.com/p/e98e84a3322f
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。