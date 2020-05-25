//
//  CustomTitleCellExampleVC3.m
//  XLPageViewControllerExample
//
//  Created by MengXianLiang on 2019/5/14.
//  Copyright © 2019 xianliang meng. All rights reserved.
//

#import "CustomTitleCellExampleVC3.h"
#import "CommonTableViewController.h"
#import "CustomPageTitleCell3.h"

@interface CustomTitleCellExampleVC3 ()<TFY_PageViewControllerDelegate,TFY_PageViewControllerDataSrouce>

@property (nonatomic, strong) TFY_PageViewController *pageViewController;

@end

@implementation CustomTitleCellExampleVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    TFY_NavigationController *nav = (TFY_NavigationController *)self.navigationController;
    nav.tfy_titleColor = [UIColor whiteColor];
    nav.tfy_barBackgroundColor = [UIColor colorWithRed:226/255.0f green:17/255.0f blue:0/255.0f alpha:1];
    nav.tfy_titleColor = [UIColor colorWithRed:255/255.0f green:215/255.0f blue:156/255.0f alpha:1];
    nav.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self initPageViewController];
}

- (void)initPageViewController {
    TFY_PageControllerConfig *config = [TFY_PageControllerConfig defaultConfig];
    //隐藏底部阴影
    config.shadowLineHidden = true;
    //设置标题颜色
    config.titleSelectedColor = [UIColor whiteColor];
    //标题正常颜色
    config.titleNormalColor = [UIColor colorWithRed:255/255.0f green:215/255.0f blue:156/255.0f alpha:1];
    //设置标题间距
    config.titleSpace = 15;
    //标题宽度
    config.titleWidth = 50;
    //设置标题栏缩进
    config.titleViewInset = UIEdgeInsetsMake(0, 15, 0, 15);
    //在导航栏中显示
    config.showTitleInNavigationBar = true;
    //隐藏分割线
    config.separatorLineHidden = true;
    
    self.pageViewController = [[TFY_PageViewController alloc] initWithConfig:config];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.pageViewController registerClass:CustomPageTitleCell3.class forTitleViewCellWithReuseIdentifier:@"CustomPageTitleCell3"];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource
- (UIViewController *)pageViewController:(TFY_PageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    CommonTableViewController *vc = [[CommonTableViewController alloc] init];
    return vc;
}

- (NSString *)pageViewController:(TFY_PageViewController *)pageViewController titleForIndex:(NSInteger)index {
    return self.titles[index];
}

- (NSInteger)pageViewControllerNumberOfPage {
    return self.titles.count;
}

- (TFY_PageTitleCell *)pageViewController:(TFY_PageViewController *)pageViewController titleViewCellForItemAtIndex:(NSInteger)index {
    CustomPageTitleCell3 *cell = [pageViewController dequeueReusableTitleViewCellWithIdentifier:@"CustomPageTitleCell3" forIndex:index];
    cell.title = [self titles][index];
    return cell;
}

- (void)pageViewController:(TFY_PageViewController *)pageViewController didSelectedAtIndex:(NSInteger)index {
    NSLog(@"切换到了：%@",[self titles][index]);
}

#pragma mark -
#pragma mark 标题数据
- (NSArray *)titles {
    return @[@"闻|热点",@"评|锐度",@"问|问政",@"京|北京",@"报|版面",@"扶|扶贫",@"旅|旅游",@"听|播报",@"图|镜头",@"视|影像",@"帮|公益"];
}

@end
