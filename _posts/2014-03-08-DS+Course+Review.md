---
layout: post
title: "SE 数据结构课程总结"
description: ""
category: blog
tags: [Courses]
image: 
  feature:
comments: true
mathjax: true
---

<section>
  <header>
    <h1 >目录</h1>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section>

#写在最前
这注定会是一篇很长的博文，可能我一次难以把它完全写好。本文主要是基于中山大学的《SE-221 数据结构与算法》这门课的课程内容而写，以后可能还有其他数据结构方面的补充与完善。

#基本数据结构
在我看来，基本的数据结构包括以下几个：List，Table，Tree，Graph，接下来会给大家一一介绍一下，以及我对这些数据结构的一些认识和总结。

##List
在我看来，List是最基本的数据结构，由它可以衍生出一些相当有用的数据结构，比如先进后出的stack和先进先出的queue等。所以只要我们掌握了list，就可以用它来实现这些比较实用的数据结构。而List又分为两种，一种是在数据存储上“逻辑上”连续的<strong>顺序List</strong>，一种是在逻辑上不连续的<strong>链接List</strong>。

###顺序List
最典型的一种顺序List就是数组。顺序List的一个最大的特点就是它可以通过数组下标，快速地访问到我们需要的位置上的元素。想到数组，那么它的一个最大的缺点也就不言而喻了：在数组的中部插入和删除元素时开销过大。C++的标准库为我们提供了一个封装好了的数组－－<a href = "http://www.cplusplus.com/reference/vector/vector/?kw=vector">std::vector</a>（因为课程里的数据结构是用C++实现的，所以本文以C++为例）。vector为我们提供了顺序list的基本操作，同时还额外提供了许多数组没有的功能，比如是在vector的尾部可以快速地增加和删除元素，提供的接口为<code>push_back()</code>和<code>pop_back()</code>，详情请参考[cplusplus.com](http://www.cplusplus.com)

###链接List
这就是我们一般意义上链表的概念了。链接List的一个最大特点就是它可以真正地做到动态分配内存进行快速的增加和删除元素。它的缺点刚好与顺序list的优点对应：不支持快速访问。同样的，C++标准库也为我们提供了一个链接List的经典实现－－[std::list](http://www.cplusplus.com/reference/list/list/?kw=list)。std::list是一个双向链表，它可以快速地访问链表的头部和尾部，可以快速地在链表中的任意位置快速的进行重复的增<code>insert</code>和删<code>erase</code>的操作。详情参考上面的链接。

###使用List实现其他数据结构
- Stack

- Queue
 
- String

##Table
Table在我看来，就是顺序List的一种延伸。

###Rectangular Table
它其实就是二维数组，包含数组的数组或者包含顺序List的顺序List，其跟顺序List不同之处就是它的元素也是一个顺序List，所以提供了两个下标为两个List来使用索引至我们想要的位置，它可以通过行展开或者列展开为一个顺序List，这其实没什么好说的。

###Hash Table
哈希是一个重要的内容，它是根据关键字而直接访问在内存存储位置的数据结构。也就是说，它通过把键值通过一个函数的计算，映射到表中一个位置来访问记录，这加快了查找速度。这个映射函数称做哈希函数，存放记录的数组称做哈希表。对不同的关键字可能得到同一散列地址，即k1 != k2，而f(k1)=f(k2)，这种现象称碰撞。处理碰撞的主要方法有:

###开放定址法
hash_i = ( hash(key) + d_i ) mod m, 其中hash(key)为哈希函数，m为哈希表的长度，d_i为增量序列，i为已发生碰撞的次数。增量序列可有下列取法：

- d_i=1,2,3...(m-1)称为线性探测；即d_i=i，或者为其他线性函数。相当于逐个探测存放地址的表，直到查找到一个空单元，把散列地址存放在该空单元。

- d_i= 1^2,2^2,3^2...k^2称为平方探测。相对线性探测，相当于发生碰撞时探测间隔d_i=i^2个单元的位置是否为空，如果为空，将地址存放进去。

- d_i=伪随机数序列，称为伪随机探测。

举个例子吧：关键字为{89,18,49,58,69}插入到一个散列表中的情况。此时线性探测的方法是取d_i=i。并假定取关键字除以10的余数为散列函数法则。

<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/1.jpg"><img src = "{{ site.url }}/images/2014/03/08/1.jpg" /></a>
</figure>

第一次碰撞发生在填装49的时候。地址为9的单元已经填装了89这个关键字，所以取i=1，往下查找一个单位，发现为空，所以将49填装在地址为0的空单元。插入58时，地址8处发生第一次碰撞，d = 1, 探测位置9，发生第二次碰撞，d= 2,探测位置1，位置1为空，将58插入位置1。69同理。
表的大小选取至关重要，此处选取10作为大小，发生碰撞的几率就比选择质数11作为大小的可能性大。越是质数，mod取余就越可能均匀分布在表的各处。
开放定址法的一个最大缺点就是容易造成聚集，使性能大大下降。所以开放定址法的表的至少要为一个比key的数量两倍还多的顺序List，且大小最好为质数。

###开放定址法的平均探测次数

####成功的平均探测次数
回到刚才举的例子，key89，18一次就放入了表内，探测次数为1，key49先在9的位置探测了一次，然后在0这个位置再探测了一次，探测次数是2，同理，可得58的探测次数时3，69为3.这样查找成功的平均探测次数为( 1 + 1 + 2 + 3 + 3 ) / 9。

####不成功的平均探测次数
计算查找不成功的次数就直接找关键字到第一个地址上关键字为空的距离即可。对于地址0，它到关键字为空的距离为3，地址1为2，地址2为1，地址8为1，地址9为2，所以不成功的平均查找次数是( 3 + 2 + 1 + 1 + 2 ) / 9.

###单独链表法
它的思想是将散列到同一个存储位置的所有元素保存在一个链表中。即为链接List的顺序List。对于有相同的f(key)的key值构成了一个链表，而所有的这些链表组成的数组就是单独链接法得到的哈希表，如下图所示:
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/6.jpg"><img src = "{{ site.url }}/images/2014/03/08/6.jpg" /></a>
</figure>

###单独链表法的平均探测次数
可以参考开放定址法得到.<!--TODO-->

##Tree
树，可以说是链接List的一个延伸。不同的是它每个节点都有多个指针，指向它的子树们。而在树中，最重要的就是二叉树。
{% highlight C++ %}
/* 二叉树的二叉链表存储表示 */
 typedef struct BiTNode
 {
   TElemType data;
   struct BiTNode *lchild,*rchild; /* 左右孩子指針 */
 }BiTNode,*BiTree;
{% endhighlight %}

###满二叉树
一棵深度为k，且有2^k-1个节点称之为满二叉树，如下图所示
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/3.jpg"><img src = "{{ site.url }}/images/2014/03/08/3.jpg" /></a>
</figure>

###完全二叉树
完全二叉树又叫做堆，它是深度为k，有n个节点的二叉树，当且仅当其每一个节点都与深度为k的满二叉树中序号为1至n的节点对应时，称之为完全二叉树。
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/2.jpg"><img src = "{{ site.url }}/images/2014/03/08/2.jpg" /></a>
</figure>

###二叉树的遍历
遍历即将树的所有结点访问且仅访问一次。按照根节点位置的不同分为前序遍历，中序遍历，后序遍历。
前序遍历：根节点->左子树->右子树
中序遍历：左子树->根节点->右子树
后序遍历：左子树->右子树->根节点
例如：求下面树的三种遍历
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/4.jpg"><img src = "{{ site.url }}/images/2014/03/08/4.jpg" /></a>
</figure>
 
前序遍历：abdefgc

中序遍历：debgfac

后序遍历：edgfbca

###AVL树

##Graph

###图的表示方式
- 数组（邻接矩阵）存储表示（有向或无向）。

<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/7.jpg"><img src = "{{ site.url }}/images/2014/03/08/7.jpg" /></a>
</figure>

- 邻接表存储表示。

<figure>
<a href = "{{ site.url }}/images/2014/03/08/8.jpg"><img src = "{{ site.url }}/images/2014/03/08/8.jpg" /></a>
</figure>

###图的遍历
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/5.jpg"><img src = "{{ site.url }}/images/2014/03/08/5.jpg" /></a>
</figure>
采用深度优先搜索和广度优先搜索的方法遍历图。（见下文：基本算法－基于图论的算法）

###拓扑排序
<figure class="half">
<a href = "{{ site.url }}/images/2014/03/08/9.jpg"><img src = "{{ site.url }}/images/2014/03/08/9.jpg" /></a>
</figure>

#基本算法

##排序

这部分我觉得直接通过代码来理解会最好了，我会在代码中加上足够的注释。

{% highlight C++ %}
//
//  sort.cpp
//  Courses
//
//  Created by Jeason on 14-3-8.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#include <stdio.h>
class sortBrain {
public:
    sortBrain( int *data_, int size_ );
    void bubble_sort();
    void seletion_sort();
    void inserting_sort();
    void merge_sort();
    void heap_sort();
    void quick_sort();
    void print_data();
    
private:
    //为了可以递归，所以在公有函数里调用似有成员里的函数，这种写法在研究生教材中很常见，其实挺有道理的
    void quick_sort( int begin, int end );
    void merge_sort( int begin, int end );
    void merge( int begin, int middle, int end );
    int *data;
    int size;
};

sortBrain::sortBrain( int *data_, int size_ ) {
        //Constructor
    //只是复制指针而没复制指针的内容，这种叫做浅复制
    //若复制内容，如 data = new int[size_] for( int i = 0; i < size_; i++ ) data[i] = data_[i]称为深复制
    data = data_;
    size = size_;
}

void sortBrain::print_data() {
    for (int i = 0; i < size-1; i++) {
        printf( "%d ", data[i] );
    }
    printf( "%d\n", data[size-1] );

}

void sortBrain::bubble_sort() {
    for (int i = 0; i < size; i++) {
        for (int j = 1; j < size - i; j++) {
            if ( data[j-1] > data[j] ) {
                int temp = data[j];
                data[j] = data[j-1];
                data[j-1] = temp;
            }
        }
    }
}
int maxIn( int *data, int begin, int end ) {
    int max = begin;
    for (int i = begin; i <= end; i++) {
        if (data[max] < data[i]) {
            max = i;
        }
    }
    return max;
}

void sortBrain::seletion_sort() {
    //将第i大的元素放到n－1-i的位置
    for (int i = 0; i < size; i++) {
        //找到0～n-1-i中最大的元素的下标
        int current = maxIn( data, 0, size-1-i );
        //如果找到的第i大的下标跟n-1-i不一样，就交换两个位置的内容
        if (current != size-1-i) {
            int temp = data[current];
            data[current] = data[size-1-i];
            data[size-1-i] = temp;
        }
    }
}

void sortBrain::inserting_sort() {
    int j, temp, k;
    for ( j = 1; j < size; j++ ) {
        //未排序的数列中的第一个元素
	    temp = data[j];
	    for ( k = j - 1; k >= 0; k-- ) {
            //从右往左扫描已排序的数列
            if ( data[k] > temp ) { //确定未排序的数列中的第一个元素在已排序数列中的位置
                data[k+1] = data[k];
            } else {
                break;
            }
	    }
        //将未排序的元素插入到确定的位置中
	    data[k+1] = temp;
    }
}

void sortBrain::quick_sort() {
    //为了可以递归，所以在公有函数里调用似有成员里的函数，这种写法在研究生教材中很常见，其实挺有道理的
    quick_sort(0, size-1);
}

void sortBrain::quick_sort(int begin, int end) {
    //递归结束条件
    if ( begin >= end )
        return;
    //选取主元，可任意取
    int pivot = end;
    //划分点初始位置
    int middle = begin;
    //扫描数组
    for ( int i = begin; i < end; i++ ) {
        if ( data[i] < data[pivot] ) { //如果比主元小
            int temp = data[i]; //就把它放到划分点前面
            data[i] = data[middle];
            data[middle] = temp;
            middle++; //划分点右移
        }
    }
    //将主元插入到中间
    int temp = data[pivot];
    data[pivot] = data[middle];
    data[middle] = temp;
    
    //递归重复这个过程排列主元前和主元后的数列
    quick_sort(begin, middle-1);
    quick_sort( middle + 1, end );
}

void sortBrain::merge_sort() {
    return merge_sort( 0, size - 1 );
}

void sortBrain::merge_sort( int begin, int end ) {
    if ( begin >= end ) return;
    int middle = ( begin + end ) / 2;
    merge_sort( begin, middle );
    merge_sort( middle + 1, end );
    merge( begin, middle, end );
}

void sortBrain::merge( int begin, int middle, int end ) {
    int new_array[ end - begin + 1 ];
    int i = begin; //左边的数组的头
    int j = middle + 1;//右边的数组的头
    int current = 0;//新数组的头
    //当左边没有到尾，而且右边也没到尾
    while ( i <= middle && j <= end ) {
        if ( data[i] > data[j] ) {
            new_array[ current ] = data[j];
            current++;
            j++;
        } else {
            new_array[ current ] = data[i];
            current++;
            i++;
        }
    }
    //如果是左边没有到尾，就继续复制左边的，如果已经到尾，直接跳过了循环
    while ( i <= middle ) {
        new_array[ current ] = data[i];
        current++;
        i++;
    }
    //同理
    while ( j <= end ) {
        new_array[ current ] = data[j];
        current++;
        j++;
    }
    //note:将合并的数组拷贝到原来相应的位置
    for ( int k = begin ; k <= end; k++ ) {
        data[k] = new_array[k-begin];
    }
}


int main() {
    int data[11] = { 1,3,5,7,9,2,4,6,8,10 };
    sortBrain mySortBrain( data, 10 );
    //mySortBrain.seletion_sort();
    //mySortBrain.bubble_sort();
    //mySortBrain.inserting_sort();
    //mySortBrain.quick_sort();
    mySortBrain.merge_sort();
    mySortBrain.print_data();
    return 0;
}
{% endhighlight %}

##查找/搜索

###二分查找
{% highlight C++ %}
//
//  BinaySearch.cpp
//  sicily
//
//  Created by Jeason on 3/11/14.
//  Copyright (c) 2014 Jeason. All rights reserved.
//

#include <stdio.h>

typedef enum BinarySearchType {
    SearchEndAtFound, SearchEndAtNone
} BinarySearchType;

bool BinarySearch( int *orderList, size_t listLength, BinarySearchType type, int target ){
    size_t bottom = 0, top = listLength - 1;
    
    switch ( type ) {
        case SearchEndAtFound:
            while ( bottom <= top ) {
                size_t middle = ( bottom + top ) / 2;
                if ( orderList[middle] == target ) {
                    return true;
                } else if ( orderList[middle] > target ) {
                    top = middle - 1;
                } else {
                    bottom = middle + 1;
                }
            }
            break;
            //在循环中，一旦找到立马return
        case SearchEndAtNone:
            while ( bottom < top ) {
                size_t middle = ( bottom + top ) / 2;
                if ( orderList[middle] >= target ) {
                    top = middle;
                } else {
                    bottom = middle + 1;
                }
            }
            //直到循环结束才去判断是否找到，才return
            if ( top < bottom ) {
                return false;
            } else if ( target == orderList[bottom] ) {
                return true;
            } else {
                return false;
            }
            break;
    }
    return false;
}

int main() {
    int orderList[] = {1, 2, 3, 4, 5, 6};
    int target = 10;
    int listLength = sizeof(orderList) / sizeof(orderList[0]);
    
    if ( BinarySearch(orderList, listLength, SearchEndAtNone, target) ) {
        printf( "%d target found\n", target );
    } else {
        printf( "%d target not found\n", target );
    }
    
    return 0;
}
{% endhighlight %}

##基于图论的算法

###最短路径

####Dijkstra算法

{% highlight C++ %}
#include <iostream>
using namespace std;
 
const int maxnum = 100;
const int maxint = 999999;
 
// 各数组都从下标1开始
int dist[maxnum];     // 表示当前点到源点的最短路径长度
int prev[maxnum];     // 记录当前点的前一个结点
int c[maxnum][maxnum];   // 记录图的两点间路径长度
int n, line;             // 图的结点数和路径数
 
// n -- n nodes
// v -- the source node
// dist[] -- the distance from the ith node to the source node
// prev[] -- the previous node of the ith node
// c[][] -- every two nodes' distance
void Dijkstra(int n, int v, int *dist, int *prev, int c[maxnum][maxnum])
{
    bool s[maxnum];    // 判断是否已存入该点到S集合中
    for(int i=1; i<=n; ++i)
    {
        dist[i] = c[v][i];
        s[i] = 0;     // 初始都未用过该点
        if(dist[i] == maxint)
            prev[i] = 0;
        else
            prev[i] = v;
    }
    dist[v] = 0;
    s[v] = 1;
 
    // 依次将未放入S集合的结点中，取dist[]最小值的结点，放入结合S中
    // 一旦S包含了所有V中顶点，dist就记录了从源点到所有其他顶点之间的最短路径长度
         // 注意是从第二个节点开始，第一个为源点
    for(int i=2; i<=n; ++i)
    {
        int tmp = maxint;
        int u = v;
        // 找出当前未使用的点j的dist[j]最小值
        for(int j=1; j<=n; ++j)
            if((!s[j]) && dist[j]<tmp)
            {
                u = j;              // u保存当前邻接点中距离最小的点的号码
                tmp = dist[j];
            }
        s[u] = 1;    // 表示u点已存入S集合中
 
        // 更新dist
        for(int j=1; j<=n; ++j)
            if((!s[j]) && c[u][j]<maxint)
            {
                int newdist = dist[u] + c[u][j];
                if(newdist < dist[j])
                {
                    dist[j] = newdist;
                    prev[j] = u;
                }
            }
    }
}
 
// 查找从源点v到终点u的路径，并输出
void searchPath(int *prev,int v, int u)
{
    int que[maxnum];
    int tot = 1;
    que[tot] = u;
    tot++;
    int tmp = prev[u];
    while(tmp != v)
    {
        que[tot] = tmp;
        tot++;
        tmp = prev[tmp];
    }
    que[tot] = v;
    for(int i=tot; i>=1; --i)
        if(i != 1)
            cout << que[i] << " -> ";
        else
            cout << que[i] << endl;
}

int main()
{
    freopen("input.txt", "r", stdin);
    // 各数组都从下标1开始
 
    // 输入结点数
    cin >> n;
    // 输入路径数
    cin >> line;
    int p, q, len;          // 输入p, q两点及其路径长度
 
    // 初始化c[][]为maxint
    for(int i=1; i<=n; ++i)
        for(int j=1; j<=n; ++j)
            c[i][j] = maxint;
 
    for(int i=1; i<=line; ++i)  
    {
        cin >> p >> q >> len;
        if(len < c[p][q])       // 有重边
        {
            c[p][q] = len;      // p指向q
            c[q][p] = len;      // q指向p，这样表示无向图
        }
    }
 
    for(int i=1; i<=n; ++i)
        dist[i] = maxint;
    for(int i=1; i<=n; ++i)
    {
        for(int j=1; j<=n; ++j)
            printf("%8d", c[i][j]);
        printf("\n");
    }
 
    Dijkstra(n, 1, dist, prev, c);
 
    // 最短路径长度
    cout << "源点到最后一个顶点的最短路径长度: " << dist[n] << endl;
 
    // 路径
    cout << "源点到最后一个顶点的路径为: ";
    searchPath(prev, 1, n);
}

{% endhighlight %}


###最小生成树

####Prim算法

{% highlight C++ %}
//prim算法

int prim(int n){

         int i,j,min,pos;
         int sum=0;
         memset(isvisited,false,sizeof(isvisited));
         //初始化
         for(i=1;i<=n;i++){
                   dist[i]=map[1][i];
         }

         //从1开始
         isvisited[1]=true;
         dist[1]=MAX;

         //找到权值最小点并记录下位置
         for(i=1;i<n;i++){
                   min=MAX;
                   //pos=-1;
                   for(j=1;j<=n;j++){
                            if(!isvisited[j] && dist[j]<min){
                                     min=dist[j];
                                     pos=j;
                            }
                   }        

                   sum+=dist[pos];//加上权值
                   isvisited[pos]=true;

                   //更新权值
                   for(j=1;j<=n;j++){
                            if(!isvisited[j] && dist[j]>map[pos][j]){
                                     dist[j]=map[pos][j];
                            }
                   }

         }        
         return sum;
}
{% endhighlight %}