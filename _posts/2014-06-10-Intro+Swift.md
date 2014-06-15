---
layout: post
title: "Swift简介"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: objective_tutorial.jpg
comments: true
diary: 今年6月3日，Apple发布了新的语言－－Swift，一下子周围的兄弟都欢腾了＝＝我也要搞搞动静才行，应邀去给师弟师妹吹水关于Swift的介绍，所以就想先把忽悠的内容写一下。这里所讲的只是我的个人理解，而且非常的不详细，如果有明显错误，希望大家能指出来。

mathjax: 
---
今年6月3日，Apple发布了新的语言－－Swift，一下子周围的兄弟都欢腾了＝＝我也要搞搞动静才行，应邀去给师弟师妹吹水关于Swift的介绍，所以就想先把忽悠的内容写一下。这里所讲的只是我的个人理解，而且非常的不详细，如果有明显错误，希望大家能指出来。

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

- Swift，按照Apple的说法，其主要是为了替代年老的Objective－C，集合了众多现代语言的特性之后创造出来的一门新的语言。在语法方面，Swift 迁移到了业界公认的非常先进的语法体系，其中包含了闭包，多返回，泛型和大量的函数式编程的理念，函数也终于成为一等公民可以作为变量保存了（虽然具体实现和用法上来看和 js 那种传统意义的好像不太一样）。初步看下来语法上借鉴了很多 Ruby 的人性化的设计，但是借助于 Apple 自己手中 强大的 LLVM，性能上必须要甩开 Ruby 不止一两个量级。

- Apple称这不是脚本语言，因为所以Swift代码都会被LLVM 编译为 native code，运行效率极高（速度是python的9倍）。但我更想把它当作脚本语言来对待，因为它可以一行代码就表示为一个完整的程序，而且在Playground里可以支持实时编译甚至实时运行！

- Swift可以跟C，Objective－C一起和谐的相处，我想这是因为作为一门新语言，bug肯定多，所以还需要长辈帮一把。但是，不同于 objc 和 c++ 或者 c 在同一个 .mm 文件中的混编，swift 文件不能和 objc 代码写在同一个文件中，你需要将两种代码分开

##编写一个类

枯燥的语法学起来实在是无味，所以还是打算从一个完整的类的编写来概述其语法（本来swift是为了让青年人能更好的从0开始学编程，但是本文还是很不识趣的默认读者至少学过一种编程语言，理解面向对象的思想）。

{% highlight javascript %}
//0
class Page {
    //1
    var data = Character[]()
    
    //2
    let size: Int
    
    //3
    init( size:Int ){
        self.size = size
    }
    
    //4
    func insertData( otherdata:Array<Character> ) -> Bool {
        var success = false
        //5
        if self.data.count + otherdata.count > self.size {
            println( "Insert fail: \(self.data.count - self.size) bytes exceed!" )
        } else {
            //6
            for i in 0..otherdata.count {
                data += otherdata[i]
            }
            //data += otherdata
            success = true
        }
        return success
    }
    
}

func test() {
    //7
    let testPage = Page( size: 4 * 1024 )
    let helloArray:Array<Character> = ["h","e","l","l","o"]
    var success = testPage.insertData( helloArray )
    while success { //8
        success = testPage.insertData( helloArray )
    }
}

{% endhighlight %}

0, 我们可以看到，定义一个类是class关键字＋类名再加一对大括号组成的（这里跟C＋＋的区别就是最后没有分号

1， 在swift里定义一个变量就跟在js里是一样的，支持像这样的隐式地确定变量类型

2， let关键字相当于定义了一个常量，不论变量还是常量，可以用":+类型名“来显式地指定类型，但这里的常量没有赋初值，所以会有提示语法错误，只有我们在后面对它赋了初值才会认为语法正确。Swift里的变量/常量的常用类型包括：Bool，Character， Int， Double，String， Array， Dictionary等等 

3， 每个类都会有一个init方法（如果你有OC经验自然是不必说，若果没有的话，这可以看作有点类似于C＋＋的构造函数）Swift里函数接受参数的格式是“参数名：类型”这样，在init方法里可以对之前定义的一些变量和常量赋值

4， swift里定义一个函数是一func关键字开头的，除了接受参数以外，其还有一个返回类型，通过“->＋类型名”来指定

5， swift里的条件判断包括if，switch，if的写法跟C里的区别就只是少了一对圆括号而已

6， swift里的循环包括了for，while等，for的写法多种多样，这里是用了“for something in Array”这样的写法，0..otherData.count 相当于是定义了一个［0，otherData.count）的数组。而0...otherData.count－1则是定义了一个［0，otherData.count－1］的数组

7,  定义一个类的实例，就跟普通的常量，变量没有太大区别，就是要在初始化时指定哪个形参接受的实参。

8,  while循环，跟C里的却别就只是少了一对圆括号而已

##小结
好吧，通过刚才的学习，你大概看到了一个完整的类的写法，我觉得这种方法最为直观，当然就是非常的不全面，对于学习一门语言来说会比较的不系统，如果你是打算从头开始好好研究这门的语言的话，Apple的[这门教程](https://itunes.apple.com/us/book/swift-programming-language/id881256329?mt=11&uo=8&at=11ld4k&uo=8&at=11ld4k&uo=8&at=11ld4k)会非常适合你。