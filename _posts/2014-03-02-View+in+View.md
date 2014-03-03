---
layout: post
title: "一种简单适配iOS开发中各种屏幕的投机取巧方法"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: ios6_ios7_home_screens.jpg
comments: true
mathjax: 
---

<section>
  <header>
    <h1 >大纲</h1>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>


#背景介绍
正如标题所说，Jeason想出来的这个方法是投机取巧式的，是有一定适用条件的。在这里，我不会将IOS中不同尺寸不同系统的适配问题统统讲完，不过会在后面给出其他适配方法的链接。

- 是这样的，之前Jeason实习的那家公司的产品从iOS7发布之前就开始启动了，所以之前的设计一直没有考虑iOS6/iOS7适配的问题。
- 而设计师严重缺人而且主美之前还无IOS开发的经验，所以我们也几乎没有考虑iPhone5的尺寸问题。
- 这个春节项目接近尾声，经理一直在催赶进度，我需要找到一种简单的适配方法来达到在iOS6，iOS7以及3.5寸和4.0寸视觉效果上的基本一致(至少不会太差)。
- 提一下重要的一点，就是我们的项目是拆分了一个个模块，每个模块的界面大多是用xib搭建的，而且大多带有导航栏。这是问题的难点，同时这也是这个方法的关键。

#View in View的方法

##导入
为了方便说明这个方法，我随手弄了一个小project，如下图所示，虽然丑了点，不过大概能表达出真实的情况。
  这是一个登录页面，上面有很多个必要的控件而且有一个iOS7风格的导航栏，还有背景图。
<figure>
<a href="{{ site.url }}/images/2014/03/02/1.jpg"><img src="{{ site.url }}/images/2014/03/02/1.jpg" /></a>
</figure>

现在这样在3.5寸，iOS7的模拟器上运行视觉上是OK的。（不要问我为什么会这么丑，这只是demo）问题主要是出现在当在iOS6上和4寸的模拟器上时，会出现比较大的问题，如下所示。
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/02/2.jpg"><img src = "{{ site.url }}/images/2014/03/02/2.jpg" /></a>
<a href = "{{ site.url }}/images/2014/03/02/3.jpg"><img src = "{{ site.url }}/images/2014/03/02/3.jpg" /></a>
</figure>

正如第一张图所示，iOS6的self.view.frame的零点是在状态栏以下的位置，而iOS7的则是在整个屏幕的最左上方位置，两者纵坐标相差20px。而第二张图则说明了另一个问题，就是在依靠xib搭建的界面元素不会动态地去布局。

通过一些搜索的尝试，我发现了一些其他人的解决方案。对于第一个问题，有人说xib里取消到autolayout就可以设置iOS6/iOS7中的坐标差，从而使整个页面的元素可以在iOS6中整体往上移动20px。但事实上这个方法对有很多个元素的界面效果并不好。另外，要解决第二个问题，Apple给出的最佳解决方案使autolayout，而autolayout在xib里使用是最为方便的，在代码中使用autolayout实在有点冗长。所以我冥思苦想，想出了下列这种方法。

##实践

###引入内层View
<figure>
<a href = "{{ site.url }}/images/2014/03/02/4.jpg"><img src = "{{ site.url }}/images/2014/03/02/4.jpg" /></a>
</figure>

- 首先，如图中1位置所示，拖拽一个UIView进入xib中。
- 然后把原本的self.view拉入新建的UIView中作为它的subview，如图中2位置所示。
- 然后将图中2位置中的上面的View（我们在以后称它为外层View）的Referencing Outlets指向File's Owner。
- 将图中2位置中的下面的View（我们以后称它为内层View）的Referencing Outlets连接删去。
这样做，就相当于新建了一个UIView从外层“包住”了原本的视图中的所有的元素，这样就可以通过控制内层View的坐标而使它内部的所有subviews同步地平移。

