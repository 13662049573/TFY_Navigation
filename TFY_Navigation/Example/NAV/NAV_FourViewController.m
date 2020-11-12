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


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"自定义导航";

    self.navigationController.tfy_titleColor = [UIColor whiteColor];
    self.navigationController.tfy_barBackgroundColor = [UIColor redColor];
    self.navigationController.tfy_navShadowColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = self.moreItem;
    
    TFY_StackView *stackview = TFY_StackView.new;
    stackview.backgroundColor = [UIColor whiteColor];
    stackview.tfy_Column = 1;
    stackview.tfy_Orientation = Vertical;//自动横向垂直混合布局
    stackview.tfy_VSpace = 1;
    [self.view addSubview:stackview];
    stackview
    .tfy_LeftSpace(0)
    .tfy_TopSpace(0)
    .tfy_RightSpace(0)
    .tfy_BottomSpace(TFY_kBottomBarHeight()+TFY_kNavTimebarHeight());
    
    NSArray *titleLabelArr = @[@"侧滑返回手势",@"全屏返回手势",@"导航栏背景颜色",@"导航栏分割线",@"左滑PUSH功能",@"多个导航栏按钮",@"全屏返回手势距离",@"导航栏透明度"];
    [titleLabelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *backview = UIViewSet();
        backview.makeChain.makeTag(idx).backgroundColor(UIColor.whiteColor).addToSuperView(stackview);
        
        UILabel *label = UILabelSet();
        label.makeChain.textColor(UIColor.blackColor)
        .text(obj).makeTag(idx)
        .font([UIFont systemFontOfSize:15 weight:UIFontWeightBold])
        .addToSuperView(backview);
        label.tfy_LeftSpace(20).tfy_CenterY(0).tfy_RightSpace(100).tfy_Height(40);
        
        if (idx != 6 && idx != 7) {
            UISwitch *swiths = UISwitchSet();
            swiths.makeChain
            .onTintColor(UIColor.redColor)
            .thumbTintColor(UIColor.greenColor)
            .makeTag(idx)
            .addTarget(self, @selector(onswichs:), UIControlEventValueChanged)
            .addToSuperView(backview);
            if (idx==4 || idx == 5) {
                swiths.makeChain.on(NO);
            } else {
                swiths.makeChain.on(YES);
            }
            swiths.tfy_RightSpace(0).tfy_CenterY(0).tfy_size(60, 40);
        }
        
        if (idx==6 || idx == 7) {
            UISlider *slider = UISliderSet();
            slider.makeChain
            .makeTag(idx)
            .minimumValue(0).minimumTrackTintColor(UIColor.yellowColor).maximumTrackTintColor(UIColor.blueColor)
            .addToSuperView(backview)
            .addTarget(self, @selector(DistanceAction:), UIControlEventValueChanged);
            slider.tfy_LeftSpace(20).tfy_BottomSpace(0).tfy_RightSpace(20).tfy_Height(20);
            if (self.tfy_popMaxAllowedDistanceToLeftEdge == 0) {
                if (idx == 6) {
                    slider.makeChain.maximumValue(self.view.frame.size.width);
                    slider.value = self.view.frame.size.width;
                }
            }
            if (idx == 7) {
                slider.makeChain.maximumValue(1);
                slider.value = self.navigationController.tfy_navBarAlpha;
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
                self.navigationController.tfy_barBackgroundColor = [UIColor redColor];
            }else {
                self.navigationController.tfy_barBackgroundColor = [UIColor blueColor];
            }
            break;
        case 3:
            self.navigationController.tfy_navLineHidden = !ons.on;
            break;
        case 4:
            if (ons.on) {
                self.tfy_pushDelegate = self;
            }else {
                self.tfy_pushDelegate = nil;
            }
            break;
        case 5:
            if (ons.on) {
                self.navigationItem.rightBarButtonItems = @[self.shareItem, self.moreItem];
            }else {
                self.navigationItem.rightBarButtonItems = @[];
                self.navigationItem.rightBarButtonItem = self.moreItem;
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
    if (sender.tag == 6) {
        self.tfy_popMaxAllowedDistanceToLeftEdge = sender.value;
        label.text = [NSString stringWithFormat:@"全屏返回手势距离：%f", self.tfy_popMaxAllowedDistanceToLeftEdge];
    }
    if (sender.tag == 7) {
        self.navigationController.tfy_navBarAlpha = sender.value;
        label.text = [NSString stringWithFormat:@"导航栏透明度：%f", self.navigationController.tfy_navBarAlpha];
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
