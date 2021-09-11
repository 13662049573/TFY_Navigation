//
//  NAV_FourViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/30.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "NAV_FourViewController.h"
#import "NAV_FiveViewController.h"

@interface NAV_FourViewController ()
@property (nonatomic, strong) UIBarButtonItem *moreItem;
@property (nonatomic, strong) UIBarButtonItem *shareItem;
@end

@implementation NAV_FourViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"自定义导航";
    
    self.view.backgroundColor = UIColor.orangeColor;
    
    
}

@end
