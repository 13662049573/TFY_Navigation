//
//  ViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本设置";
    
    [self tfy_setStatusBarStyle:UIStatusBarStyleDefault];
    [self tfy_setNavBarTitleColor:[UIColor redColor]];
    [self tfy_setNavBarBackgroundColor:[UIColor whiteColor]];
}
@end
