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
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItembtn(CGSizeMake(100, 64), @"变化", [UIColor redColor], [UIFont boldSystemFontOfSize:14], @"me_data_icom", NAV_ButtonImageDirectionLeft, 2, self, @selector(imageClick), UIControlEventTouchUpInside);
    
    [self.view addSubview:self.bianBtn];
    self.bianBtn.tfy_LeftSpace(30).tfy_CenterY(0).tfy_RightSpace(30).tfy_Height(50);
}

- (void)imageClick {
    NSInteger index = arc4random_uniform(4);
    NAV_ButtonImageDirection type = NAV_ButtonImageDirectionLeft;
    switch (index) {
        case 0:
            type = NAV_ButtonImageDirectionTop;
            break;
        case 1:
            type = NAV_ButtonImageDirectionRight;
            break;
        case 2:
            type = NAV_ButtonImageDirectionLeft;
            break;
       case 3:
            type = NAV_ButtonImageDirectionBottom;
            break;
    }
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItembtn(CGSizeMake(100, 64), @"变化", [UIColor redColor], [UIFont boldSystemFontOfSize:14], @"me_data_icom", type, 2, self, @selector(imageClick), UIControlEventTouchUpInside);
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
