https://www.cnblogs.com/hustskyking/p/websocket-with-php.html

下面我画了一个图演示 client 和 server 之间建立 websocket 连接时握手部分，这个部分在 node 中可以十分轻松的完成，因为 node 提供的 net 模块已经对 socket 套接字做了封装处理，开发者使用的时候只需要考虑数据的交互而不用处理连接的建立。而 php 没有，从 socket 的连接、建立、绑定、监听等，这些都需要我们自己去操作，所以有必要拿出来再说一说。

```
    +--------+    1.发送Sec-WebSocket-Key        +---------+
    |        | --------------------------------> |        |
    |        |    2.加密返回Sec-WebSocket-Accept  |        |
    | client | <-------------------------------- | server |
    |        |    3.本地校验                      |        |
    |        | --------------------------------> |        |
    +--------+                                   +--------+
```

看了我写的[上一篇文章](http://www.cnblogs.com/hustskyking/p/websocket-with-node.html)的同学应该是对上图有了比较全面的理解。① 和 ② 实际上就是一个 HTTP 的请求和响应，只不过我们在处理的过程中我们拿到的是没有经过解析的字符串。如：

```
GET /chat HTTP/1.1
Host: server.example.com
Origin: http://example.com
```

我们往常看到的请求是这个样子，当这东西到了服务器端，我们可以通过一些代码库直接拿到这些信息。