###使用autolayout
正如上面所说的，我们是要让内层view整体平移，所以只需在内层view上添加autolayout就可以了。首先不管是iOS6还是iOS7中，内层view的底/左/右端和外层view的底/左/右端的距离都为0。所以通过xib中添加这三个constrains就可以了，如下图所示。
<figure>
<a href = "{{ site.url }}/images/2014/03/02/5.jpg"><img src = "{{ site.url }}/images/2014/03/02/5.jpg" /></a>
</figure>

那个小红点是由我们只确定了下左右的constrains，而对上端没有约束造成的。对于内层view的上端和外层view的距离，我们希望它在iOS6中为－20px，即在iOS6中内层view上推20px，而在iOS7中为0px。这种动态效果是要靠代码中来实现的。

###在代码中使用autolayout

####创建IBOulet

在xib中，将内层View通过Control＋拖拽的方法拉入对应的ViewController.m代码中（在我这里是IOS6_7_DemoMainViewController.h）的@nterface部分

{% highlight objective-c %}
@interface IOS6_7_DemoMainViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

{% endhighlight %}

####定义iOS7宏

同样在.m文件中加入下面的iOS7判断的宏定义
<code>#define IS_IOS7 [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0?YES:NO</code>

###在viewDidLoad中使用autolayout

在同一个文件中，找到viewDidLoad这个函数在尾部添加下面的autolayout的代码
{% highlight objective-c %}
    NSLayoutConstraint *top_constraint;
    if ( IS_IOS7 ) {
        top_constraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view 
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:0];
    } else {
        top_constraint = [NSLayoutConstraint constraintWithItem:self.backgroundView
                                                      attribute:NSLayoutAttributeTop
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self.view 
                                                      attribute:NSLayoutAttributeTop
                                                     multiplier:1
                                                       constant:-20];
    }
    [self.view addConstraint:top_constraint];

{% endhighlight %}

关于autolayout的使用，可以参考Apple中关于[autolayout的文档](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Introduction/Introduction.html)。现在，我们再运行一下模拟器，可以看到iOS6中已经可以显示正常了。不过在4寸屏幕上的问题仍然没有解决。
<figure>
<a href = "{{ site.url }}/images/2014/03/02/6.jpg"><img src = "{{ site.url }}/images/2014/03/02/6.jpg" /></a>
</figure>
不过没有关系，我们有autolayout!

###解决4寸屏幕上的问题
4寸屏幕主要是让背景图片可以伸缩填充整个屏幕，所以要在背景图片的imageView上添加高度为greater than current value的constrains，底部距离内层View为0px的constrains就可以了，如图所示。

<figure>
<a href = "{{ site.url }}/images/2014/03/02/9.jpg"><img src = "{{ site.url }}/images/2014/03/02/9.jpg" /></a>
</figure>

至此所有的适配工作已经完成，整个页面可以在iOS6/iOS7，3.5/4寸屏幕上显示基本正常。
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/02/7.jpg"><img src = "{{ site.url }}/images/2014/03/02/7.jpg" /></a>
<a href = "{{ site.url }}/images/2014/03/02/8.jpg"><img src = "{{ site.url }}/images/2014/03/02/8.jpg" /></a>
</figure>

##总结
这种View in View的方法，主要步骤有：

1.  新建了一个UIView从外层“包住”了原本的视图中的所有的元素。

2.  在xib中为内层的view添加下/左/右端的constrains值。

3.  在代码中为内层view动态地添加上端的constrains值。

4.  如果有背景，则让背景的高度可以变高，并为其添加必要的或上或下或左或右的constrains值。

#其他方法总结
1.  [不启用autolayout适配导航栏问题（苹果官方建议）](http://blog.csdn.net/chengwuli125/article/details/12613897)

2.  [修改windows frame的方法](http://blog.csdn.net/chengwuli125/article/details/12617657)

3.  [简单适配3.5寸, 4c寸iPhone屏幕](http://www.xiaoyaoli.com/?p=897)

