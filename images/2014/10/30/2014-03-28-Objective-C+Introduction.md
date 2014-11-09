<!-----
layout: post
title: "iOS开发入门教程：Objective-C"
description: ""
category: blog
tags: [IOS Developer]
image:
  feature: objective_tutorial.jpg
comments: true
diary: 因为最近要给俱乐部的新人做一下技术培训，所以就想先把忽悠的内容写一下。本文假设你已经有了面向对象的编程思想，学过至少一种编程语言（如C++），同时也对C语言足够熟悉。本文主要是由我自己学习IOS开发的过程中学到的对Objective－C的认识总结而来，同时也参考了Stanford‘的CS193p课程以及《Effective Objective-C 2.0》这本书，所讲的只是我的个人理解，如果有明显错误，希望大家能指出来。

mathjax:
----->
<center><h1>iOS开发入门教程：Objective-C</h1></center>
<p align="right">AppleClub 2014-11-1</p>

<link rel="stylesheet" href="/path/to/styles/default.css">
<script src="/path/to/highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>

因为最近要给俱乐部的新人做一下技术培训，所以就想先把忽悠的内容写一下。本文假设你已经有了面向对象的编程思想，学过至少一种编程语言（如C++），同时也对C语言足够熟悉。本文主要是由我自己学习IOS开发的过程中学到的对Objective－C的认识总结而来，同时也参考了[Stanford‘的CS193p课程](https://itunes.apple.com/us/course/developing-ios-7-apps-for/id733644550)，以及《Effective Objective-C 2.0》这本书，所讲的只是我的个人理解，如果有明显错误，希望大家能指出来。


<!--<section>
  <header>
    <h2>目录</h2>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>
-->

##概述

- Objective-C是C语言的一个超集，即所有符合C语言语法的代码都可以直接通过OC的编译器。这一点跟C++十分类似（因为我之前是学C++的，学习OC的时候就把里面的很多语法都跟C++进行了联系和对比），它以另外一种不同于C++的语法实现了面向对象。

- 虽然OC现在几乎只运用于Apple系的操作系统上，但OC最初源于NeXTSTEP操作系统（乔帮主离开Apple那段时间创立的公司创造的），后来NeXTSTEP被Apple收购，但并没有怎么修改NeXTSTEP留下的重要的Foundation库，所以我们现在的OC里的大部分类，枚举，结构体的名字都有个NS（NeXTSTEP的缩写）作为前缀。

- Objective-C最大的特色是承自Smalltalk的信息传递模型，此机制与今日C++式之主流风格差异甚大。向一个函数传递参数只是向这个函数传递了一个模糊的信息，所有的信息处理都是直到runtime才会动态地决定(有点类似于C++的dynamic blinding)。

<pre style='color:#d1d1d1;background:#000000;'><html><body style='color:#d1d1d1; background:#000000; '><pre>
<span style='color:#ffffff; background:#dd0000; '>`timescale</span> <span style='color:#ffffff; background:#dd0000; '>1ns</span> <span style='color:#ffffff; background:#dd0000; '>/</span> <span style='color:#ffffff; background:#dd0000; '>1ps</span>
 
<span style='color:#9999a9; '>////////////////////////////////////////////////////////////////////////////////</span>
<span style='color:#9999a9; '>// Company: </span>
<span style='color:#9999a9; '>// Engineer:</span>
<span style='color:#9999a9; '>//</span>
<span style='color:#9999a9; '>// Create Date:   10:54:10 10/29/2014</span>
<span style='color:#9999a9; '>// Design Name:   gates</span>
<span style='color:#9999a9; '>// Module Name:   C:/Users/Jeason/Documents/ISE Project/gates/gates_ts.v</span>
<span style='color:#9999a9; '>// Project Name:  gates</span>
<span style='color:#9999a9; '>// Target Device:  </span>
<span style='color:#9999a9; '>// Tool versions:  </span>
<span style='color:#9999a9; '>// Description: </span>
<span style='color:#9999a9; '>//</span>
<span style='color:#9999a9; '>// Verilog Test Fixture created by ISE for module: gates</span>
<span style='color:#9999a9; '>//</span>
<span style='color:#9999a9; '>// Dependencies:</span>
<span style='color:#9999a9; '>// </span>
<span style='color:#9999a9; '>// Revision:</span>
<span style='color:#9999a9; '>// Revision 0.01 - File Created</span>
<span style='color:#9999a9; '>// Additional Comments:</span>
<span style='color:#9999a9; '>// </span>
<span style='color:#9999a9; '>////////////////////////////////////////////////////////////////////////////////</span>
 
<span style='color:#e66170; font-weight:bold; '>module gates_ts</span><span style='color:#d2cd86; '>;</span>
 
<span style='color:#9999a9; '>// Inputs</span>
<span style='color:#e66170; font-weight:bold; '>reg</span> a<span style='color:#e66170; font-weight:bold; '>;</span>
<span style='color:#e66170; font-weight:bold; '>reg</span> b<span style='color:#e66170; font-weight:bold; '>;</span>
 
<span style='color:#9999a9; '>// Outputs</span>
<span style='color:#e66170; font-weight:bold; '>wire</span> <span style='color:#d2cd86; '>[</span><span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>:</span><span style='color:#00a800; '>5</span><span style='color:#d2cd86; '>]</span> z<span style='color:#e66170; font-weight:bold; '>;</span>
 
<span style='color:#9999a9; '>// Instantiate the Unit Under Test (UUT)</span>
	gates uut <span style='color:#d2cd86; '>(</span>
<span style='color:#d2cd86; '>.</span>a<span style='color:#d2cd86; '>(</span>a<span style='color:#d2cd86; '>)</span><span style='color:#d2cd86; '>,</span> 
<span style='color:#d2cd86; '>.</span>b<span style='color:#d2cd86; '>(</span>b<span style='color:#d2cd86; '>)</span><span style='color:#d2cd86; '>,</span> 
<span style='color:#d2cd86; '>.</span>z<span style='color:#d2cd86; '>(</span>z<span style='color:#d2cd86; '>)</span>
<span style='color:#d2cd86; '>)</span><span style='color:#d2cd86; '>;</span>
 
	initial <span style='color:#e66170; font-weight:bold; '>begin</span>
		<span style='color:#9999a9; '>// Initialize Inputs</span>
		a <span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
		b <span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
 
		<span style='color:#9999a9; '>// Wait 100 ns for global reset to finish</span>
		#<span style='color:#00a800; '>100</span><span style='color:#d2cd86; '>;</span>
        
		<span style='color:#9999a9; '>// Add stimulus here</span>
		#<span style='color:#00a800; '>200</span>
			a <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
			b <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
		
		#<span style='color:#00a800; '>200</span>
			a <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
			b <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>1</span><span style='color:#d2cd86; '>;</span>
		
		#<span style='color:#00a800; '>200</span>
			a <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>1</span><span style='color:#d2cd86; '>;</span>
			b <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>0</span><span style='color:#d2cd86; '>;</span>
		
		#<span style='color:#00a800; '>200</span>
			a <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>1</span><span style='color:#d2cd86; '>;</span>
			b <span style='color:#d2cd86; '>&lt;</span><span style='color:#d2cd86; '>=</span> <span style='color:#00a800; '>1</span><span style='color:#d2cd86; '>;</span>
	<span style='color:#e66170; font-weight:bold; '>end</span>
      
<span style='color:#e66170; font-weight:bold; '>endmodule</span>
</pre>

##方法的编写
好吧，我没有写函数，是因为Objective-C的函数几乎只有写在类里面才有效，所以在接下来的叙述中不会刻意强调方法和函数的区别，默认他们都指代方法。 因为相比于Swift，OC的函数的写法则比较接近于C++，我们可以看看之前Swift教程的函数对应的OC版本:

<script src="https://gist.github.com/izhuxin/fe9620894fe387ab834e.js"></script>

我们会看到，由于编码风格的习惯，Objective-C和绝大多数编程语言不同的是，它的函数名总是像英文一样可以随口读出来，所以这会让最开始接触OC的感到比较别扭。
我们会看到与Swift把返回值写在声明的最后不同，OC把返回值写在了最开头。

##匿名函数

相比于Swift闭包的灵活飘逸，OC的闭包（block）则比较刻板一些：

<script src="https://gist.github.com/izhuxin/60394942f2bd83483764.js"></script>

我们会发现因为不支持类型推断，所以如果想要把一个block赋给一个变量就必须要指定的它的类型（在这里，是<code>NSComparisonResult (^)(NSString *a, NSString *b)</code>。这是非常痛苦的，所以我们一般会运用一下typedef来减轻我们的负担，比如说上面的代码可以改写成：

<script src="https://gist.github.com/izhuxin/8a220b3f691d2f9f3040.js"></script>

OC作为一种以面向对象为主的语言，对闭包的实现可以说是比较拘谨的：即在block里面对外部变量的值是只读的，当我们想要改变外部变量的值时，我们要在这个变量前面加上__block的关键字修饰。
像下面这样:

<script src="https://gist.github.com/izhuxin/753366a37eafc8adcb3e.js"></script>

##类的编写

既然是面向对象的语言，那么最重要的就是类的编写方法了，学习的最好方式，就是看代码。

###类的声明

<script src="https://gist.github.com/izhuxin/39f0b218de9ee14d4062.js"></script>


	如果你足够细心的话，你应该发现了在这个类的声明里，涉及到对象的几乎都是表示成指针的形式。的确，OC里的所有对象都是采用指针来访问的，而所有的对象的内存都是在堆里面产生的，而不象C++那样是可以通过栈产生。



1, #import<Foundation/Foundation.h>，如果你之前学过C++，那你肯定都能猜出这个语句的意思，它有点类似于C++里的#include<cstdlib>，就是把头文件导入进来，但它不需要像C/C++那样，要加上:

	#ifndef XXX
	#define XXX
	#endif

这样的宏来判断是否重复包含，#import就实现这个宏的功能来避免重复包含。之所以把它注释掉，是因为在IOS7中，更推荐的用法是下面那一行：<code>@import Foundation;</code>，@import不是让编译器导入一堆的库文件，而是让编译器link一个已经编译好的"module"，这样就极大地减少了编译的时间。

2,
<code>@interface Note : NSObject ... @end</code>, 这个看字面意思就可以看懂，就是声明了Note这个类的接口(interface)。


3, ":"后面跟的是Note这个类继承的类“NSObject”，NSObject几乎是你所编写的所有OC类的子类，它定义了很多通用的方法（如isEuqalTo:，init之类的，现在先不管他）。

4, @proerty，如果把它翻译成中文，可以说是属性吧，它是OC里的一个重要但不容易理解的语法。如果你之前写过C++，那你肯定写过一堆无聊的getter，setter来读/写这些成员变量，对于新人来说，可以认为property就相当于C++一个类内的成员变量，它的实例名字就是下划线＋somePropertyName,如<code>_contents</code>。而且@property还自动为我们生成了这些变量的getter和setter函数，他们默认的名字是setXXX和XXX。我们看到，@property后面可以跟有一堆的关键字，而且正如你所看到的那样，以后我们写的大部分property后面跟的都是(nonatomic, strong)，我本来应该把所有的关键字都列出来然后一一给你说明，但我不想那样子做，我只是遇到一些解释一些这样，因为通过不同的例子这样才有可能记得住这些关键字的具体含义和区别

	- nonatomic: 非原子性，要想理解它，就得先明白atomic,即原子性。原子性就是指当有两个以上的线程都在读/写这个property时，一个线程对它的操作会锁住其他线程，这样就保证了这个property的值在每个线程上都是合法的。而nonatomic不会锁住其他线程。但是因为atomic会带来极差的用户体验，而真的要考虑线程安全的情况又少，所以一般来说会选择牺牲线程安全性来保证性能。

	- strong: 在介绍这个之前，要先搞懂一下OC里的内存管理机制。之前说过，OC里的对象都是在堆里产生的，C++里每new一个对象出来，都需要把它delete掉才会将内存回收，而OC里引入了Automic Reference Counting的技术。就是启用了ARC，操作系统就会对指向这个对象的，拥有这个对象的所有权的指针进行计数，当计数器为0时，这个对象自动被释放。对这个指针进行赋值，则这个指针拥有了该指针指向的对象的所有权(owenership)，即该对象的引用计数器＋1；与之相对的weak关键字声明的指针就不会让引用计数器+1.

	- readonly: 这个应该容易理解，就是只读性，有点类似于C++的const指针。在这里，它是在头文件里定义的，我们可以说这个对象对客户来说是只读的。如果没有特殊声明，属性默认的缺省的是readwrite，即可读可写。


其中－和＋分别代表了实例方法和类方法，括号里的是函数的返回类型，instancetype表示这个返回的是这个类的类型，比如这里的Note。(这是iOS7新增的，以前人们都习惯于写id，id是一个可以指向任何对象的指针，也可以把它理解为”C++里的void*“ ？，在iOS7以后凡是init方法的返回类型都推荐采用instancetype)而冒号后面跟的是参数的类型和参数名。

###类的实现

接下来我们就来实现这个类，注意，OC的类实现文件的后缀是.m

<script src="https://gist.github.com/izhuxin/a8e72a9d1621e7e42d5d.js"></script>

1, 在这里又遇到了#import，复习一下，它就相当于实现了防止重复包含的#include.

2, 如果你以前学过C++或者JAVA，那你之前肯定会疑惑：OC里声明的成员哪些是public的，哪些是private的。在这里就告诉你答案：在.h文件的interface里声明的，都是public的，而在.m文件里的interface里声明的，就是private的（自然随@property产生的setter/getter也是private的）。

3, 接下来这一个函数就是我们以后经常会见到的，你可以把它看出是C++里的构造函数。但又跟构造函数有点不同，我们姑且把它称为初始化函数吧。这里有几点要注意的:

- 之所以说不同于构造函数，就是C++里调用了构造函数，即完成了内存分配和初始化这两个操作，init函数只是进行初始化，而OC里要产生一个新的对象，一般是采用[[someClass alloc] init]，即先分配内存，然后初始化。

- self就相当于C++里的this指针（这是我认为最容易接受的理解，虽然它可能并不严谨）。

- 通过这个函数可以看到，OC里面调用函数（或者说传递消息？）的语法是[someObj someMethod]或者是[someClass someMethod]这样的写法，跟C++里的“.”符号只是写法不同而已。

- 我们要获得property定义的getter/setter，是通过一个"."这样的符号来获得的。当然，因为porperty为我们产生了getter/setter 函数，你也可以通过调用这些函数，如[someObj somePropertyName] 和 [someObj setSomePropertyName]，只是老是要写两个括号简直不能忍。不过这里说一句：<code>最好是通过"."来获得getter，直接用_somePropertyName来获得setter，具体原因以后再说。</code>

- 它的写法一般都是固定的，就是先调用父类的init方法（NSObject）， 然后如果成功，返回的不为空（nil），就完成接下来的初始化的操作，最后返回。

4, @property自动生成的getter，就只是简单的返回它的值而已，而在这里，我们希望它每个Note的Title就是它内容的第一行，所以我们重写了这个函数。我们看这个函数会发现有个语句非常的长（你肯定知道我说哪一个），但读起来却非常的简单易懂，这就是OC的魅力，以几乎是自然语言的方式写代码，让懂英语的人都可以读懂它的含义。

就这样，你懂得了一个类的基本结构和写法，还初步看到了Foundation提供的很多的库类，如NSString，NSDate，NSArray，你肯定会想学学这些类，然后利用这些来实现你自己想要的功能的类。那我们现在就来个Overview吧。

##Foundation Overview

####NSString

	- Refferencing: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html

	- 通过位置索引获得字符：－ (char)CharacterAtIndex: 就跟C语言的[]操作一样

	- 字符串常量：@"stringContent"来表示常字符串，C语言中是""

	- 字符串格式控制: + (id)stringWithFormat:(NSString *)format... 和 - (id)initWithFormat:(NSString *)format...

	- format的对应: %@代表NSString, 其余跟C语言的一样。

	- 字符串扩展: – stringByAppendingFormat:

	- NSMutableString继承了NSString, 是可以改变内容的字符串，就相当于C++语言里的string。


###NSNumber

	- Refferencing: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSNumber_Class/Reference/Reference.html

	- 统一代表了有关数的一切数据类型的类，可以给它初始化赋予任何类型的值(BOOL, int, float等等)，之后通过boolValue, integerValue, floatValue等方法来返回这些值，非常的简单但强大的类，最好看下Refference。


###NSArray

	- Refferencing: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSArray_Class/NSArray.html

	- 强大的数组，可以在一个数组内存放不同类型的数据,（即NSArray的元素的类型为id）

	- 数组常量: @[obj1, obj2, ...]， C语言中的是{}

	- 获得某个下标的元素: – objectAtIndex:, C语言中是[]操作

	- 排序：sortedArrayUsingComparator:

	- NSMutableArray继承了NSArray， 是可以改变内容的数组，就相当于C++语言中的vector（在《Effective Objective－C 2.0》这本书里是强烈不推荐MutableArray的，Dictionary也是。）

###NSDictionary

	－ Refferencing: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSDictionary_Class/Reference/Reference.html

	- 一个key/value的数据结构，有点类似于C++里的map

	- 跟其他很多语言的dictionary或者map一样，提供“[]”操作

	- dictionary常量: @{ key: value }

	- NSMutableDictionary继承了NSDictionary， 是可以改变内容的字典。

##Protocol

像Swift一样，Objective-C里也有protocol的概念（很遗憾，OC一直都没有虚函数或者虚基类的概念，你只能通过注释来告诉客户你的这个方式是抽象的）。一个protocol的写法是这样的：(在Note.h的里的<code>@interface Note : NSObject</code>前面
加上下面这段代码)

<script src="https://gist.github.com/izhuxin/644d8d272fe84173a490.js"></script>

每个协议都是由@protocol开头的，之后的是协议名，可以看到一个协议也可以是某个协议的超集，比如这里JGAddable是NSObject协议的超集（NSObject既是类，又是协议，that‘s amazing）

<code>@required</code>表明接下来的是实现这个协议的类必须要实现的方法。

<code>@optional</code>表明接下来的是实现这个协议的类可有可无的方法。

可以看到protocol就相当于定义了一个类的接口约束

##Category

Category其实就是扩展的概念，与Swift中的extension是一致的，我们现在就来扩展我们的Note来实现这个协议:右键=>newfile=>objective-c file=>命名为Addable,类型是Category，Class为Note => Done.

然后在Note+Addable.h里指明要实现Addable协议:

	@interface Note (Addable)<JGAddable>
	
接下来在Note+Addable.m里实现这个协议就好了，如下所示:

<script src="https://gist.github.com/izhuxin/a77dd89cdcc58956c383.js"></script>

之后我们需要使用addanother的时候，就只需要
	
	#import "Note+Addable.h"
然后再在需要的地方调用<code>[someNote addAnother: anotherNote]</code>就可以啦。当然了Category最主要的威力还是为Cocoa的库增加多更方便的函数从而使他们能够更好的fix我们的project。


##总结
1.  现在你应该已经懂得了一个OC里的一个类该怎么编写，而且还粗略地知道了Foundation库里的一些重要的数据结构。

2.  当然我的介绍是相当不完整的，我觉得学习一门语言我觉得最主要的是意淫的能力，意淫某个Foundation库的类有着某个函数而不是自己去写大量的hardcode来实现简单的功能。

3.  如果你之前有过OOP基础，那相信你应该可以编写出很多很有用的类了。
 
##Assignment
完成《iOS iOS_Apprentice_1_Getting_Started》的Demo，Enjoy your game :-)
<figure>
<a href="1.png"><img src="1.png" /></a>
</figure>
