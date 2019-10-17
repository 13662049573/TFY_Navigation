//
//  ViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_Navigation/TFY_Navigation.h"
#import "RootController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏测试";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.navigationItem.leftBarButtonItem = tfy_barbtnItem().tfy_imageItem(@"me_data_icom",self,@selector(imageClick));
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItem(@"添加",20,[UIColor redColor],self,@selector(imageClick));
    
//    self.navigationController.tfy_barBackgroundColor = [UIColor purpleColor];
    
}

-(void)imageClick{
    [self.navigationController pushViewController:[RootController new] animated:YES];
}
@end
