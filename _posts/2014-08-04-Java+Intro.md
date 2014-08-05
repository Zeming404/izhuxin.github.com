---
layout: post
title: "Java开发入门"
description: ""
category: blog
tags: [Course]
image: 
  feature: java.jpg
comments: false
diary: 最近因为实训和编译原理课程的缘故所以开始要看一下java的内容。因为知道XCode以及其一套开发套件对我学习OC的帮助有多大，所以快速的搭建好自己的Java开发环境就至关重要。所以就整理一下，方便有需要的同学可以参考一下....

mathjax: 
---

最近因为实训和编译原理课程的缘故所以开始要看一下java的内容。因为知道XCode以及其一套开发套件对我学习OC的帮助有多大，所以快速的搭建好自己的Java开发环境就至关重要。所以就整理一下，方便有需要的同学可以参考一下。本文适合那些:

- 有过一定编程经验，了解OOP，有过一定的小型工程经验的同学;
- 习惯了在OS X上写代码，突然之间想学一下Java的同学;
- 觉得那些开发套件只是工具，我要做的只是怎么更好地利用这些工具帮助我的同学;
- 将要参加中大软院的中级实训的同学。

<section>
  <header>
    <h2>目录</h2>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>

##Java基本语法

当然我不可能在这里长篇大论Java语法，我只是说几点:

- Java和OC的比较.貌似挺多人有问过这种问题→_→估计这起源于Google和Apple之争，好吧，从我这两天的学习经历来看，两者好像完全没什么好比的，OC和C++几乎产生于同代，Java是对C++的完善，两者完全就是不同时代的产物。
- Java的运行效率看起来好像比较低，不过它的强大在于跨平台和丰富的包（后面会提到），有种python的静态版的感觉，强大而且灵活。
- Java可以方便的与浏览器勾搭在一起，通过一种叫applet的形式，因此在现代Web技术方面仍有一席之地，而且因为Java程序只需要一个Java虚拟机就可以运行，所以很适合作为科研目的的开发（如编写一个编译器）。

再来就是推荐几个快速学习的网站，这些网站可能不是最好的，不过对于我这种只是想在几个小时或一天内入门的同学来说，其实差不了很多:

