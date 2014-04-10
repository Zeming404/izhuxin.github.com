---
layout: post
title: "Apple Club培训教程（二）：UI编程"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: iOSUIs.jpg
comments: true
diary: 这是SYSU Apple Club系列培训的第二篇。上一篇我们学习了Objective－C的基本语法，而且知道了Foundation库内的一些重要的数据结构。这篇教程主要是教你如何用代码的方式来帮你的程序做出iOS App GUI，让你对iOS UI编程有一定的了解。本文主要参考自我的理解和Apple的《UIKitCatalog》，如果有什么不对的地方，也希望大家能指出来。

mathjax: 
---

这是SYSU Apple Club系列培训的第二篇。[上一篇](http://jeason.me/blog/Objective-C+Introduction/)我们学习了Objective－C的基本语法，而且知道了Foundation库内的一些重要的数据结构。这篇教程主要是教你如何用代码的方式来帮你的程序做出iOS App GUI，让你对iOS UI编程有一定的了解。本文主要参考自我的理解和
<a href="https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/UIKitUICatalog/UIKitUICatalog.pdf">Apple的《UIKitCatalog》</a>，如果有什么不对的地方，也希望大家能指出来。

<section>
  <header>
    <h2>目录</h2>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>

##iOS的MVC设计模式
其实MVC在很多的开发中都会采用到，相信很多人听这个词肯定不是第一次，所以还是科普一下这个模式的起源。MVC模式最早由Trygve Reenskaug在1978年提出 ，是施乐帕罗奥多研究中心在20世纪80年代为程序语言Smalltalk发明的一种软件设计模式。MVC模式的目的是实现一种动态的程序设计，此模式通过对复杂度的简化，使程序结构更加直观。软件系统通过对自身基本部分分离的同时也赋予了各个基本部分应有的功能。（以上抄自wiki=，=）

<code>这里主要讲的是iOS中的MVC</code>。它是iOS中最常用的设计模式中的一种，理解它，就会顺带提及很多其他的重要的设计模式的内容。废话不多说，先看下Stanford CS193p课程里的一张图

<figure>
<a href="{{ site.url }}/images/2014/03/31/2.jpg"><img src="{{ site.url }}/images/2014/03/31/2.jpg" /></a>
</figure>

Model是管理数据的，View是管理视图的。我们知道，当数据更新之后，View也应该相应地动态更新。但是MVC规定了，Model不允许直接跟View打交道。为了达到这一目标，就有了Controller这个中间桥梁。为了达到Model与Controller更好地分离，iOS就引入了Key－Value－Observing和Notification这两种设计模式（如上图所示）。这两个东西我们以后会具体讲到，现在简单来讲，就是实现了把M内的变化告知C，然后C再把变化反映到V上。

同时，为了实现响应V上的改变（或者说事件？比如用户点击了一下屏幕），iOS又引入了Delegate，DataSource和Target－Action这些设计模式。这三种设计模式都是为了实现V和C的分离。

好了忽悠了那么多，＝，＝说白了就是面向对象的思想：将各个模块封装成不同的类，然后去耦合。iOS里对应的就是你自己写的Model类（M），如Note，UIView类（V），UIViewController类（C），然后V内有着其他两种类的实例。虽然这种解释一点也不优雅＝。＝不过对于新手来说，这已经足够了。
	
##main函数和AppDelegate

##main

我们可以先来看一个普通的main函数是长啥样的。

{% highlight objective-c %}
int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([CitySpadeAppDelegate class]));
    }
}
{% endhighlight %}

首先我这是Xcode5新建的项目，所以自动启动了ARC，即@autoreleasepool{}.然后接下来是直接调用了UIKit里的UIApplicationMain这个API。来看看这个API的文档:

{% highlight c %}
// If nil is specified for principalClassName, the value for NSPrincipalClass from the Info.plist is used. If there is no
// NSPrincipalClass key specified, the UIApplication class is used. The delegate class will be instantiated using init.
UIKIT_EXTERN int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);
{% endhighlight %}

这个相信英语4级能考过400的同学应该都可以读懂这个英文=-=。就这样，通过这个API，我们就成功地把程序的控制权交给了XXXAppDelegate这个类。



##UIViewController Life Cycle

<figure>
<a href="{{ site.url }}/images/2014/03/31/1.jpg"><img src="{{ site.url }}/images/2014/03/31/1.jpg" /></a>
</figure>

##UIView概述


##UIKit Overview

##总结

##Assignment
