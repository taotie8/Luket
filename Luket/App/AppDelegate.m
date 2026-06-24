//
//  AppDelegate.m
//  Luket
//
//  Created by 上包666 on 2026/6/3.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
// curgelis@gmail.com
// 123456
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

/**
 
 //1.他人主页顶部背景不对！目前的和主要信息糊在一起了，可能被4.0打回来
 //2.他人主页+我的主页 post 列表无法点击进行详情
 //3.拉黑文案改成block
 // 4.注册之后缺少填写个人资料（年龄）页
 // 5.发布那里 （pic （0/4） 删掉。因为可以发布图片或者视频。如果只写pic就容易让审核觉得只能是发布图片
// 6.图标（桌面图标、启动页、登陆页）
 //7.缺省图重新切一下（有个黑描边）
 
 */

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
