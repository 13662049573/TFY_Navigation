//
//  NAV_OneController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/8/23.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "NAV_OneController.h"
#import "NAV_TwoController.h"
#import "NAV_SevenViewController.h"
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface NAV_OneController ()
@property(nonatomic , strong)UIButton *bianBtn,*bianBtn2;
@end

@implementation NAV_OneController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tfy_setNavBarBackgroundColor:[UIColor colorWithRed:(rand() % 100 * 0.01) green:(rand() % 100 * 0.01) blue:0.86 alpha:1.00]];
    [self tfy_setNavigationSwitchStyle:NavigationSwitchStyleFakeNavBar];
    [self tfy_setStatusBarHidden:YES];
    [self tfy_setNavBarShadowImageHidden:YES];
    [self tfy_setNavBarBackgroundAlpha:1.0f];
    [self tfy_setNavBarHidden:NO];
    [self tfy_setNavBarTintColor:[UIColor blackColor]];
    [self tfy_setNavBarTitleColor:[UIColor blackColor]];
   
    [self tfy_setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.view.backgroundColor = [self RandomColor];

    
    [self.view addSubview:self.bianBtn];
    self.bianBtn.tfy_LeftSpace(30).tfy_CenterY(-50).tfy_RightSpace(30).tfy_Height(50);
    
    [self.view addSubview:self.bianBtn2];
    self.bianBtn2.tfy_LeftSpace(30).tfy_CenterY(50).tfy_RightSpace(30).tfy_Height(50);
}

- (void)pushToNextViewController {
    [self timeimageClick];
}

- (void)timeimageClick {
    [self.navigationController pushViewController:[NAV_TwoController new] animated:YES];
}

- (UIButton *)bianBtn {
    if (!_bianBtn) {
        _bianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianBtn setTitle:@"变色导航栏颜色" forState:UIControlStateNormal];
        [_bianBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bianBtn.backgroundColor = [self RandomColor];
        [_bianBtn addTarget:self action:@selector(navbiack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianBtn;
}

- (UIButton *)bianBtn2 {
    if (!_bianBtn2) {
        _bianBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianBtn2 setTitle:@"下一个界面" forState:UIControlStateNormal];
        [_bianBtn2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bianBtn2.backgroundColor = [self RandomColor];
        [_bianBtn2 addTarget:self action:@selector(navbiack2) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianBtn2;
}
- (void)navbiack {
    [self tfy_setNavBarBackgroundColor:[self RandomColor]];
    [self tfy_setNavBarShadowImageHidden:YES];
    self.view.backgroundColor = [self RandomColor];
}

- (void)navbiack2 {
    [self.navigationController pushViewController:NAV_SevenViewController.new animated:YES];
}

- (UIColor*)RandomColor {
   NSInteger aRedValue =arc4random() %255;
   NSInteger aGreenValue =arc4random() %255;
   NSInteger aBlueValue =arc4random() %255;
   UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}



@end
