//
//  AppDelegate.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "AppDelegate.h"
#import "TFY_Navigation/TFY_Navigation.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor  whiteColor];
    
    [TFY_Configure setupCustomConfigure:^(TFYNavigationBarConfigure * _Nonnull configure) {
        // 导航栏背景色
        configure.backgroundColor = [UIColor orangeColor];
        // 导航栏标题颜色
        configure.titleColor = [UIColor blackColor];
        // 导航栏标题字体
        configure.titleFont = [UIFont systemFontOfSize:15.0f];
        // 导航栏返回按钮样式
        configure.backStyle = TFYNavigationBarBackStyleWhite;
        // 导航栏左右item间距
        configure.tfy_navItemLeftSpace = 12.0f;
        configure.tfy_navItemRightSpace = 12.0f;
        
    }];
    
    TFY_NavigationController *nav = [[TFY_NavigationController alloc] initWithRootViewController:ViewController.new];
    nav.tfy_openScrollLeftPush = YES;
    nav.tfy_translationScale = YES;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
