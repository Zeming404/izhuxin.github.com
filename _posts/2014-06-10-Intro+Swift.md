---
layout: post
title: "iOS开发入门：Swift"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: swift.jpg
comments: true
diary: 今年6月3日，Apple发布了新的语言－－Swift，一下子周围的兄弟都欢腾了＝＝我也要搞搞动静才行，应邀去给师弟师妹吹水关于Swift的介绍，所以就想先把忽悠的内容写一下。这里所讲的只是我的个人理解，而且非常的不详细，如果有明显错误，希望大家能指出来。

mathjax: 
---
本文假设你已经对Swift的基本的数据类型，变量等都有一定的了解，有过面向对象和面向函数的编程经验自然是最好的了。

<section>
  <header>
    <h2>目录</h2>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>

##函数的概念

首先我们先来看看Swift的函数的概念。函数是把一段操作（包括定义变量，以及对这些变量进行其他函数操作）封装起来的黑盒子。黑盒子的左边是输入的参数，盒子的右边是函数的返回值。所以，在面向函数的程序设计里，会把一个个函数作为我们编程的单元，用这些函数来构建出我们的程序。我们可以来看看一个函数的写法：（你可以打开的playground然后输入下面的代码）


<pre><code class="language-swift">
func square(number: Double) -> Double { 
    return number * number;
}
 
let a = 3.0, b = 4.0
let c = sqrt(square(a) + square(b)) 
println(c)
</code></pre>

每个函数都有func关键词作为开头，来表明接下来的是一个函数的定义，接下来是函数的名字，之后由括号括起来的是函数的实参以及其类型，之后由剪头指向函数的返回值，最后由花括号讲函数体括起来，而函数体将会在执行到return语句时停止。

###函数是一等公民

在Swift（以及其他支持函数式编程的语言）中，函数可以赋予给一个变量，可以把它们传给其他函数或者从其他函数返回（想想一个函数的返回值是一个函数，学过Haskell的你应该不会陌生）。

###函数的类型

函数的类型由函数的参数个数，参数类型和它的返回类型共同决定。比如刚才的square函数，它的类型表示为(Double) -> Double，

###外置参数名

如果你是Objective-C的粉丝，那么你肯定喜欢Objective-C那种一拿上来一个函数就可以用英文读出来的感觉。而C/C++的函数则显得比较难懂一些，Swift作为C语言的一个超集，既可以像C语言一样调用函数，又可以用外置参数名 names的方式来使函数可以像在OC中一样易读懂，来看看下面这个例子：
<!--<script src="https://gist.github.com/izhuxin/0e8fa3f71d10eea68130.js"></script>
-->
<pre><code class="language-swift">

func sub( jianshu: Int, beijianshu: Int ) -> Int {
    return beijianshu - jianshu
}
sub( 3, 5 )

</code></pre>

嘿，你会发现在你不查看函数定义之前，你根本不知道是谁减谁，而使用了External parameter names的方式则允许你使用下面这样的方式来调用：

<pre><code class="language-swift">

func sub2( #jianshu: Int, #beijianshu: Int ) -> Int {
    return beijianshu - jianshu
}
 
sub2(jianshu: 3, beijianshu: 5)

</code></pre>

<!--<script src="https://gist.github.com/izhuxin/4d927aed685f3ab4f871.js"></script>
-->
这是我觉得最酷的方式，因为你只需要在行参前面加上一个#号。当然你也可以用其他的方式来使用External parameter names，详情参考Apple的Swift Tutorial，这里就不再赘述啦。

