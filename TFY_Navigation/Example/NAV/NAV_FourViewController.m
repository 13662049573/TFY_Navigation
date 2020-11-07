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
    
    TFY_StackView *stackview = TFY_StackView.new;
    stackview.backgroundColor = [UIColor whiteColor];
    stackview.tfy_Column = 2;
    stackview.tfy_Orientation = All;//自动横向垂直混合布局
    stackview.tfy_VSpace = 1;
    stackview.tfy_HSpace = 1;
    [self.view addSubview:stackview];
    stackview
    .tfy_LeftSpace(0)
    .tfy_TopSpace(TFY_kNavBarHeight())
    .tfy_RightSpace(0)
    .tfy_Height(TFY_Height_H()/2);
    
    NSArray *titleLabelArr = @[@"侧滑返回手势",@"全屏返回手势",@"状态栏样式",@"状态栏显隐",@"导航栏背景颜色",@"导航栏分割线",@"返回按钮样式",@"左滑PUSH功能",@"多个导航栏按钮"];
    [titleLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *backview = UIViewSet();
        backview.makeChain.backgroundColor(UIColor.whiteColor).addToSuperView(stackview);
        
        UILabel *label = UILabelSet();
        label.makeChain.textColor(UIColor.blackColor)
        .text(obj).makeTag(idx)
        .font([UIFont systemFontOfSize:15 weight:UIFontWeightBold])
        .addToSuperView(backview);
        label.tfy_LeftSpace(20).tfy_CenterY(0).tfy_size(TFY_Width_W()/3, 40);
        
        UISwitch *swiths = UISwitchSet();
        swiths.makeChain
        .onTintColor(UIColor.redColor)
        .thumbTintColor(UIColor.greenColor)
        .makeTag(idx)
        .addTarget(self, @selector(onswichs:), UIControlEventValueChanged)
        .addToSuperView(backview);
        swiths.tfy_RightSpace(0).tfy_CenterY(0).tfy_size(60, 40);
    }];
    
    [stackview tfy_StartLayout];
}

- (void)onswichs:(UISwitch *)ons {
    switch (ons.tag) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        default:
            break;
    }
    NSLog(@"------------%ld",(long)ons.tag);
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
