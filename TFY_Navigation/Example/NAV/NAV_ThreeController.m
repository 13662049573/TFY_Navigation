//
//  NAV_ThreeController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/8/23.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "NAV_ThreeController.h"

@interface NAV_ThreeController ()
@property(nonatomic , strong)UIButton *bianBtn;
@end

@implementation NAV_ThreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"返回按钮自定义";
    self.view.backgroundColor = UIColor.blueColor;

    [self.view addSubview:self.bianBtn];
    self.bianBtn.tfy_LeftSpace(30).tfy_CenterY(0).tfy_RightSpace(30).tfy_Height(50);
}

- (UIButton *)bianBtn {
    if (!_bianBtn) {
        _bianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bianBtn setTitle:@"回到指定控制器" forState:UIControlStateNormal];
        [_bianBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _bianBtn.backgroundColor = UIColor.orangeColor;
        [_bianBtn addTarget:self action:@selector(timeimageClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianBtn;
}

- (void)timeimageClick {
    
    NSArray *conterlerArr = self.navigationController.viewControllers;
    
    UIViewController *viewController = conterlerArr[0];
    
    [self.navigationController popToViewController:viewController animated:YES];
}
@end
