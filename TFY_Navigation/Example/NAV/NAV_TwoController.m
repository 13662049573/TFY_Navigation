//
//  NAV_TwoController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/8/23.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "NAV_TwoController.h"
#import "NAV_ThreeController.h"
@interface NAV_TwoController ()
@property(nonatomic , strong)UIButton *bianBtn;
@end

@implementation NAV_TwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [self RandomColor];
    self.title = @"导航栏透明色";

    [self.view addSubview:self.bianBtn];
    self.bianBtn.tfy_LeftSpace(30).tfy_CenterY(0).tfy_RightSpace(30).tfy_Height(50);
}

- (void)timeimageClick {
    [self.navigationController pushViewController:[NAV_ThreeController new] animated:YES];
}

- (UIButton *)bianBtn {
    if (!_bianBtn) {
        _bianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianBtn setTitle:@"变色导航栏字体颜色" forState:UIControlStateNormal];
        [_bianBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bianBtn.backgroundColor = [self RandomColor];
        [_bianBtn addTarget:self action:@selector(navbiack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianBtn;
}

- (void)navbiack {
    
}

- (UIColor*)RandomColor {
   NSInteger aRedValue =arc4random() %255;
   NSInteger aGreenValue =arc4random() %255;
   NSInteger aBlueValue =arc4random() %255;
   UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}
@end
