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