- Java基本程序设计: [http://www.learnjavaonline.org](http://www.learnjavaonline.org)
- Java Swing组件:   [http://zetcode.com/tutorials/javaswingtutorial/](http://zetcode.com/tutorials/javaswingtutorial/)
- 参考手册: [http://www.w3cschool.cc/java/java-tutorial.html](http://www.w3cschool.cc/java/java-tutorial.html)

我参考的其他的文档还有JDK的API，这也是我最常用也最实用的学习文档。

##Java编辑器
在了解了Java语法，下载了最新的JDK和JVM后，就可以考虑来写写代码了，我一开始想直接用XCode来写，发现XCode4以后就不支持Java开发了＝。＝

<figure>
<a href="{{ site.url }}/images/2014/08/05/1.jpg"><img src="{{ site.url }}/images/2014/08/05/1.jpg" /></a>
</figure>

我马上想到了用Emacs，不过我的Emacs已经被我配置成一个C/C++ IDE了，要把java开发也配置得那么顺心，实在懒得再折腾，之后试了下在sublime下写了一会，发现实在不够顺手，最后装了个gVim勉强还能写一点小程序。Vim得快捷键+命令什么的，虽然感觉挺方便挺强大，但是对于习惯了Emacs快捷键，会一直不停的按C+X, C+S的我来说，实在是噩梦，所以我写完了几个程序之后就放弃了Vim。最后的最后我找到了一个叫NetBean的IDE，可以把它的编辑器改成Emacs的快捷键绑定，也能方便的查看JDK的文档和方便的写单元测试，也算是能基本满足我的要求了，只是因为它是用纯Java写成的，会有一点小卡……

当然很多人会推荐Eclipse，只是因为我当时的校园网实在太慢，8KB每秒的速度，下个JDK都要挂一个晚上，我手头又刚好有个下载好了的NetBean的安装包（好像是当年看别人推荐就去下了然后一直放着没喷＝＝），所以就先凑合着用呗，暂时还是很满意的。

##工程管理Ant
在用IDE之前，我想要编译和链接有多个文件，或者是想要编译一个工程的时候，发现直接在命令行里用JDK的javac实在太麻烦了，所以我想到需要一个脚本来帮忙管理工程，比如说Makefile什么的。查了下，发现有个叫做Ant的，它就像是Makefile一样，可以指定生成一个项目Target需要的tasks，task与task之间有着依赖关系，说了那么多，不如看个实例学的快些。

###一个简单的Ant脚本

{% highlight html %}
<!--注释0-->
<?xml version="1.0"?>
<!--注释1-->
<project default="dist" name="Project Argon">
     <description>A simple Java project</description>
 <!--注释2-->
    <property name="srcDir" location="src"/>
    <property name="buildDir" location="build"/>
    <property name="distDir" location="dist"/>
 <!--注释3.1-->
    <target name="init">
       <tstamp/>
       <mkdir dir="${buildDir}"/>
       <mkdir dir="${distDir}"/>
    </target>
<!--注释3.2-->
    <target name="compile" depends="init">
       <javac srcdir="${srcDir}" destdir="${buildDir}"/>
    </target>
 
    <target name="dist" depends="compile">
       <jar destfile="${distDir}/package-${DSTAMP}.jar" basedir="${buildDir}">
         <manifest>
           <attribute name="Built-By" value="${user.name}"/>
           <attribute name="Main-Class" value="package.Main"/>
         </manifest>
       </jar>
       <jar destfile="${distDir}/package-src-${DSTAMP}.jar" basedir="${srcDir}"/>
    </target>
 
    <target name="clean">
      <delete dir="${buildDir}"/>
      <delete dir="${distDir}"/>
    </target>
</project>
{% endhighlight %}

0 一眼看去，很明显这是一个XML格式的文件，嗯，没错，就好像Makefile脚本一样，ant脚本的名字需命名为build.xml

1 第一个tag是ant定义的tag，叫做project，default指定了它默认执行的target，name则指定了这个工程的名字。

2 property标签可以定义一个变量，这样在后面的时候就可以直接用$(propertyName)来引用这个变量了，这一点和Makefile一样。

3.1  target标签可以定义一个任务，比如我们在编译一个工程的源代码之前，要先新建好文件夹来放编译好的文件.

3.2  target与target之间往往有着一定的依赖关系，比如我们在生成一个项目的时候，总是先产生目标文件夹，编译源代码，然后把目标文件打包至目标文件夹，这时就要用depends属性来指定生成target之间的依赖关系。
这里我们的目标文件是一个jar文件，jar文件有点类似于OC里的framework，就是把一堆类打包起来然后方便给其他项目使用。

##单元测试Junit
好了，接下来就是如何提高自己的代码质量的问题了。我觉得多思考自己写的代码，然后多写一些单元测试来测试代码还是很重要的，因为这会强制要求我们在做项目时回到工程的级别上来，而不只是在当搬砖工。这时候就会用到一个叫Junit的库。翻了下Junit的项目地址，貌似下载链接被墙了＝，＝一般Java IDE都会配置有Junit，如果大家想不用IDE就先用着[我这个版本的Junit](http://pan.baidu.com/s/1c0iYYYG)吧.

###一个简单的测试代码
{% highlight java %}
/*
* SYSU-SS GridWorld Case Study Demo:
* CalculatorTest.java
* Copyright(c) 2014 Jeason (http://jeason.me)
*
* This code is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation.
*
* This code is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* @author Jeason
*/

package S1;

import org.junit.Test;
import static org.junit.Assert.*;


public class CalculatorTest {
    /**
     * Test of main method, of class Calculator.
     */
    @Test
    //1
    public void testMain() {
        System.out.println("Test main");
        String[] args = null;
        Calculator.main(args);

    }
    /**
     * Test of checkDigitStr method, of class Calculator.
     */
    @Test
    public void testCheckDigitStr() {
        System.out.println("Test checkDigitStr");
        System.out.println("case 1: 12.34");
        String str = "12.34";
        //2
        boolean expResult = true;
        boolean result = Calculator.checkDigitStr(str);
        //3
        assertEquals(expResult, result);
      
        System.out.println("Case 2: abc");
        str = "abc";
        expResult = false;
        result = Calculator.checkDigitStr(str);
        assertEquals(expResult, result);
    }
}
{% endhighlight%}

被测试的类在[这里](https://gist.github.com/izhuxin/6855a30ac44a5accfb6e)

1.  对于高版本的Junit（忘了是从几点几开始的），可以直接用<code>@Test</code>标记来指明你的测试函数是哪个，在@Test之后下一个函数即为测试函数，Junit的TestRunner类会直接找到它并且运行这一个函数的代码。

2.  想要测试自己的某个函数，只需要定义好自己期望的结果并计算这个函数运行后的结果然后保存起来就好了。

3.  assertEquals函数就会检测两个结果是不是一致，若一致则现实Success，否则则提示False，另外类似的还有assertArrayEquals, assertNotNull等等。

##用SonarQube分析你的代码
一般的重量级IDE都会有分析代码的工具，比如XCode，MS VisualStudio，分析的主要目的是检测你代码的藕合度，复杂度，代码重复率等，以方便你可以决定是否对工程进行重构以便于维护。这里主要介绍SonarQube，它是一个开源的代码质量管理平台，使用的是 LGPL V3 软件许可，你可以在github上翻到其项目地址。

其使用起来也是很方便（后来发现它可以和Eclipse配合联调，可惜我没装Eclipse）只需要：
1.  先[下载其发行版](http://www.sonarqube.org/downloads/), 然后将其解压至某一个文件夹,然后cd到解压存放文件夹/bin/[OS]/，然后执行 sonar.sh start即可启动它了。

2.  然后下载[SonarQube Runner](http://www.sonarsource.org/downloads/)并解压到某一文件夹，然后在你要测试的工程文件夹里面创建sonar的配置文件,例如:

{% highlight C %}
#required metadata
#projectKey是唯一标示符，可以随便取
sonar.projectKey=10389179
sonar.projectName=10389179
sonar.projectVersion=1.0
sonar.sourceEncoding=UTF-8
sonar.modules=java-module

java-module.sonar.projectName=GridWorld
java-moudle.sonar.language=java

java-module.sonar.sources=.
#假设项目的源文件放在src文件夹内
java-module.sonar.projectBaseDir=src

{% endhighlight %}

然后再在这个文件夹目录下执行<code>你解压的文件夹/bin/sonar-runner</code>命令，就可以分析你的代码了，然后打开http://localhost:9000就可以看到你的分析结果啦，如果出现下面的页面，就说明你已经完成了SonarQube的配置啦：

<figure>
<a href="{{ site.url }}/images/2014/08/05/2.png"><img src="{{ site.url }}/images/2014/08/05/2.png" /></a>
</figure>

##总结
至此，总算是可以开始用Java大干一场来开发东西啦，当然本文没有详细地介绍各个工具安装和使用的步骤，只是简单总结一下Java开发需要配置的东西，剩下的就靠大家自己去搜索解决吧(´･_･`)。