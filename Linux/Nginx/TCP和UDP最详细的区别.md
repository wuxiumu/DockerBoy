TCP UDP

TCP和UDP的区别
 tcp连接就像打电话，两者之间必须有一条不间断的通路，数据不到达对方，对方
 就一直在等待，除非对方直接挂电话。先说的话先到，后说的话后到，有顺序。

udp就象寄一封信，发信者只管发，不管到。但是你的信封上必须写明对方的地址。
 发信者和收信者之间没有通路，靠邮电局联系。信发到时可能已经过了很久，也可
 能根本没有发到。先发的信未必先到，后发的也未必后到。

 说的很简单，具体的东西当然很复杂。但是java把所有的操作都封装好了，用起
 来到挺方便的

TCP---[传输控制协议](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3D%E4%BC%A0%E8%BE%93%E6%8E%A7%E5%88%B6%E5%8D%8F%E8%AE%AE%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao),提供的是面向连接、可靠的字节流服务。当客户和服务器彼此交换数据前，必须先在双方之间建立一个TCP连接，之后才能传输数据。TCP提供超时重发，丢弃重复数据，检验数据，[流量控制](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3D%E6%B5%81%E9%87%8F%E6%8E%A7%E5%88%B6%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao)等功能，保证数据能从一端传到另一端。
 UDP---[用户数据报协议](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3D%E7%94%A8%E6%88%B7%E6%95%B0%E6%8D%AE%E6%8A%A5%E5%8D%8F%E8%AE%AE%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao)，是一个简单的面向数据报的运输层协议。UDP不提供可靠性，它只是把应用程序传给IP层的数据报发送出去，但是并不能保证它们能到达目的地。由于UDP在传输数据报前不用在客户和服务器之间建立一个连接，且没有超时重发等机制，故而[传输速度](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3D%E4%BC%A0%E8%BE%93%E9%80%9F%E5%BA%A6%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao)很快。

用TCP还是UDP，那要看你的程序注重哪一个方面？可靠还是快速？

