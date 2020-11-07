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
    
    TFY_StackView *stackview = TFY_StackView.new;
    stackview.backgroundColor = [UIColor whiteColor];
    stackview.tfy_Column = 1;
    stackview.tfy_Orientation = Vertical;//自动横向垂直混合布局
    stackview.tfy_VSpace = 1;
    [self.view addSubview:stackview];
    stackview
    .tfy_LeftSpace(0)
    .tfy_TopSpace(TFY_kNavBarHeight())
    .tfy_RightSpace(0)
    .tfy_BottomSpace(TFY_kBottomBarHeight()+TFY_kNavTimebarHeight());
    
    NSArray *titleLabelArr = @[@"侧滑返回手势",@"全屏返回手势",@"状态栏样式",@"状态栏显隐",@"导航栏背景颜色",@"导航栏分割线",@"返回按钮样式",@"左滑PUSH功能",@"多个导航栏按钮",@"全屏返回手势距离",@"导航栏透明度"];
    [titleLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *backview = UIViewSet();
        backview.makeChain.makeTag(idx).backgroundColor(UIColor.whiteColor).addToSuperView(stackview);
        
        UILabel *label = UILabelSet();
        label.makeChain.textColor(UIColor.blackColor)
        .text(obj).makeTag(idx)
        .font([UIFont systemFontOfSize:15 weight:UIFontWeightBold])
        .addToSuperView(backview);
        label.tfy_LeftSpace(20).tfy_CenterY(0).tfy_RightSpace(100).tfy_Height(40);
        
        if (idx != 9 && idx != 10) {
            UISwitch *swiths = UISwitchSet();
            swiths.makeChain
            .onTintColor(UIColor.redColor)
            .thumbTintColor(UIColor.greenColor)
            .makeTag(idx)
            .addTarget(self, @selector(onswichs:), UIControlEventValueChanged)
            .addToSuperView(backview);
            if (idx==7 || idx == 8) {
                swiths.makeChain.on(NO);
            } else {
                swiths.makeChain.on(YES);
            }
            swiths.tfy_RightSpace(0).tfy_CenterY(0).tfy_size(60, 40);
        }
        
        if (idx==9 || idx == 10) {
            UISlider *slider = UISliderSet();
            slider.makeChain
            .makeTag(idx)
            .minimumValue(0).minimumTrackTintColor(UIColor.yellowColor).maximumTrackTintColor(UIColor.blueColor)
            .addToSuperView(backview)
            .addTarget(self, @selector(DistanceAction:), UIControlEventValueChanged);
            slider.tfy_LeftSpace(20).tfy_BottomSpace(0).tfy_RightSpace(20).tfy_Height(20);
            if (self.tfy_popMaxAllowedDistanceToLeftEdge == 0) {
                if (idx == 9) {
                    slider.makeChain.maximumValue(self.view.frame.size.width);
                    slider.value = self.view.frame.size.width;
                }
            }
            if (idx == 10) {
                slider.makeChain.maximumValue(1);
                slider.value = self.tfy_navBaseBarAlpha;
            }
        }
    }];
    
    [stackview tfy_StartLayout];
}

- (void)onswichs:(UISwitch *)ons {
    switch (ons.tag) {
        case 0:
            self.tfy_interactivePopDisabled = !ons.on;
            break;
        case 1:
            self.tfy_fullScreenPopDisabled = !ons.on;
            break;
        case 2:
            if (ons.on) {
                self.tfy_statusBarStyle = UIStatusBarStyleLightContent;
            }else {
                self.tfy_statusBarStyle = UIStatusBarStyleDefault;
            }
            break;
        case 3:
            self.tfy_statusBarHidden = !ons.on;
            break;
        case 4:
            if (ons.on) {
                self.tfy_navBackgroundColor = [UIColor redColor];
            }else {
                self.tfy_navBackgroundColor = [UIColor blueColor];
            }
            break;
        case 5:
            self.tfy_navLineHidden = !ons.on;
            break;
        case 6:
            if (ons.on) {
                self.tfy_backStyle = TFYNavigationBarBackStyleWhite;
            }else {
                self.tfy_backStyle = TFYNavigationBarBackStyleBlack;
            }
            break;
        case 7:
            if (ons.on) {
                self.tfy_pushDelegate = self;
            }else {
                self.tfy_pushDelegate = nil;
            }
            break;
        case 8:
            if (ons.on) {
                self.tfy_navRightBarButtonItems = @[self.shareItem, self.moreItem];
            }else {
                self.tfy_navRightBarButtonItems = @[];
                self.tfy_navRightBarButtonItem = self.moreItem;
            }
            break;
        default:
            break;
    }
}

- (void)DistanceAction:(UISlider *)sender {
    UILabel *label;
    NSArray *subViews = self.view.subviews;
    for (UIView *views in subViews) {
        if ([views isKindOfClass:TFY_StackView.class]) {
            UIView *backview = [views viewWithTag:sender.tag];
            for (UILabel *labels in backview.subviews) {
                if ([labels isKindOfClass:UILabel.class]) {
                    label = [labels viewWithTag:sender.tag];
                }
            }
        }
    }
    if (sender.tag == 9) {
        self.tfy_popMaxAllowedDistanceToLeftEdge = sender.value;
        label.text = [NSString stringWithFormat:@"全屏返回手势距离：%f", self.tfy_popMaxAllowedDistanceToLeftEdge];
    }
    if (sender.tag == 10) {
        self.tfy_navBaseBarAlpha = sender.value;
        label.text = [NSString stringWithFormat:@"导航栏透明度：%f", self.tfy_navBaseBarAlpha];
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
