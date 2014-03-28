---
layout: post
title: "Objective-C快速入门"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: ios6_ios7_home_screens.jpg
comments: true
mathjax: 
---

因为最近要给俱乐部的新人做一下技术培训，所以就想先把忽悠的内容写一下。本文假设你已经有了面向对象的编程思想，学过至少一种编程语言（如C++），同时也对C语言足够熟悉。本文主要是由我自己学习IOS开发的过程中学到的对Objective－C的认识总结而来，同时也参考了[Stanford‘的CS193p课程](https://itunes.apple.com/us/course/developing-ios-7-apps-for/id733644550)，已及《Effective Objective-C 2.0》这本书，所讲的只是我的个人理解，如果有明显错误，希望大家能指出来。


<section>
  <header>
    <h2>目录</h2>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>


##概述

- Objective-C是C语言的一个超集，即所有符合C语言语法的代码都可以直接通过OC的编译器。这一点跟C++十分类似（因为我之前是学C++的，学习OC的时候就把里面的很多语法都跟C++进行了联系和对比），它以另外一种不同于C++的语法实现了面向对象。

- 虽然OC现在几乎只运用于Apple系的操作系统上，但OC最初源于NeXTSTEP操作系统（乔帮主离开Apple那段时间创立的公司），后来NeXTSTEP被Apple收购，但并没有怎么修改NeXTSTEP留下的重要的Foundation库，所以我们现在的OC里的大部分类，枚举，结构体的名字都有个NS（NeXTSTEP的缩写）作为前缀。

- Objective-C最大的特色是承自Smalltalk的信息传递模型（message passing），此机制与今日C++式之主流风格差异甚大。向一个函数传递参数只是向这个函数传递了一个模糊的信息，所有的信息处理都是直到runtime才会动态地决定(有点类似于C++的dynamic blinding)。

##类的编写

既然是面向对象的语言，那么最重要的就是类的编写方法了，学习的最好方式，就是看代码。

###类的声明

{% highlight objective-c %}
//
//  CENote.h
//  TextKitNotepad
//
//  Created by Jeason on 28/03/2014.
//  Copyright (c) 2013 Jeason. All rights reserved.
//

//#import <Foundation/Foundation.h>
//1
@import Foundation;

//2
@interface Note : NSObject

//3
@property (nonatomic, strong) NSString* contents;
@property (nonatomic, strong) NSDate* timestamp;
// an automatically generated not title, based on the first few words
@property (nonatomic, readonly) NSString *title;

@property NSUInteger NoteID;

//4
- (instancetype)initWithText:(NSString*)text NoteID: (NSUInteger)noteid;

+ (instancetype)noteWithText:(NSString *)text NoteID: (NSUInteger)noteid;

@end
{% endhighlight %}
<html>
<ol>
<li>
	#import<Foundation/Foundation.h>，如果你之前学过C++，那你肯定都能猜出这个语句的意思，它有点类似于C++里的#include<cstdlib>，就是把头文件导入进来，但它不需要像C/C++那样，要加上
	{% highlight C %}
	#ifndef XXX
	#define XXX
	#endif
	{% endhighlight %}
	这样的宏来判断是否重复包含，#import就实现这个宏的功能来避免重复包含。之所以把它注释掉，是因为在IOS7中，更推荐的用法是下面那一行：<code>@import Foundation;</code>，@import不是让编译器导入一堆的库文件，而是让编译器link一个已经编译好的"module"，这样就极大地减少了编译的时间。
</li>

<li>
	<code>@interface Note : NSObject ... @end</code>, 这个看字面意思就可以看懂，就是声明了Note这个类的接口(interface)，":"后面跟的是Note这个类继承的类“NSObject”，NSObject几乎是你所编写的所有OC类的子类，它定义了很多通用的方法（如isEuqalTo:，init之类的，现在先不管他）。
</li>

<li>
	@proerty，如果把它翻译成中文，可以说是属性吧，它是OC里的一个重要但不容易理解的语法。如果你之前写过C++，那你肯定写过一堆无聊的getter，setter来读/写这些成员变量，对于新人来说，可以认为property就相当于C++一个类内的成员变量，它的实例名字就是下划线＋somePropertyName,如<code>_contents</code>。而且@property还自动为我们生成了这些变量的getter和setter函数，他们默认的名字是setXXX和XXX。我们看到，@property后面可以跟有一堆的关键字，而且正如你所看到的那样，以后我们写的大部分property后面跟的都是(nonatomic, strong)，我本来应该把所有的关键字都列出来然后一一给你说明，但我不想那样子做，我只是遇到一些解释一些这样，因为通过不同的例子这样才有可能记得住这些关键字的具体含义和区别
	<ul>
		nonatomic: 
	</ul>
</li>

<li>
	接下来就是一些函数的声明了。OC的函数声明的样子对于C/C++的程序员来说是非常的别扭的，不妨你用英语把它读出来？

	其中－和＋分别代表了实例方法和类方法，括号里的是函数的返回类型，instancetype表示这个返回的是这个类的类型，比如这里的Note。而冒号后面跟的是参数的类型和参数名。
</li>
</ol>
</html>

{% highlight C++ %}
如果你足够细心的话，你应该发现了在这个类的声明里，涉及到对象的几乎都是表示成指针的形式。的确，OC里的所有对象都是采用指针来访问的，而所有的对象的内存都是在堆里面产生的，而不象C++那样是可以通过棧产生。
{% endhighlight %}

###类的实现

接下来我们就来实现这个类，注意，OC的类实现文件的后缀是.m

{% highlight objective-c %}
//
//  CENote.m
//  TextKitNotepad
//
//  Created by Jeason on 28/03/2014.
//  Copyright (c) 2013 Jeason. All rights reserved.
//

//1
#import "Note.h"

@interface Note ()
//2
@end

@implementation Note

- (instancetype)initWithText:(NSString*)text NoteID: (NSUInteger)noteid {
    //3
    self = [super init];
    if ( self  != nil ) {
        self.contents = text;
        self.NoteID = noteid;
        self.timestamp = [NSDate date];
    }
    return self;
}

+ (instancetype)noteWithText:(NSString *)text NoteID:(NSUInteger)noteid {
    Note* note = [Note new];
    note.contents = text;
    note.NoteID = noteid;
    note.timestamp = [NSDate date];
    return note;
}

- (NSString *)title {
	//4
    // split into lines
    NSArray* lines = [self.contents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    // return the first
    return lines[0];
}

@end

{% endhighlight %}
<html>
<ol>
	<li>
		在这里又遇到了#import，复习一下，它就相当于实现了防止重复包含的#include.
	</li>

	<li>
		如果你以前学过C++或者JAVA，那你之前肯定会疑惑：OC里声明的成员哪些是public的，哪些是private的。在这里就告诉你答案：在.h文件的interface里声明的，都是public的，而在.m文件里的interface里声明的，就是private的（自然随@property产生的setter/getter也是private的）。
	</li>

	<li>
		接下来这一个函数就是我们以后经常会见到的，你可以把它看出是C++里的构造函数。但又跟构造函数有点不同，我们姑且把它称为初始化函数吧。这里有几点要注意的:
		<ul>
			<li> self就相当于C++里的this指针（这是我认为最容易接受的理解，虽然它可能并不严谨）。</li>

			<li>通过这个函数可以看到，OC里面调用函数（或者说传递消息？）的语法是[someObj someMethod]或者是[someClass someMethod]这样的写法，跟C++里的“.”符号只是写法不同而已。</li>

			<li>我们要获得property定义的getter/setter，是通过一个"."这样的符号来获得的。当然，因为porperty为我们产生了getter/setter 函数，你也可以通过调用这些函数，如[someObj somePropertyName]和[someObj setSomePropertyName]，只是老是要写两个括号简直不能忍。不过这里说一句：<code>最好是通过"."来获得getter，直接用_somePropertyName来获得setter，具体原因以后再说。</code></li>

			<li>它的写法一般都是固定的，就是先调用父类的init方法（NSObject）， 然后如果成功，返回的不为空（nil），就完成接下来的初始化的操作，最后返回。</li>
	</li>

	<li>
		@property自动生成的getter，就只是简单的返回它的值而已，而在这里，我们希望它每个Note的Title就是它内容的第一行，所以我们重写了这个函数。我们看这个函数会发现这个函数非常的长，但读起来却非常的简单易懂，这就是OC的魅力，以几乎是自然语言的方式写代码，让懂英语的人都可以读懂它的含义。
	</li>
	</ul>
</ol>
</html>

<article>
就这样，你懂得了一个类的基本结构和写法，还初步看到了Foundation提供的很多的库类，如NSString，NSDate，NSArray，你肯定会想学学这些类，然后利用这些来实现你自己想要的功能的类。那我们现在就来个Overview吧。
</article>


##Foundation Overview
