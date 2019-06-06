//
//  RootController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "RootController.h"
#import "TFY_Navigation/TFY_Navigation.h"
@interface RootController ()

@end

@implementation RootController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试隐藏返回按钮";
    self.navigationController.tfy_titleFont = [UIFont systemFontOfSize:25];
    self.navigationController.tfy_titleColor = [UIColor cyanColor];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    self.navigationItem.leftBarButtonItem = tfy_barbtnItem();
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_imageItem(@"me_opinion",self,@selector(imageClick));
}


-(void)imageClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