说到TCP和UDP,首先要明白“连接”和“无连接”的含义，他们的关系可以用一个形象地比喻来说明，就是打电话和写信。两个人如果要通话，首先要建立连接——即打电话时的拨号，等待响应后——即接听电话后，才能相互传递信息，最后还要断开连接——即挂电话。写信就比较简单了，填写好收信人的地址后将信投入邮筒，收信人就可以收到了。从这个分析可以看出，建立连接可以在需要痛心地双方建立一个传递信息的通道，在发送方发送请求连接信息接收方响应后，由于是在接受方响应后才开始传递信息，而且是在一个通道中传送，因此接受方能比较完整地收到发送方发出的信息，即信息传递的可靠性比较高。但也正因为需要建立连接，使资源开销加大（在建立连接前必须等待接受方响应，传输信息过程中必须确认信息是否传到及断开连接时发出相应的信号等），独占一个通道，在断开连接钱不能建立另一个连接，即两人在通话过程中第三方不能打入电话。而无连接是一开始就发送信息（严格说来，这是没有开始、结束的），只是一次性的传递，是先不需要接受方的响应，因而在一定程度上也无法保证信息传递的可靠性了，就像写信一样，我们只是将信寄出去，却不能保证收信人一定可以收到。
 TCP是面向连接的，有比较高的可靠性，
 一些要求比较高的服务一般使用这个协议，如FTP、Telnet、SMTP、HTTP、POP3等，而UDP是面向无连接的，使用这个协议的常见服务有DNS、SNMP、QQ等。对于QQ必须另外说明一下，QQ2003以前是只使用[UDP协议](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3DUDP%E5%8D%8F%E8%AE%AE%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao)的，其服务器使用8000端口，侦听是否有信息传来，客户端使用4000端口，向外发送信息（这也就不难理解在一般的显IP的QQ版本中显示好友的IP地址信息中端口常为4000或其后续端口的原因了），即QQ程序既接受服务又提供服务，在以后的QQ版本中也支持使用[TCP协议](https://links.jianshu.com/go?to=https%3A%2F%2Fwww.baidu.com%2Fs%3Fwd%3DTCP%E5%8D%8F%E8%AE%AE%26tn%3DSE_PcZhidaonwhc_ngpagmjz%26rsv_dl%3Dgh_pc_zhidao)了。

#### TCP与UDP基本区别

1.基于连接与无连接
 2.TCP要求系统资源较多，UDP较少；
 3.UDP程序结构较简单
 4.流模式（TCP）与数据报模式(UDP);
 5.TCP保证数据正确性，UDP可能丢包
 6.TCP保证数据顺序，UDP不保证

#### UDP应用场景：

1.面向数据报方式
 2.网络数据大多为短消息
 3.拥有大量Client
 4.对数据安全性无特殊要求
 5.网络负担非常重，但对响应速度要求高

#### 具体编程时的区别

1.socket()的参数不同
 　 2.UDP Server不需要调用listen和accept
 　 3.UDP收发数据用sendto/recvfrom函数
 　 4.TCP：地址信息在connect/accept时确定
 　 5.UDP：在sendto/recvfrom函数中每次均 需指定地址信息
 　 6.UDP：shutdown函数无效

#### 编程区别

通常我们在说到网络编程时默认是指TCP编程，即用前面提到的socket函数创建一个socket用于TCP通讯，函数参数我们通常填为SOCK_STREAM。即socket(PF_INET, SOCK_STREAM, 0)，这表示建立一个socket用于流式网络通讯。
   SOCK_STREAM这种的特点是面向连接的，即每次收发数据之前必须通过connect建立连接，也是双向的，即任何一方都可以收发数据，协议本身提供了一些保障机制保证它是可靠的、有序的，即每个包按照发送的顺序到达接收方。

而SOCK_DGRAM这种是User Datagram Protocol协议的网络通讯，它是无连接的，不可靠的，因为通讯双方发送数据后不知道对方是否已经收到数据，是否正常收到数据。任何一方建立一个socket以后就可以用sendto发送数据，也可以用recvfrom接收数据。根本不关心对方是否存在，是否发送了数据。它的特点是通讯速度比较快。大家都知道TCP是要经过三次握手的，而UDP没有。

基于上述不同，UDP和TCP编程步骤也有些不同，如下：

#### TCP:

TCP编程的服务器端一般步骤是：
 　1、创建一个socket，用函数socket()；
 　2、设置socket属性，用函数setsockopt(); * 可选
 　3、绑定IP地址、端口等信息到socket上，用函数bind();
 　4、开启监听，用函数listen()；
 　5、接收客户端上来的连接，用函数accept()；
 　6、收发数据，用函数send()和recv()，或者read()和write();
 　7、关闭网络连接；
 　8、关闭监听；

TCP编程的客户端一般步骤是：
 　1、创建一个socket，用函数socket()；
 　2、设置socket属性，用函数setsockopt();* 可选
 　3、绑定IP地址、端口等信息到socket上，用函数bind();* 可选
 　4、设置要连接的对方的IP地址和端口等属性；
 　5、连接服务器，用函数connect()；
 　6、收发数据，用函数send()和recv()，或者read()和write();
 　7、关闭网络连接；

#### UDP:

与之对应的UDP编程步骤要简单许多，分别如下：
 　UDP编程的服务器端一般步骤是：
 　1、创建一个socket，用函数socket()；
 　2、设置socket属性，用函数setsockopt();* 可选
 　3、绑定IP地址、端口等信息到socket上，用函数bind();
 　4、循环接收数据，用函数recvfrom();
 　5、关闭网络连接；

#### UDP编程的客户端一般步骤是：

1、创建一个socket，用函数socket()；
 　2、设置socket属性，用函数setsockopt();* 可选
 　3、绑定IP地址、端口等信息到socket上，用函数bind();* 可选
 　4、设置对方的IP地址和端口等属性;
 　5、发送数据，用函数sendto();
 　6、关闭网络连接；

TCP和UDP是OSI模型中的运输层中的协议。TCP提供可靠的通信传输，而UDP则常被用于让广播和细节控制交给应用的通信传输。

#### UDP补充：

UDP不提供复杂的控制机制，利用IP提供面向无连接的通信服务。并且它是将应用程序发来的数据在收到的那一刻，立刻按照原样发送到网络上的一种机制。即使是出现网络拥堵的情况下，UDP也无法进行流量控制等避免网络拥塞的行为。此外，传输途中如果出现了丢包，UDO也不负责重发。甚至当出现包的到达顺序乱掉时也没有纠正的功能。如果需要这些细节控制，那么不得不交给由采用UDO的应用程序去处理。换句话说，UDP将部分控制转移到应用程序去处理，自己却只提供作为传输层协议的最基本功能。UDP有点类似于用户说什么听什么的机制，但是需要用户充分考虑好上层协议类型并制作相应的应用程序。

#### TCP补充：

TCP充分实现了数据传输时各种控制功能，可以进行丢包的重发控制，还可以对次序乱掉的分包进行顺序控制。而这些在UDP中都没有。此外，TCP作为一种面向有连接的协议，只有在确认通信对端存在时才会发送数据，从而可以控制通信流量的浪费。TCP通过检验和、序列号、确认应答、重发控制、连接管理以及窗口控制等机制实现可靠性传输。

#### TCP与UDP区别总结：

1、TCP面向连接（如打电话要先拨号建立连接）;UDP是无连接的，即发送数据之前不需要建立连接
 2、TCP提供可靠的服务。也就是说，通过TCP连接传送的数据，无差错，不丢失，不重复，且按序到达;UDP尽最大努力交付，即不保   证可靠交付
 3、TCP面向字节流，实际上是TCP把数据看成一连串无结构的字节流;UDP是面向报文的
 UDP没有拥塞控制，因此网络出现拥塞不会使源主机的发送速率降低（对实时应用很有用，如IP电话，实时视频会议等）
 4、每一条TCP连接只能是点到点的;UDP支持一对一，一对多，多对一和多对多的交互通信
 5、TCP首部开销20字节;UDP的首部开销小，只有8个字节
 6、TCP的逻辑通信信道是全双工的可靠信道，UDP则是不可靠信道

原文：[https://blog.csdn.net/Li_Ning_/article/details/52117463](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2FLi_Ning_%2Farticle%2Fdetails%2F52117463)



作者：Aniugel
链接：https://www.jianshu.com/p/e8ea289b478e
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。