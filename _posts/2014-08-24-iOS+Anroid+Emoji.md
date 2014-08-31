---
layout: post
title: "iOS和Android的Emoji表情同步方案"
description: ""
category: blog
tags: [IOS Developer]
image: 
  feature: emoji.jpg
comments: true
diary: 最近在做一个聊天的应用，有一个问题就是iOS跟Android的Emoji字符不对应导致显示不正常。因为iOS这部分是先做的，所以便让负责安卓的同学想办法兼容iOS的编码表...

mathjax: 
---

最近在做一个聊天的应用，有一个问题就是iOS跟Android的Emoji字符不对应导致显示不正常。因为iOS这部分是先做的，所以便让负责安卓的同学想办法兼容iOS的编码表，不过安卓的同学想尽办法也没办法搞到Apple Color Emoji的编码表，不过他却找到了有几百张Emoji表情的图片，后来经过整理剩下180张是完整的放在项目里的，图片下载在[这里](http://pan.baidu.com/s/1o6qMC22).于是，我就利用这些图片来想办法跟现有的项目兼容。

##之前的情况
iOS之前的Emoji部分，是用了[这个文件夹里的类](https://gist.github.com/izhuxin/bbb2a4895f150e0648f1)来产生所有的Emoji表情的unicode字符的，主要是做了一个映射和一定的排序和筛选，来使这些表情不会太杂乱。内部的实现可以说是看起来比较复杂但是思路很简单的，就不做详细赘述了.安卓的同学说安卓有一个可以图文混排的View，叫做[EditText](http://developer.android.com/reference/android/widget/EditText.html)的.

于是，安卓的同学就希望我将iOS这边也是改成图文混排的方式，发送表情的时候就只是发送图片的名字，然后我们再约定每个图片的名字以一个特殊的字符开始并以一个特殊的字符结束，不过想到现有的方案要推倒重来实在不妥，而且用图片很难保证在每个分辨率的手机上都能有很好的效果。似乎手Q就是用的这种方案，因为我在看安卓手机发来的emoji表情的时候有很明显的锯齿...

另外在服务器方面，之前iOS发送Emoji表情跟发送文字是一起的，即是以unicode的方式发送和存储的。

##我的方案
我想到安卓的同学之所以没办法搞到Apple Color Emoji的编码表，是因为这个字体只在苹果系上才有，所以不如我来搞定那个编码表吧，把Emoji的unicode编码和图片对应起来，然后在每次Model传数据给View的时候，将图片名解析成unicode编码，然后在保存至Model的时候将unicode编码转换成图片名就好了，这样子只需要设置字体的大小就能控制emoji表情的大小了，而且以前的代码几乎不用修改。

方法很简单，但就是花时间，所以才特地整理了这篇文章可以省大家的力气。我先是将所有的emoji Code和Emoji表情打印到[文件](https://gist.github.com/732bc2b5f7dca13fe630)里，然后跟图片文件进行比对，整理出了他们的[映射表](https://gist.github.com/b812ab0bf87093907e26).

然后就需要跟服务器和安卓的同学约定好Emoji开始的字符和结束的字符就好了，我们的定义如下:

{% highlight c %}

#define EmojiBegin                      0x02
#define EmojiEnd                        0x03

{% endhighlight %}

接下来就是解析工作了，还是很简单的，我是写了一个category来完成这些工作，代码如下:

NSString+Emoji.h

{% highlight objective-c %}

//
//  NSString+Emoji.h
//  EmojiAdapter
//
//  Created by Jeason on 14-8-11.
//  Copyright (c) 2014年 EmojiAdapter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)

/**
 *  Encode a string contains emoji string to a string contains emoji filename.
 *  Just encode each substring to filename, if it hs no associating filename, it will return nil.
 *  @return the encoded string
 */
- (NSString *)encodeString;

/**
 *  Decode the string contains file names to String contains emoji string.
 *
 *  @return the result string
 */
- (NSString *)decodeString;

/**
 *  Generate the encode dictionary to encode an emoji string to filename
 *
 *  @return the encode dictionary
 */
+ (NSDictionary *)encodeDictionary;

@end


{% endhighlight %}


NSString+Emoji.m

{% highlight objective-c %}
//
//  NSString+Emoji.m
//  EmojiAdapter
//
//  Created by Jeason on 14-8-11.
//  Copyright (c) 2014年 EmojiAdapter. All rights reserved.
//

#import "NSString+Emoji.h"
#import "Emoji.h"

#define EmojiBegin 0x02
#define EmojiEnd   0x03

@implementation NSString (Emoji)

-(NSString *)decodeString {
    __block BOOL isEmojiBegin = false;
    __block NSString *emojiFileName = @"";      //temp var to store the file name
    __block NSMutableString *result = [NSMutableString stringWithString:@""];
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences //setperate as composed character
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const char *utf8Str = [substring UTF8String];
                                char aChar = [substring characterAtIndex:0]; //a unicode substr's length is 2
                                if ( aChar == EmojiBegin && strlen(utf8Str) == 1 ) { //卧槽，句号的unicode编码刚好第一个字符就是0x02
                                    isEmojiBegin = YES;
                                } else if ( aChar == EmojiEnd && strlen(utf8Str) == 1 ) {   //if it is in end
                                    isEmojiBegin = NO;
                                    NSString *emoji = [emojiFileName decodeEmojiString];    //decode the filename
                                    if ( emoji != nil ) {   //if decode succ
                                        [result appendString:emoji];    //add to result
                                    }
                                    emojiFileName = @"";    //clear file name
                                } else {
                                    if ( isEmojiBegin ) {   //the next substring is part of filename
                                        emojiFileName = [emojiFileName stringByAppendingString:substring];
                                    } else {    //the next substring is the normal string
                                        [result appendString:substring];
                                    }
                                }
                            }];
    
    return [NSString stringWithString:result];
}

/**
 *  Decode a single file name to emoji string
 *
 *  @return the decode emoji string
 */
- (NSString *)decodeEmojiString {
    NSString *plistName;
    if ( [self length] >= 3 ) { //if the filename is valid
        if ( [self characterAtIndex:0] == 'f' ) {
            if ( [self characterAtIndex:1] == 'l' ) {
                //flower
                plistName = @"EmojiFlower";
            } else {
                //face
                plistName = @"EmojiFace";
            }
        } else if ( [self characterAtIndex:0] == 's' ) {
            if ( [self characterAtIndex:1] == 't' ) {
                //status
                plistName = @"EmojiStatus";
            } else {
                //symbol
                plistName = @"EmojiSymbol";
            }
        } else if ( [self characterAtIndex:0] == 'm' ) {
            //meal
            plistName = @"EmojiMeal";
        }
        NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        NSDictionary *decodeDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];//read the plist file
        NSInteger emojiCode = [[decodeDict objectForKey:self] intValue];
        return [Emoji emojiWithCode:emojiCode];
    } else {
        return @"";
    }
}

