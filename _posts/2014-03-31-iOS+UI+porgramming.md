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

这是SYSU Apple Club系列培训的第二篇。[上一篇](http://jeason.me/blog/Objective-C+Introduction/)我们学习了Objective－C的基本语法，而且知道了Foundation库内的一些重要的数据结构。这篇教程主要是厘清一些基本概念，让你对iOS UI编程的内在机制有一定的了解。本文主要参考自我的理解和
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
<a href="{{ site.url }}/images/2014/03/31/2.gif"><img src="{{ site.url }}/images/2014/03/31/2.gif" /></a>
</figure>

Model是管理数据的，View是管理视图的。我们知道，当数据更新之后，View也应该相应地动态更新。但是MVC规定了，Model不允许直接跟View打交道。为了达到这一目标，就有了Controller这个中间桥梁。为了达到Model与Controller更好地分离，iOS就引入了Key－Value－Observing和Notification这两种设计模式（如上图所示）。这两个东西我们以后会具体讲到，现在简单来讲，就是实现了把M内的变化告知C，然后C再把变化反映到V上。

同时，为了实现响应V上的改变（或者说事件？比如用户点击了一下屏幕），iOS又引入了Delegate，DataSource和Target－Action这些设计模式。这三种设计模式都是为了实现V和C的分离。

好了忽悠了那么多，＝，＝说白了就是面向对象的思想：将各个模块封装成不同的类，然后去耦合。iOS里对应的就是你自己写的Model类（M），如Note，UIView类（V），UIViewController类（C），然后V内有着其他两种类的实例。虽然这种解释一点也不优雅＝。＝不过对于新手来说，这已经足够了。
	
##main函数和AppDelegate

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

{% highlight objective-c %}
// If nil is specified for principalClassName, the value for NSPrincipalClass from the Info.plist is used. If there is no
// NSPrincipalClass key specified, the UIApplication class is used. The delegate class will be instantiated using init.
UIKIT_EXTERN int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);
{% endhighlight %}

这个相信英语4级能考过400的同学应该都可以读懂这个英文=-=。就这样，通过这个API，我们就成功地把程序的控制权交给了XXXAppDelegate这个类。



##UIViewController Life Cycle
翻译成中文叫做视图控制器生命周期，
这是理解iOS UI编程的另一个重要的概念，先看一张图。

<figure>
<a href="{{ site.url }}/images/2014/03/31/1.jpg"><img src="{{ site.url }}/images/2014/03/31/1.jpg" /></a>
</figure>

- 图上这些所有的操作，都是由操作系统控制着在一个View被load，appear，disappear等时自动调用的，不需要我们程序员来手动控制。

- 这些方法都是定义在UIViewController上（不是UIView）

- 这是一个圆，从哪里开始看都可以，不妨从左边的一个请求页面的事件开始。

- 我们可以看到，当我们需要一个View的时候，我们会先看内存里是否已经存在这个View了，如果不存在，就调用loadView这个方法从Interface Builder（xib）加载这个View，如果不存在xib，就直接新建一个空白的UIView实例并把它赋给UIViewController的view的property。（其实就是直接self.view = [[UIView alloc] init]）如果存在这个view（思考1:为什么它可能会存在？），就直接调用viewWillAppear:

- 然后当load完之后就会调用viewDidLoad这个方法，我们一般会重写这个方法来对我们的view进行布局，布局完了操作系统就会告诉ViewController：嘿，这个view已经准备好了，可以显示了（即调用viewWillAppear）

- viewWillAppear：在view准备在屏幕上显示出来的时候调用，我们一般可以重写这个方法来将我们布局完的一些view给隐藏起来。设置完了之后，view显示到屏幕上，然后操作系统调用viewDidAppear

- 因为view是存在内存中的，在手机上可能会出现内存不够的情况（思考2:为什么它会内存不够？手机不是一次只能显示一个页面吗），当内存不够的时候，就会调用didReceiveMemoryWarning:这个方法。这个方法接下来讲。

- 当用户离开这个页面的时候，调用viewWill/DidDisappear，机理跟viewWill/DidAppear是一样的。

- 注意到，即使用户离开了这个页面，这个页面的占有的内存也不会立即被释放，view只是消失了但并没有摧毁，这就是思考1和思考2的答案，这样做是为了下次再次需要这个view的时候不需要再进行加载和布局。

- 既然view还保留在内存中，那就肯定会出现内存不够的情况，所以didReceiveMemoryWarning这个方法很重要，如果不重写，它一般就直接把self.view置为nil。一般是建议重写＝-＝，特别当这个页面非常的复杂而且很多部分很占内存的时候。

这就是我们所说的UIViewController Life Cycle，其实还有一些方法比如viewWillLayoutSubview之类的，思路理解起来都是一样的，在恰当的时机被操作系统调用恰当的方法。

##UIView概述


##UIKit Overview

##总结

##Assignment
