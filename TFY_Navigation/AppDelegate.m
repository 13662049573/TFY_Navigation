//
//  AppDelegate.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "AppDelegate.h"
#import "TFY_Navigation/TFY_Navigation.h"
#import "TFY_TabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor  whiteColor];

    TFYRotateDefault.shared.defaultSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    
    self.window.rootViewController = TFY_TabBarController.new;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
