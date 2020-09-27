//
//  NAV_OneController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/8/23.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "NAV_OneController.h"
#import "NAV_TwoController.h"

#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

@interface NAV_OneController ()
@property(nonatomic , strong)UIButton *bianBtn;
@end

@implementation NAV_OneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.tfy_barBackgroundColor = UIColor.blueColor;
    self.navigationController.tfy_titleColor = UIColor.whiteColor;
    self.navigationController.tfy_titleFont = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    self.navigationController.tfy_defaultFixSpace = 10;//更改导航栏离两边的距离，更改后全局都会发生改变。
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItem(@"下一步",20,[UIColor redColor],self,@selector(timeimageClick));
    
    [self.view addSubview:self.bianBtn];
    self.bianBtn.tfy_LeftSpace(30).tfy_CenterY(0).tfy_RightSpace(30).tfy_Height(50);
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

- (void)navbiack {
    self.navigationController.tfy_barBackgroundColor = [self RandomColor];
}

- (UIColor*)RandomColor {
   NSInteger aRedValue =arc4random() %255;
   NSInteger aGreenValue =arc4random() %255;
   NSInteger aBlueValue =arc4random() %255;
   UIColor*randColor = [UIColor colorWithRed:aRedValue /255.0f green:aGreenValue /255.0f blue:aBlueValue /255.0f alpha:1.0f];
    return randColor;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController tfy_hidesBarsOnTap];
}

@end