+ (NSDictionary *)encodeDictionary {
    NSArray *plistNames = @[@"ToEmojiFace", @"ToEmojiFlower", @"ToEmojiStatus", @"ToEmojiSymbol", @"ToEmojiMeal"];
    NSMutableDictionary *toEmojiDict = [NSMutableDictionary dictionary];
    for (NSString *pName in plistNames) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:pName ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        [toEmojiDict addEntriesFromDictionary:dict];
    }
    return toEmojiDict;
}

- (NSString *)encodeString {
    
    NSDictionary *toEmojiDict = [NSString encodeDictionary];
    
    __block NSMutableString *result = [NSMutableString stringWithString:@""];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              NSString *encodeStr = toEmojiDict[substring];
                              encodeStr = encodeStr == nil ? substring : [encodeStr encodeEmojiString];
                              [result appendString:encodeStr];
                          }];
    
    return [NSString stringWithString:result];
}

/**
 *  Encode emoji string with a prefix and a postfix
 *
 *  @return the encoded emoji string
 */
-(NSString *)encodeEmojiString {
    return [NSString stringWithFormat:@"%c%@%c",EmojiBegin, self, EmojiEnd];
}

@end

{% endhighlight %}

这样子，就可以在需要写数据库和发送网络的时候调用
<code>
someChatMsg = [someChatMsg encodeString];
</code>

然后在想要显示UI的部分调用
<code>
someChatMsg = [someChatMsg decodeString];
</code>

而且，在Emoji.m里为每个Emoji查找一次看有没有对应的文件名来筛选出可以在iOS跟安卓通用的Emoji表情啦！完整的项目Demo在[这里](https://github.com/izhuxin/EmojiAdapter)

##补充一句
为什么要筛选只有180个表情呢，因为发现不论是手Q还是微信还是自带的Emoji键盘，它都是每行有7个表情，一页有3行，最后一个是删除键，这样子180个表情就有180 ／ （7*3-1） ＝ 9页啦，所以180个已经是非常足够了的，太多页也会让用户失去耐心~