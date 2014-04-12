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

##App是如何组织起来的
接下来我们就开始具体的来看看一个iOS app是怎样组织起来的。先新建一个SigleView Application，项目名就为Note就好了。打开它，会看到有这么个组织结构:

<figure class="half">
<a href="{{ site.url }}/images/2014/03/31/4.jpg"><img src="{{ site.url }}/images/2014/03/31/4.jpg" /></a>
</figure>

###main函数

学过C语言的朋友都知道，来编程，不看main函数等于白来。（长沙臭豆腐( ´ ▽ ` )ﾉ）我们可以先来看iOS里普通的main函数是长啥样的。

{% highlight objective-c %}
int main(int argc, char * argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([NoteAppDelegate class]));
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

###AppDelegate
打开NoteAppDelegate，可以看到这里给我们定义了很多在app打开，进入后台，结束时操作系统回调的接口函数供我们重写，因为这个非常重要且复杂，可能会需要大量的篇幅。所以就先在这里挖个坑，^_^……

###NoteViewController
我们再看这个项目，Main.storyboard提供了一个图形界面来帮我们像ps那样子完成view的布局（因为mainstory/xib 的使用很简单而且因为现在人们还是觉得他们的使用会带来一些团队合作上的不便，虽然我很喜欢，但这个可能我不会讲，同学们可以在其他教程里看到interface bulider的用法。）Main.storyboard里有一个有一个NoteViewController的实例，所以我们整个app的唯一的页面就由NoteViewController这个类管理着。

我们来看看NoteViewController.m这个实现文件是长什么样子的

{% highlight objective-c %}
//
//  NoteViewController.m
//  Note
//
//  Created by Jeason on 14-4-12.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

{% endhighlight %}

基本上我们把app的运行过程这样组织起来：用户打开app，进入main然后把程序的控制权交给AppDelegate，然后操作系统调用Main.storyboard完成页面的加载，而这个Main.storyboard里有一个UIViewController的实例，在这个类里我们可以写一些函数来控制视图应该长什么样子。

不过要读懂VC里的这几个函数都有什么意义，就要先了解一下一个叫做UIViewController Life Cycle的概念。

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
UIView是iOS里组成我们UI的基本单元，UI的基本功能我觉得就只有两个：提供内容和导航用户完成人机交互。为了实现不同的视觉效果和导航方式，iOS通过继承UIView为我们提供了近20种的原生控件，包括了简单的按钮，文字显示，还有一些复杂的View如UITableView。我们可以用这些控件一个个叠加组成我们需要的界面，就好像ps那样一个个图层（图层是有上下之分的，view与view之间也是）组成漂亮的图像,如图所示。

<figure>
<a href="{{ site.url }}/images/2014/03/31/3.jpg"><img src="{{ site.url }}/images/2014/03/31/3.jpg" /></a>
</figure>

###代码
哎，水了那么多理论性的概念，我觉得还是读代码最为经济实惠了，我们现在就看看怎么通过代码把这些控件P在一起吧。我们先把上次写完的Note类加进来,然后在NoteViewController.h里加入note这个property

{%highlight objective-c%}
//
//  NoteViewController.h
//  Note
//
//  Created by Jeason on 14-4-12.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

@import UIKit;
@class Note;

@interface NoteViewController : UIViewController

@property (nonatomic, strong) Note *note;

@end

{%endhighlight%}

然后编辑NoteViewController.m

{% highlight objective-c %}
//
//  NoteViewController.m
//  Note
//
//  Created by Jeason on 14-4-12.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NoteViewController.h"
#import "Note.h"
//1
static const int statusBarHeight = 20;
static const CGFloat dateFontSize = 10;
static const CGFloat buttonSize = 44;
static const int inset = 10;

@interface NoteViewController ()

@end

@implementation NoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.note = [[Note alloc] initWithText:@"Apple Club lecture 2" NoteID:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    //2
    CGRect labelFrame = CGRectMake(0,statusBarHeight,self.view.frame.size.width,inset);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:labelFrame];
    dateLabel.font = [UIFont systemFontOfSize:dateFontSize];
    dateLabel.text = [formatter stringFromDate:_note.timestamp];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLabel];
    
    //3
    CGRect textFrame = CGRectMake(inset,//x
                                  inset*2 + statusBarHeight,//y
                                  self.view.frame.size.width,//width
                                  self.view.frame.size.height-inset*2+statusBarHeight-buttonSize);
    UITextView *textView = [[UITextView alloc] initWithFrame:textFrame];
    textView.text = _note.contents;
    [self.view addSubview:textView];
    
    //4
    CGRect buttonFrame = CGRectMake(inset, self.view.frame.size.height - buttonSize - inset, buttonSize, buttonSize);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    
    [button setImage:[UIImage imageNamed:@"share-.jpg"]
            forState:UIControlStateNormal];
    
    [button addTarget:self
               action:@selector(pressShare:)
     forControlEvents:UIControlEventTouchDragInside];
    
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pressShare: (id)sender {
    //5
    NSLog(@"press share btn!");
}

@end

{% endhighlight %}

1.  首先我们在用代码布局一个页面的时候可以定义一些常量尺度来帮助我们

2.  UILabel主要用于显示一些短文本，这里我们在页面顶部放个UILabel来显示当前时间,CGRect 定义了一个4元组的结构体用来表示坐标。然后我们还可以像ps里一样设置这个label的字体，内容，颜色，文字居中/居左/居右。当所有都设置完成后，将这个view（图层）叠加到self.view上（前面讲过，当view load完之后controller就会有一个view的实例对象，有点类似于画布）。

3.  UITextView用于显示多样化的文字，特别是在iOS7以后有了UITextKit这个强大的库以后，基本上可以替代css来完成对文字效果的需求。我们页面的主要部分就是显示Note的内容，这个手工计算坐标的方式有点烦，不过画个图应该能轻松理解搞定。接下来就跟UILabel一样了，设置完内容然后叠加到画布上。

4.  UIButton是按钮控件，我们在页面的底部放了一个分享按钮，我们可以对它进行设置，不过最主要的，就是增加一个action来控制当用户点击这个button时程序的响应。

5.  当用户点击button之后，它就会来到这个函数这里，你可以在上面完成各种事件，比如说通过邮件发送，通过信息发送，甚至是截图分享到朋友圈＝。＝不过那是你的事。

###Bulid & Run

<figure>
<a href="{{ site.url }}/images/2014/03/31/5.jpg"><img src="{{ site.url }}/images/2014/03/31/5.jpg" /></a>
</figure>

##总结
- iOS里实现了许多的设计模式，其中MVC模式贯穿了整个app。

- 一个app主要是由页面组成，而它是怎么运行起来的主要是靠Appdelegate来托管实现。

- 每个UIViewController都有自己的生命周期，我们可以通过重写方法来控制它的加载，显示和隐藏和销毁

- 我们主要是通过一个个UIView的子类来完成页面的构建。

- iOS里还有很多很多的控件来帮助你搭建自己的页面，学习完他们需要很长的时间，多阅读Apple的文档是关键。

##Assignment

1.  阅读[Apple的《UIKitUICatalog》](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/UIKitUICatalog/UIKitUICatalog.pdf)对基本的控件都有一定的了解。