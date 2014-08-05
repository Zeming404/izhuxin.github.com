//
//  NoteAppDelegate.m
//  Note
//
//  Created by Jeason on 14-4-12.
//  Copyright (c) 2014年 Jeason. All rights reserved.
//

#import "NoteAppDelegate.h"
#import "NoteListViewController.h"
#import "Note.h"
@implementation NoteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#pragma mark -notes
    // TODO: read notes from database
    self.notes = [NSMutableArray arrayWithArray: @[
                                                   [Note noteWithText:@"Lecture1 -Objective-C\r\r1. 概述\r\r2. 类的编写\r  2.1. 类的声明\r  2.2. 类的实现\r\r3. FoundationOverView\r\r4. 总结" NoteID:0],
                                                   [Note noteWithText:@"Lecture2 -UI programming\r\r这是SYSU Apple Club系列培训的第二篇。上一篇我们学习了Objective－C的基本语法，而且知道了Foundation库内的一些重要的数据结构。这篇教程主要是厘清一些基本概念，让你对iOS UI编程的内在机制有一定的了解。本文主要参考自我的理解和 Apple的《UIKitCatalog》，如果有什么不对的地方，也希望大家能指出来。" NoteID:1],
                                                  ]];


#pragma mark -navigation
    NoteListViewController *viewController = [[NoteListViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UIColor* navColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
