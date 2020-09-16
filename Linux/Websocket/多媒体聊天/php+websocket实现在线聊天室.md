聊天室最终实现版:https://www.sinight.site/chatroom
可以自己多开几个窗口体验

> 前言:WebSocket是HTML5开始提供的一种在单个 TCP 连接上进行全双工通讯的协议。
> 在WebSocket API中，浏览器和服务器只需要做一个握手的动作，然后，浏览器和服务器之间就形成了一条快速通道。两者之间就直接可以数据互相传送。
> 浏览器通过 JavaScript 向服务器发出建立 WebSocket 连接的请求，连接建立以后，客户端和服务器端就可以通过 TCP 连接直接交换数据。

### 1.为什么需要websocket

熟悉web开发的朋友明白，平时我们与服务端的数据请求都是基于HTTP协议，而HTTP协议，通信请求只能由客户端发起，服务端对请求做出应答处理。也就是说服务端不能主动向我们推送数据，而像即时通讯这类应用又有这个需求，因此websocket协议应运而生。

### 2.websocket连接如何建立

websocket协议是建立在HTTP协议之上的，准确来说是从HTTP协议升级为websocket协议。当客户端想与服务端建立websocekt连接时，会先向服务端发起一个普通的HTTP请求，大致内容如下:

> GET / HTTP/1.1
> Host: localhost:1234
> User-Agent: Mozilla/5.0 (WindowsNT 10.0; WOW64; rv:59.0) Gecko/20100101 Firefox/59.0
> Accept:text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
> Accept-Language:zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
> Accept-Encoding: gzip, deflate
> Sec-WebSocket-Version: 13
> Origin:[http://xxx.xxx.xxx](http://xxx.xxx.xxx/)
> Sec-WebSocket-Extensions: permessage-deflate
> Sec-WebSocket-Key: 3hfEc+Te7n7FSrLBsN59ig==
> Connection: keep-alive,Upgrade
> Pragma: no-cache
> Cache-Control: no-cache
> Upgrade: websocket

它比我们平时时的http请求头多了一些东西:

> Sec-WebSocket-Version: 13
> Sec-WebSocket-Extensions: permessage-deflate
> Sec-WebSocket-Key: 3hfEc+Te7n7FSrLBsN59ig==
> Connection: keep-alive,Upgrade
> Upgrade: websocket

`Upgrade: websocket,Connection: Upgrade`就告诉了服务端，客户端想从HTTP协议升级到websocket协议，`Sec-WebSocket-Key`头的内容是浏览器随机生成的经过`base64`编码的值。服务端收到这样请求后就回一个固定格式的消息，然后客户端与服务端就建立起了websocket连接，之后的消息传递就遵从websocket协议，这就是我们所说的webscoket一次握手，服务端回应的消息格式如下:

> HTTP/1.1 101 Switching Protocols
> Upgrade: websocket
> Sec-WebSocket-Version: 13
> Connection: Upgrade
> Sec-WebSocket-Accept:`new-key`

`new-key`的值通过先获取客户端请求头里面的`Sec-WebSocket-Key`值与`258EAFA5-E914-47DA-95CA-C5AB0DC85B11`进行字符串连接后进行`sha1`加密，再`base64`编码得到。
php代码如下:

```php
$new_key = base64_encode(sha1($key."258EAFA5-E914-47DA-95CA-C5AB0DC85B11",true));1
```

### 3.如何使用websocket

**客户端:**
客户端，js提供了接口，我们主要用的有三个（详细的可以自行上菜鸟教程查看）：
1)`var ws = new WebSocket("ws://localhost:9998/echo");`建立websocket连接

> 参数是个url：协议://域名(或者ip):端口/路径
> webscoket支持ws和wss对应着http和https(后面服务器部署时再具体讲)

2)`ws.onmessage = function (evt) {var received_msg = evt.data;alert("数据已接收...");};`
这个回调函数用于接收服务端消息
3)`ws.send("发送数据");`这个函数用于向服务端发送数据
**服务端：**
服务端我们可以选择用现成的库，也可以自己写，这里我们自己写一个，服务端本质也是一个socket(不熟悉php socket可以自行百度下，这里就不再赘述)，不过与客户端进行数据传输的时候要遵从websocket协议消息格式。通过上面我们知道，要想建立websocket连接，服务端需要回应客户端的握手消息。
建立server.php:

```php
class WebSocketServer{
    private $sockets;//所有socket连接池包括服务端socket
    private $users;//所有连接用户
    private $server;//服务端 socket

    public function __construct($ip,$port){
        $this->server=socket_create(AF_INET,SOCK_STREAM,0);
        $this->sockets=array($this->server);
        $this->users=array();
        socket_bind($this->server,$ip,$port);
        socket_listen($this->server,3);
        echo "[*]Listening:".$ip.":".$port."\n";
    }

    public function run(){
        $write=NULL;
        $except=NULL;
        while (true){
            $active_sockets=$this->sockets;
            socket_select($active_sockets,$write,$except,NULL);
            //这个函数很重要
            //前三个参数时传入的是数组的引用,会依次从传入的数组中选择出可读的,可写的,异常的socket,我们只需要选择出可读的socket
            //最后一个参数tv_sec很重要
            //第一，若将NULL以形参传入，即不传入时间结构，就是将select置于阻塞状态，一定等到监视文件描述符集合(socket数组)中某个文件描
            //述符发生变化为止；
            //第二，若将时间值设为0秒0毫秒，就变成一个纯粹的非阻塞函数，不管文件描述符是否有变化，都立刻返回继续执行，文件无
            //变化返回0，有变化返回一个正值；
            //第三，timeout的值大于0，这就是等待的超时时间，即 select在timeout时间内阻塞，超时时间之内有事件到来就返回了，
            //否则在超时后不管怎样一定返回，返回值同上述。
            foreach ($active_sockets as $socket){
                if ($socket==$this->server){
                    //服务端 socket可读说明有新用户连接
                    $user=socket_accept($this->server);
                    $key=uniqid();
                    $this->sockets[]=$user;
                    $this->users[$key]=array(
                        'socket'=>$user,
                        'handshake'=>false //是否完成websocket握手
                    );
                }else{
                    //用户socket可读
                    $buffer='';
                    $bytes=socket_recv($socket,$buffer,1024,0);
                    $key=$this->find_user_by_socket($socket); //通过socket在users数组中找出user
                    if ($bytes==0){
                        //没有数据 关闭连接
                        $this->disconnect($socket);
                    }else{
                        //没有握手就先握手
                        if (!$this->users[$key]['handshake']){
                            $this->handshake($key,$buffer);
                        }else{
                            //握手后 
                            //解析消息 websocket协议有自己的消息格式
                            //解码 编码过程固定的
                            $msg=$this->msg_decode($buffer);
                            echo $msg;
                            //编码后发送回去
                            $res_msg=$this->msg_encode($msg);
                            socket_write($socket,$res_msg,strlen($res_msg));

                        }
                    }
                }
            }
        }
    }

    //解除连接
    private function disconnect($socket){
        $key=$this->find_user_by_socket($socket);
        unset($this->users[$key]);
        foreach ($this->sockets as $k=>$v){
            if ($v==$socket)
                unset($this->sockets[$k]);
        }
        socket_shutdown($socket);
        socket_close($socket);
    }

    //通过socket在users数组中找出user
    private function find_user_by_socket($socket){
        foreach ($this->users as $key=>$user){
            if ($user['socket']==$socket){
                return $key;
            }
        }
        return -1;
    }

    private function handshake($k,$buffer){
        //截取Sec-WebSocket-Key的值并加密
        $buf  = substr($buffer,strpos($buffer,'Sec-WebSocket-Key:')+18);
        $key  = trim(substr($buf,0,strpos($buf,"\r\n")));
        $new_key = base64_encode(sha1($key."258EAFA5-E914-47DA-95CA-C5AB0DC85B11",true));

        //按照协议组合信息进行返回
        $new_message = "HTTP/1.1 101 Switching Protocols\r\n";
        $new_message .= "Upgrade: websocket\r\n";
        $new_message .= "Sec-WebSocket-Version: 13\r\n";
        $new_message .= "Connection: Upgrade\r\n";
        $new_message .= "Sec-WebSocket-Accept: " . $new_key . "\r\n\r\n";
        socket_write($this->users[$k]['socket'],$new_message,strlen($new_message));

        //对已经握手的client做标志
        $this->users[$k]['handshake']=true;
        return true;
    }


    //编码 把消息打包成websocket协议支持的格式
    private function msg_encode( $buffer ){
        $len = strlen($buffer);
        if ($len <= 125) {
            return "\x81" . chr($len) . $buffer;
        } else if ($len <= 65535) {
            return "\x81" . chr(126) . pack("n", $len) . $buffer;
        } else {
            return "\x81" . char(127) . pack("xxxxN", $len) . $buffer;
        }
    }

    //解码 解析websocket数据帧
    private function msg_decode( $buffer )
    {
        $len = $masks = $data = $decoded = null;
        $len = ord($buffer[1]) & 127;
        if ($len === 126) {
            $masks = substr($buffer, 4, 4);
            $data = substr($buffer, 8);
        }
        else if ($len === 127) {
            $masks = substr($buffer, 10, 4);
            $data = substr($buffer, 14);
        }
        else {
            $masks = substr($buffer, 2, 4);
            $data = substr($buffer, 6);
        }
        for ($index = 0; $index < strlen($data); $index++) {
            $decoded .= $data[$index] ^ $masks[$index % 4];
        }
        return $decoded;
    }
}

$ws=new WebSocketServer('127.0.0.1',1234);
$ws->run();
123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100101102103104105106107108109110111112113114115116117118119120121122123124125126127128129130131132133134135136137138139140141142143144145146147148149
```

终于到了收获的时候了，赶快来运行一下吧，先运行服务端，在命令行里执行`php server.php`，成功后显示如下:
![这里写图片描述](https://img-blog.csdn.net/2018041623544958?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzMzQ0MTIx/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
接下来就是客户端了，websocket是支持跨域的，所以我们随便找个不是https的网站(https网站只能使用wss)，菜鸟教程就可以，f12，打开开发者工具，在console里依次执行如下代码:

> var ws = new WebSocket(“ws://localhost:1234”);
> ws.onmessage = function (evt)
> {
> var received_msg = evt.data;
> alert(received_msg);
> };
> ws.send(“hello world”);

![这里写图片描述](https://img-blog.csdn.net/20180417000139393?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzMzQ0MTIx/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
![这里写图片描述](https://img-blog.csdn.net/20180417000236854?watermark/2/text/aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzMzQ0MTIx/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70)
多么令人兴奋的事，成功的进行了数据传输，这样我们就把服务端基本结构写好了，下一篇博客，我们将会把它丰富起来，来完成在线聊天室。