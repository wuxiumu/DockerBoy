**一、socket协议的简介**

**WebSocket是什么，有什么优点**

WebSocket是一个持久化的协议，这是相对于http非持久化来说的。应用层协议

举个简单的例子，http1.0的生命周期是以request作为界定的，也就是一个request，一个response，对于http来说，本次client与server的会话到此结束；而在http1.1中，稍微有所改进，即添加了keep-alive，也就是在一个http连接中可以进行多个request请求和多个response接受操作。然而在实时通信中，并没有多大的作用，http只能由client发起请求，server才能返回信息，即server不能主动向client推送信息，无法满足实时通信的要求。而WebSocket可以进行持久化连接，即client只需进行一次握手，成功后即可持续进行数据通信，值得关注的是WebSocket实现client与server之间全双工通信，即server端有数据更新时可以主动推送给client端。

**二、介绍client与server之间的socket连接原理**

**1、下面是一个演示client和server之间建立WebSocket连接时握手部分**



![img](https:////upload-images.jianshu.io/upload_images/3113815-24de65a8cc5170ca.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/409/format/webp)

**image**



**2、client与server建立socket时握手的会话内容，即request与response**

**a、client建立WebSocket时向服务器端请求的信息**

GET /chat HTTP/1.1
 　Host: server.example.com
 　Upgrade: websocket //告诉服务器现在发送的是WebSocket协议
 　Connection: Upgrade
 　Sec-WebSocket-Key: x3JJHMbDL1EzLkh9GBhXDw== //是一个Base64 encode的值，这个是浏览器随机生成的，用于验证服务器端返回数据是否是WebSocket助理
 　Sec-WebSocket-Protocol: chat, superchat
 　Sec-WebSocket-Version: 13
 　Origin: http://example.com

**b、服务器获取到client请求的信息后，根据WebSocket协议对数据进行处理并返回，其中要对Sec-WebSocket-Key进行加密等操作**

HTTP/1.1 101 Switching Protocols
 　Upgrade: websocket //依然是固定的，告诉客户端即将升级的是Websocket协议，而不是mozillasocket，lurnarsocket或者shitsocket
 　Connection: Upgrade
 　Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk= //这个则是经过服务器确认，并且加密过后的 Sec-WebSocket-Key,也就是client要求建立WebSocket验证的凭证
 　Sec-WebSocket-Protocol: chat

**3、socket建立连接原理图：**



![img](https:////upload-images.jianshu.io/upload_images/3113815-8d619232616ba965.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/605/format/webp)

**image**



**三、PHP中建立websocket的过程讲解**
 SocketService.php:



```php
<?php
class SocketService
{
  private $address = '0.0.0.0';
  private $port = 8083;
  private $_sockets;
  public function __construct($address = '', $port='')
  {
      if(!empty($address)){
        $this->address = $address;
      }
      if(!empty($port)) {
        $this->port = $port;
      }
  }

  public function service(){
    //获取tcp协议号码。
    $tcp = getprotobyname("tcp");
    $sock = socket_create(AF_INET, SOCK_STREAM, $tcp);
    socket_set_option($sock, SOL_SOCKET, SO_REUSEADDR, 1);
    if($sock < 0)
    {
      throw new Exception("failed to create socket: ".socket_strerror($sock)."\n");
    }
    socket_bind($sock, $this->address, $this->port);
    socket_listen($sock, $this->port);
    echo "listen on $this->address $this->port ... \n";
    $this->_sockets = $sock;
  }

  public function run(){
    $this->service();
    $clients[] = $this->_sockets;
    while (true){
      $changes = $clients;
      $write = NULL;
      $except = NULL;
//当select处于等待时,两个客户端中甲先发数据来,则socket_select会在$changes中保留甲的socket并往下运行,另一个客户端的socket就被丢弃了,所以再次循环时,变成只监听甲了,这个可以在新循环中把所有链接的客户端socket再次加进$changes中,则可以避免本程序的这个逻辑错误
      /** socket_select是阻塞，有数据请求才处理，否则一直阻塞
       * 此处$changes会读取到当前活动的连接
       * 比如执行socket_select前的数据如下(描述socket的资源ID)：
       * $socket = Resource id #4
       * $changes = Array
       *       (
       *           [0] => Resource id #5 //客户端1
       *           [1] => Resource id #4 //server绑定的端口的socket资源
       *       )
       * 调用socket_select之后，此时有两种情况：
       * 情况一：如果是新客户端2连接，那么 $changes = array([1] => Resource id #4),此时用于接收新客户端2连接
       * 情况二：如果是客户端1(Resource id #5)发送消息，那么$changes = array([1] => Resource id #5)，用户接收客户端1的数据
       *
       * 通过以上的描述可以看出，socket_select有两个作用，这也是实现了IO复用
       * 1、新客户端来了，通过 Resource id #4 介绍新连接，如情况一
       * 2、已有连接发送数据，那么实时切换到当前连接，接收数据，如情况二*/
      socket_select($changes, $write, $except, NULL);
      foreach ($changes as $key => $_sock){
        if($this->_sockets == $_sock){ //判断是不是新接入的socket
          if(($newClient = socket_accept($_sock)) === false){
            die('failed to accept socket: '.socket_strerror($_sock)."\n");
          }
          $line = trim(socket_read($newClient, 1024));
          if($line === false){
             socket_shutdown($newClient);
             socket_close($newClient);
             continue;
          }  
          $this->handshaking($newClient, $line);
          //获取client ip
          socket_getpeername ($newClient, $ip);
          $clients[$ip] = $newClient;
          echo "Client ip:{$ip}  \n";
          echo "Client msg:{$line} \n";
        } else {
          $byte = socket_recv($_sock, $buffer, 2048, 0);
          if($byte < 7) continue;
          $msg = $this->message($buffer);
          //在这里业务代码
          echo "{$key} clinet msg:",$msg,"\n";
          fwrite(STDOUT, 'Please input a argument:');
          $response = trim(fgets(STDIN));
          $this->send($_sock, $response);
          echo "{$key} response to Client:".$response,"\n";
        }
      }
    }
  }

  /**
   * 握手处理
   * @param $newClient socket
   * @return int 接收到的信息
   */
  public function handshaking($newClient, $line){

    $headers = array();
    $lines = preg_split("/\r\n/", $line);
    foreach($lines as $line)
    {
      $line = rtrim($line);
      if(preg_match('/^(\S+): (.*)$/', $line, $matches))
      {
        $headers[$matches[1]] = $matches[2];
      }
    }
    $secKey = $headers['Sec-WebSocket-Key'];
    $secAccept = base64_encode(pack('H*', sha1($secKey . '258EAFA5-E914-47DA-95CA-C5AB0DC85B11')));
    $upgrade = "HTTP/1.1 101 Web Socket Protocol Handshake\r\n" .
      "Upgrade: websocket\r\n" .
      "Connection: Upgrade\r\n" .
      "WebSocket-Origin: $this->address\r\n" .
      "WebSocket-Location: ws://$this->address:$this->port/websocket/websocket\r\n".
      "Sec-WebSocket-Accept:$secAccept\r\n\r\n";
    return socket_write($newClient, $upgrade, strlen($upgrade));
  }

  /**
   * 解析接收数据
   * @param $buffer
   * @return null|string
   */
  public function message($buffer){
    $len = $masks = $data = $decoded = null;
    $len = ord($buffer[1]) & 127;
    if ($len === 126) {
      $masks = substr($buffer, 4, 4);
      $data = substr($buffer, 8);
    } else if ($len === 127) {
      $masks = substr($buffer, 10, 4);
      $data = substr($buffer, 14);
    } else {
      $masks = substr($buffer, 2, 4);
      $data = substr($buffer, 6);
    }
    for ($index = 0; $index < strlen($data); $index++) {
      $decoded .= $data[$index] ^ $masks[$index % 4];
    }
    return $decoded;
  }

  /**
   * 发送数据
   * @param $newClinet 新接入的socket
   * @param $msg  要发送的数据
   * @return int|string
   */
  public function send($newClinet, $msg){
    $msg = $this->frame($msg);
    socket_write($newClinet, $msg, strlen($msg));
  }

  public function frame($s) {
    $a = str_split($s, 125);
    if (count($a) == 1) {
      return "\x81" . chr(strlen($a[0])) . $a[0];
    }
    $ns = "";
    foreach ($a as $o) {
      $ns .= "\x81" . chr(strlen($o)) . $o;
    }
    return $ns;
  }

  /**
   * 关闭socket
   */
  public function close(){
    return socket_close($this->_sockets);
  }
}

$sock = new SocketService();
$sock->run();
```

web.html:



```html
<!doctype html>
<html lang="en">
 <head>
 <meta charset="UTF-8">
 <meta name="viewport" content="width=device-width,initial-scale=1, maximum-scale=1, user-scalable=no">
 <title>websocket</title>
 </head>
 <body>
 <input id="text" value="">
 <input type="submit" value="send" onclick="start()">
 <input type="submit" value="close" onclick="close()">
<div id="msg"></div>
 <script>
 /**
webSocket.readyState
 0：未连接
 1：连接成功，可通讯
 2：正在关闭
 3：连接已关闭或无法打开
*/

  //创建一个webSocket 实例
  var webSocket = new WebSocket("ws://192.168.31.152:8083");


  webSocket.onerror = function (event){
    onError(event);
  };

  // 打开websocket
  webSocket.onopen = function (event){
    onOpen(event);
  };

  //监听消息
  webSocket.onmessage = function (event){
    onMessage(event);
  };


  webSocket.onclose = function (event){  //服务端关闭后 触发
    onClose(event);
  }

  //关闭监听websocket
  function onError(event){
    document.getElementById("msg").innerHTML = "<p>close</p>";
    console.log("error"+event.data);
  };

  function onOpen(event){
    console.log("open:"+sockState());
    document.getElementById("msg").innerHTML = "<p>Connect to Service</p>";
  };
  function onMessage(event){
    console.log("onMessage");
    document.getElementById("msg").innerHTML += "<p>response:"+event.data+"</p>"
  };

  function onClose(event){
    document.getElementById("msg").innerHTML = "<p>close</p>";
    console.log("close:"+sockState());
    webSocket.close();
  }

  function sockState(){
    var status = ['未连接','连接成功，可通讯','正在关闭','连接已关闭或无法打开'];
      return status[webSocket.readyState];
  }


 function start(event){
    console.log(webSocket);
    var msg = document.getElementById('text').value;
    document.getElementById('text').value = '';
    console.log("send:"+sockState());
    console.log("msg="+msg);
    webSocket.send("msg="+msg);
    document.getElementById("msg").innerHTML += "<p>request"+msg+"</p>"
  };

  function close(event){
    webSocket.close();
  }
 </script>
 </body>
</html>
```



作者：金星show
链接：https://www.jianshu.com/p/ae0cf2eac759
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。