##匿名函数－－闭包
>&quot;Block其实是iOS里封装提供出来的函数闭包的概念，它是在iOS4以后被提出来取代delegate和call back模式的一种新的概念。
 对于闭包（block),有很多定义，其中闭包就是能够读取其它函数内部变量的函数，这个定义即接近本质又较好理解。对于刚接触Block的同学，会觉得有些绕，因为我们习惯写这样的程序main(){ funA();} funA(){funB();} funB(){.....}; 就是函数main调用函数A，函数A调用函数B... 函数们依次顺序执行，但现实中不全是这样的，例如Jeason在团队里是个PM的角色，手下有3个程序员：经纶、经伦、径伦，当他给经伦安排实现功能F1时，他并不等着经伦完成之后，再去安排经纶去实现F2，而是安排给经纶功能F1，经伦功能F2，径伦功能F3，然后安排完了去约会，而当经伦遇到问题时，他会来找jeason，当经伦做完时，会通知jeason，这就是一个异步执行的例子。在这种情形下，Block便可大显身手，因为在Jeason给经伦安排工作时，同时会告诉经伦若果遇到困难，如何能找到他报告问题（例如打他手机号），这就是jeason给经伦的一个回调接口，要回调的操作，比如接到电话，百度一下后，返回网页内容给经伦，这就是一个Block，在jeason交待工作时，已经定义好，并且取得了F1的任务号（局部变量），却是在当经伦遇到问题时，才调用执行。block在多线程编程和函数式编程（并不是函数式的语言才能面向函数的编程＝。＝）里都有着重要的应用，想对block更进一步了解的同学，可以看看唐巧的[这篇博文](http://blog.devtang.com/blog/2013/07/28/a-look-inside-blocks/);
&quot;
><small><cite title="Jeason">引用自我之前的文章</cite></small>

Swift中对闭包也有了自己的实现，swift中闭包的写法是非常灵活的，一种最为中规中矩的写法就是：
<!--<script src="https://gist.github.com/izhuxin/9d1b26cf1bf841af0841.js"></script>
-->
<!--{% highlight javascript %}
-->
<pre><code class="language-swift">
let animals = ["fish", "cat", "chicken", "dog"]
let sortedStrings = animals.sorted({
    (one: String, two: String) -> Bool in
        return one > two
    })
println(sortedStrings)
</code></pre>
<!--{% endhighlight %}-->
可以看到，sort接受的参数是一个函数，而我们则可以传入一个闭包，由花括号括起来的部分，接下来的下一行是闭包的行参和它的返回值，in关键词后面的则对应了函数的函数体，这种写法，除了闭包是匿名的之外，其他的跟函数的写法都是一一对应的，当然你可以写的更加风骚一点，比如像这样：

<code>let sortedStrings = animals.sorted({ $0 > $1 })</code>

##类的概念

类的定义有点多，我们可以简单的把类理解为将函数和变量捆绑起来的一种结构，它封装了某个具体的事物的属性以及它能执行的操作。在面向对象的程序设计里，我们会把一个个的类作为我们编程的单元，用这些类的实例（也就是对象）来构建出我们的程序。我们可以来看看一个类的写法：（同样的，在playground里键入下面的代码）
<!--<script src="https://gist.github.com/izhuxin/7c408694ff9b4f3d2001.js"></script>
-->
<pre><code class="language-swift">
 
class Treasure {
    let what: String
    let latitude: Double
    let longitude: Double
    
    init(what: String, latitude: Double, longitude: Double) {
        self.what = what
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init( what: String ) {
        self.init( what: what, latitude: 0, longitude: 0 )
    }
    
    convenience init() {
        self.init( what: "Nothing", latitude: 0, longitude: 0 )
    }
    
    func describe() -> String {
        return "Treasure \(what) is in ( \(latitude), \(longitude) )"
    }
 
}

</code></pre>

每个类都由class关键词开头，之后的便是类名，括号里面的是类的body。就像刚才说的，类的body由一些成员函数和成员变量（我们姑且把常量和变量一起笼统的称为成员
变量）组成。其中，每个类都有一个init成员函数，它类似于C++里面的默认构造函数，在这里我们可以对类的成员变量进行初始化。当然你也可以定义其他的构造函数，这时候就要加上一个convenience关键词，并且在这些函数里面调用默认构造函数。而当我们要使用这些类来编程时，就需要创建一个实例，并且调用它里面的方法。

{% highlight javascript %}
一个本人的小理解：其实我们会发现面向对象和面向函数的最本质区别就是抽象的层次不一样，类的复用很明显比函数的复用要局限的多，比如Treasure类只能用于有关“宝藏”这一级的抽象，而square则可以用于任意层次的抽象，比如某个“几何形的宝藏”，比如寻找的“路径”等等。
{% endhighlight %}

当然，我们刚才对类的简单定义是不够的，如果你有学过C++，那你应该知道struct也是一种可以把函数和变量捆绑起来的一种结构。事实上，我们完全可以将上面的代码改写成：
<!--<script src="https://gist.github.com/izhuxin/3935a5d3d0a28ab85255.js"></script>
-->

<pre><code class="language-swift">

struct Treasure {
    let what: String
    let latitude: Double
    let longitude: Double
    
    init(what: String, latitude: Double, longitude: Double) {
        self.what = what
        self.latitude = latitude
        self.longitude = longitude
    }
    func describe() -> String {
        return "Treasure \(what) is in ( \(latitude), \(longitude) )"
    }
}

</code></pre>

没错，这仅仅是把class关键词改成struct关键词而已。而作为类，还有另外一些基于面向对象的特性，这些事struct所没有的，接下来我们就一一介绍：

###访问控制

如果你之前学过C++或者Java，那你应该会知道类的每个成员都有访问控制的关键词来指明它可以被什么对象来访问，在Swift里面，有三种访问控制关键词：

- Public: 任何的代码都可以获得这个成员的访问权

- Internal: 只有在同一个进程里的代码可以获得它的访问权（default）

- Private: 只有在同一个文件里的代码可以获得它的访问权（打开playground，在describe前面加上private试试，结果是不是跟你预期的不太一样呢？）

###继承

我们可以用一个类来继承另外一个类，从而获得它的成员变量和成员函数，同时还可以增加新的成员变量，成员函数，或者是重写旧的成员函数，像下面所示：(打开playground，在刚才的地方后面加入以下代码)
<!--<script src="https://gist.github.com/izhuxin/0ddeb7aca59a4aebce8a.js"></script>
-->
<pre><code class="language-swift">
class HistoryTreasure: Treasure {
    let year: Int
    
    init(what: String, latitude: Double, longitude: Double, year: Int) {
        self.year = year;
        super.init(what: what, latitude: latitude, longitude: longitude);
    }
    
    override func describe() -> String {
        return "History treasure \(self.what) at \(self.year) is in (\(self.latitude), \(self.longitude))"
    }
}

</code></pre>

当我们想要指明A类继承自B类时，只需要在A类名后面加上“: B”即可，当我们需要重写B类的一些方法时，需要在func前面加上override的关键词，当我们要在类内决定调用的是子类的函数，还是父类的函数时，则可以用self和super来指明。

继承是一种“is-a”的关系，比如我们想要描述动物园里的各种动物，我们有一个类称为“Animal”，它封装了动物的吃喝拉撒睡等一般行为。为了描述🐒这个具体的动物的其他行为，我们可以编写一个类“Monkey”继承自“Animal”，这个Monkey是动物的一种，所以我们说 Monkey is an Animal.因此，在Swift中，Animal的reference即可以指Animal实例，又可以指Monkey实例。

###多态和动态绑定

上面说到的现象称为多态，即对于一个父类的方法（虚函数），每个子类可以有自己的实现方式。而且当由父类的reference或者是pointer来调用这个方法时，具体执行哪个实现方式，则是在运行时决定的。写成代码如下：(打开playground，在刚才的地方后面加入以下代码)
<!--<script src="https://gist.github.com/izhuxin/5319ea4351be9a6bf1e7.js"></script>
-->
<pre><code class="language-swift">
var basic : Treasure!
basic = Treasure( what: "Apple", latitude: 10.0, longitude: 10.0 )
basic.describe()
 
basic = HistoryTreasure( what: "Apple", latitude: 10.0, longitude: 10.0, year: 1993 )
basic.describe()

</code></pre>

在这里，我们调用了两次<code>basic.describe()
</code>，而这两次的实际执行的代码是不一样的。

##扩展的概念

如果你之前学过Objective-C,那么你应该知道有Category这个概念，它可以扩展一些类（包括库的类），为这些类增加一些方法。同时，Objective－C也有protocol的概念，它提供了一种类似于Java的Interface的概念。一个类可以选择实现一个或者多个protocol。这些Protocol的代码会导致一个类变得非常臃肿，为此我们常常需要分离一些代码来分别实现这些协议来脱耦合，详细请看objc.io的[#isssue1](http://www.objc.io/issue-1)。

而在Swift中，这两个概念则被联系到了一起：为一个Class增加扩展，这个扩展可以是某个协议的实现。当然了，扩展也可以不实现任何协议，就只是为类增加某些方法和属性（这一点跟Category只能增加方法不同）。来看一个具体的实例吧：
<!--<script src="https://gist.github.com/izhuxin/5f5775933f3c34277dbb.js"></script>
-->
<pre><code class="language-swift">
@objc protocol Addable {
    func addAnother(a:Addable) -> NSObject
}
 
class JEInt : NSObject {
    var value: Int = 0
}
 
extension JEInt: Addable {
    func addAnother(a: Addable) -> NSObject {
        if let another = a as? JEInt {
            self.value += another.value
        }
        return self
    }
}

</code></pre>

在Swift中， protocol以@objc protocol开头，之后跟着的是协议的名字，花括号里面的是具体的方法接口
当我们希望某个类来实现这个协议时，可以用extension来扩展它的时候在类名后面加上“: ‘protocol’ ”然后再提供一些接口的方法就好了。当然，这不是唯一的方式，只是有了extension可以让我们很方便地把协议相关的代码分离出来，使逻辑更加清晰。

##HW Assignment

完成《Swift By Tutorials》第三章的Demo






