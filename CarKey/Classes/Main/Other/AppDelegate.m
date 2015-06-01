//
//  AppDelegate.m
//  CarKey
//
//  Created by jiangyuanlu on 15/5/26.
//  Copyright (c) 2015年 JYL. All rights reserved.
//

#import "AppDelegate.h"
#import <MAMapKit/MAMapKit.h>
#import "LoginViewController.h"
#import "APService.h"
#import "playSound.h"
//#import "OpenUDID.h"
#import "OpenUDID.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *uuid = [OpenUDID value];
    JYLLog(@"uuid = %@",uuid);
    //6a6f2a0f17555c8f730f4ede4c5e82cb61cf5269
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    [MAMapServices sharedServices].apiKey = @"3a25c84679af69447b9e4a39ed9f2a1b";
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    JYLLog(@"%@",deviceToken);
    //884bcf2f 3e52f528 811ce573 266299e3 4602d09f 7bdef36c 2582af37 dbc0c21a
    [APService registerDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    JYLLog(@"%@",userInfo);
    [APService handleRemoteNotification:userInfo];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    /***
     惦记通知栏，回到APP进入这个方法
     {
     "_j_msgid" = 780607290;
     aps =     {
     alert = "let's push something";
     badge = 1;
     sound = default;
     };
     }
     */
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
