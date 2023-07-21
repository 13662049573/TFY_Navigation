//
//  NAV_SevenViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/30.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "NAV_SevenViewController.h"

@interface NAV_SevenViewController ()<TFYNavigationControllerDelegate>

@end

@implementation NAV_SevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    
    TFY_NavigationController *nav = (TFY_NavigationController *)self.navigationController;
    nav.uiNaviDelegate = self;
}

/// 点击返回按钮调用
- (void)navigationControllerDidClickLeftButton:(TFY_NavigationController *)controller {
    if (controller.currentShowVC == self) {
        NSLog(@"ssssssssssssss");
    }
}
/// 侧滑划出控制器调用
- (void)navigationControllerDidSideSlideReturn:(TFY_NavigationController *)controller
                            fromViewController:(TFYContainerController *)fromViewController {
    if ([fromViewController.contentViewController isEqual:self]) {
        NSLog(@"ooooooooooooooooooooooo");
    }
}
@end
