//
//  TFY_NavigationController.m
//  TFY_NavigationController
//
//  Created by 田风有 on 2021/8/8.
//  Copyright © 2021 浙江日报集团. All rights reserved.
//

#import "TFY_NavigationController.h"
#import <objc/runtime.h>

@interface TFY_NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation TFY_NavigationController

- (void)dealloc {
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 重新响应侧滑返回手势
    self.interactivePopGestureRecognizer.delegate = self;
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
#pragma mark - 侧滑手势 - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    return YES;
}
// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
// 禁止响应手势 是否和ViewController中scrollView跟着滚动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer: (UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIImage *image = [[UIImage imageNamed:@"TFY_NavigationImage.bundle/btn_back_black"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:self
                                                                                          action:@selector(onBack:)];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)onBack:(id)back {
    [self popViewControllerAnimated:YES];
}

@end
