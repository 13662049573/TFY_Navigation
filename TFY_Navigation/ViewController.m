//
//  ViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "OtherAppExampleListVC.h"
#import "BasicFunctionListVC.h"
#import "SpecialUseExampleVC.h"
#import "TFY_PageViewController.h"



@interface ViewController ()<TFY_PageViewControllerDelegate,TFY_PageViewControllerDataSrouce>
@property (nonatomic, strong) TFY_PageViewController *pageViewController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    //配置
    TFY_PageControllerConfig *config = [TFY_PageControllerConfig defaultConfig];
    config.showTitleInNavigationBar = true;
    config.titleViewStyle = TFY_PageTitleViewStyleSegmented;
    config.separatorLineHidden = true;
    //设置缩进
    config.titleViewInset = UIEdgeInsetsMake(5, 50, 5, 50);
    
    self.pageViewController = [[TFY_PageViewController alloc] initWithConfig:config];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
}

//分页数
- (NSInteger)pageViewControllerNumberOfPage {
    return [self vcTitles].count;
}

//分页标题
- (NSString *)pageViewController:(TFY_PageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return [self vcTitles][index];
}

//分页视图控制器
- (UIViewController *)pageViewController:(TFY_PageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    if (index == 0) {
        OtherAppExampleListVC *vc = [[OtherAppExampleListVC alloc] init];
        return vc;
        
    }else if (index == 1) {
        BasicFunctionListVC *vc = [[BasicFunctionListVC alloc] init];
        return vc;
    }else  {
        SpecialUseExampleVC *vc = [[SpecialUseExampleVC alloc] init];
        return vc;
    }
}

#pragma mark -
#pragma mark PageViewControllerDelegate
- (void)pageViewController:(TFY_PageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSLog(@"切换到了：%@",[self vcTitles][index]);
}

#pragma mark -
#pragma mark 标题
- (NSArray *)vcTitles {
    return @[@"App例子",@"基础属性",@"特殊用法"];
}
@end
