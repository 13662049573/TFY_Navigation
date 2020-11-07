//
//  NAV_FourViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/30.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "NAV_FourViewController.h"
#import "NAV_FiveViewController.h"

@interface NAV_FourViewController ()<TFYViewControllerPushDelegate>
@property (nonatomic, strong) UIBarButtonItem *moreItem;
@property (nonatomic, strong) UIBarButtonItem *shareItem;
@end

@implementation NAV_FourViewController

- (instancetype)init {
    if (self = [super init]) {
        self.tfy_statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tfy_navTitle = @"自定义导航";

    self.tfy_navTitleColor = [UIColor whiteColor];
    self.tfy_navBackgroundColor = [UIColor redColor];
    self.tfy_navShadowColor = [UIColor blackColor];
    self.tfy_backStyle = TFYNavigationBarBackStyleWhite;
    self.tfy_navRightBarButtonItem = self.moreItem;
    
    if (self.tfy_popMaxAllowedDistanceToLeftEdge == 0) {
       
    }
    
    NSArray *titleLabelArr = @[@"侧滑返回手势",@"全屏返回手势",@"状态栏样式",@"状态栏显隐",@"导航栏背景颜色",@"导航栏分割线",@"返回按钮样式",@"左滑PUSH功能",@"多个导航栏按钮"];
    for (NSInteger i=0; i<=titleLabelArr.count; i++) {
        UILabel *label = 
    }
    
}


#pragma mark - 懒加载
- (UIBarButtonItem *)moreItem {
    if (!_moreItem) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor blackColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushToNextViewController) forControlEvents:UIControlEventTouchUpInside];
        _moreItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _moreItem;
}

- (UIBarButtonItem *)shareItem {
    if (!_shareItem) {
        UIButton *btn = [UIButton new];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _shareItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    return _shareItem;
}

#pragma mark - GKViewControllerPushDelegate
- (void)pushToNextViewController {
    NAV_FiveViewController *vc = NAV_FiveViewController.new;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
