//
//  NAV_FiveViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/30.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "NAV_FiveViewController.h"
#import "NAV_SixViewController.h"
@interface NAV_FiveViewController ()

@end

@implementation NAV_FiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tfy_navBackgroundColor = UIColor.orangeColor;
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 220 + 64, 150, 30)];
    [button4 setTitle:@"导航栏透明度" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button4 setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:button4];
    [button4 addTarget:self action:@selector(goAlphaNav:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)goAlphaNav:(UIButton *)btn {
    [self.navigationController pushViewController:NAV_SixViewController.new animated:YES];
}

@end
