---
layout: post
title: "CocoaSocket实践（一）:Socket简介"
description: ""
category: blog
tags: [OS]
image: 
  feature: children'sDay.jpg
comments: true
diary: 这是本站关于CocoaSocket编程实践专题的第一篇文章，本文力图用1个小时以内的时间为读者介绍Socket以及对应的TCP，UDP协议等网络知识，所讲内容多为个人理解和外文搬运，对于socket编程只是很浅的一个入门，更多的内容可以参考其他关于socket的书籍。

mathjax: 
---

这是本站关于CocoaSocket编程实践专题的第一篇文章，这个专题并不是为了探讨如何使用CocoaAsynSocket库来实现一个iOS客户端或者是OS X服务器，而是为了研究这个库的具体实现细节以及其所采用的技术。本文力图用1个小时以内的时间为读者介绍Socket以及对应的TCP/UDP协议等网络知识，所讲内容多为个人理解和外文搬运，对于socket编程只是很浅的一个入门，更多的内容可以参考其他关于socket的书籍。

<section>
  <header>
    <h1 >目录</h1>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>

##概述
如果你之前有过使用基于文件传输的协议来进行网络通信的实践（如HTTP，FTP），那么使用基于socket传输的协议（TCP，UDP）来进行网络通信将会是一种更靠近底层的工作，但使用socket却能有很大的性能上的提升。事实上，在[ISO/OSI网络体系结构](http://baike.baidu.com/link?url=yGUAWSFEonLlu2TwBpCCWUsI9b2i64CcNKeqZ2U-u3Cw3ZNiOlhS2vmxscu_OIRLAvREGHxl0KfGVK2qWlIee_#4)中, HTTP等协议位于应用层，而TCP协议位于传输层，如下图所示。
<figure class = "half">
<a href="{{ site.url }}/images/2014/06/01/1.jpg"><img src="{{ site.url }}/images/2014/06/01/1.jpg" /></a>
</figure>

##Sockt是一个端点
Socket是两个进程之间用于通信的端点，在这里我们特指互联网上两个远程进程的Socket。可以认为，一个进程要向另外一个进程进行收发数据，是通过这个进程的socket向另外一个进程的socket收发数据完成的。而为了正确的发送至指定的socket上，每个socket本身包含了自己所在电脑的IP地址和自己的端口号。“IP+端口号”可以唯一确定一个socket的地址，这样发送数据也是以这个地址来发送。

{% highlight C %}    
    Note1：每个电脑都不止有一个IP地址，因为每台电脑都有多个网卡，比如我这台S10-3s，它有一个WI-FI网卡连接着局域网，它有一个IP，它还有一个蓝牙可以连接另外一台电脑，连接上后它就有另外一个IP，而且，每一台电脑都有一个网卡连接自身，一般为localhost,它也有一个IP地址。
{% endhighlight %}

{% highlight C %}
    Note2：DNS（Domain Naming System）就像它名字说的那样，是一个域名映射的数据库系统，它把每个注册进来的域名解析成主机IP，这样在进行网络通信时就不必要记住复杂的IP地址。
{% endhighlight %}

{% highlight C %}
    Note3:你现在大概知道了Socket的概念，它是一个负责发送和接收数据的端点，那你肯定会想这么一个通用的抽象，我们在编程时还需要实现这些概念吗？比如用C语言定义一个Socket的数据结构？答案是不用的，我们的操作系统已经帮我们实现了它。如果你是Unix或者是Linux用户，可以打开终端，输入man socket看到完整的信息。
{% endhighlight %}

好了现在我们有了socket，是不是意味着我们就可以很完美的发送数据了呢？答案是否定的，因为只有这个概念我们会发现发送数据时会遇到一系列的问题。

##发送数据的问题
发送数据最大的问题就是数据传输的途径对于某个用户级进程来讲是不可知的，透明的，不可靠的。就是当我们发送数据时，我们并不知道这个数据是通过wifi发送，还是通过蓝牙等其他方式发送的。

另外一个问题就是我们不能保证数据发送的完整性和正确性。因为socket发送和接收的数据都会被分割成一个个足够小的包，对于一个发送的包，它会先到达路由器，然后通过路由器将其发送到指定的地址然后才能让另一个socket接收。这样，当路由器分派包的速度小于接收包的速度时，就会出现有些包会无法到达路由器而丢包的问题，就算可以重新发送，也会导致包的顺序与原来的不一致的问题。

##协议

为了掌控这些不可靠的因素，实现数据传递的准确和可靠，就引入了基于socket的协议：TCP和UDP。

###UDP
UDP（User Datagram Protocol）是一种两个socket之间无需建立连接就可以发送数据的协议，因为两个socket没有建立连接，所以一般用于只发送一次少量数据（事实上，UDP限制了Socket发送数据的大小），它没有校验是否丢包，也不能保证数据传输后还能保持原来的顺序。然而，这换来的是传输速度上的极大化，一般我们在传输音频，视频流的应用会采用这种协议（即使丢包，人的眼睛和耳朵也难以分辨），另外，我们之前讲到的DNS也是采用这种协议，为的是实现数据传输速度的最大化。

###TCP
TCP（Transmission Control Protocol）是一种两个socket之间必须建立连接然后发送数据的协议，一般适用于长对话。TCP协议没有限制数据的大小，而且规定了发包校验的方式，确保了发送数据的正确性。通过TCP协议发送的数据，在丢包的情况发生时会重新发送，并且能重新整合包的顺序。另外，TCP还规定了，当网络出现阻塞时，会减缓其发送的速率来让网络通畅。

{% highlight C %}
    Note1：如果将两个进程的网络通信比作两个人在交流，那么TCP就适用于新室友见面的场景：两个人先进行自我介绍，告诉双方名字，联系方式，然后开始讨论待会吃什么好，而UDP就适用于在路上搭讪女孩子的场景：“小姐，我的表坏了，我可以问下时间吗”......
{% endhighlight %}

{% highlight C %}
    Note2：UDP和TCP协议的内容以及具体实现非常复杂，不在本文讨论的范围内，有兴趣的可以看看[RFC768](http://tools.ietf.org/html/rfc768)（UDP协议），[RFC793](http://tools.ietf.org/html/rfc793)和[RFC1323](http://tools.ietf.org/html/rfc1323)(TPC协议)。
{% endhighlight %}

{% highlight C %}
    Note3: 操作系统的socket API（之前man socket的内容）已经实现了TPC和UPC协议的内容。
{% endhighlight %}

###应用层的协议
现在我们有了UDP，可以快速发送数据，有了TCP，可以准确的发送数据，而这发送的数据都只是数据流而已，接收数据的一方要怎么去解析这个数据呢？举个例子：我通过QQ向A同学发送了一句“六一节快乐！”，然后再发了一句“哈哈哈”。那么它接收到的可能是0101010101010100101010101010,那么它怎么知道“六一节快乐”应该是哪一部分的数据串？要记住，TCP发送的数据只是一个数据流而已。而解决这个问题就是需要定义应用层的协议。例如HTTP协议，它就定义了HTTP头的数据结构，在发送的数据中以两个换行符标识，它会扫描传输层接收的数据，找到两个换行符，把这之前的数据解析成HTTP头，在HTTP头里记录了HTTP-BODY的长度信息，这样就可以实现数据的解析了。

{% highlight C %}
    Note：在实际应用中，我们可以直接使用操作系统实现好的HTTP协议，也可以自己定义并实现其他协议，例如嵌入式系统中可能没有实现HTTP协议但实现了TPC,UDP协议，这时我们可以在上面规定我们自己的协议：如以8个字节的长度为包头，包头记录了包体的长度，接收数据时先检查其是否是包头，若是则读出包体长度，再读包体。 
{% end highlight %}

##结语
现在，你应该对于socket网络有了一定的了解，接下来我们会以[CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket)这个项目作为分析样本，来解释Socket网络编程的具体实现细节，希望这会是一个很好的帮助你我学习的专题。
