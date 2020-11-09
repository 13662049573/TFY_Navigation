//
//  NAV_MainViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/11/7.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "NAV_MainViewController.h"
#import "NAV_FourViewController.h"
#import "NAV_FiveViewController.h"
#import "NAV_SixViewController.h"
#import "NAV_SevenViewController.h"
@interface NAV_MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation NAV_MainViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"导航功能测试",
                        @"UIScrollView使用（手势冲突）",
                        @"TZImagePickerController使用",
                        @"系统导航",
                        @"抖音左右滑动",
                        @"今日头条",
                        @"网易云音乐",
                        @"网易新闻",
                        @"微信"];
    }
    return _dataSource;
}

- (instancetype)init {
    if (self = [super init]) {
        self.tfy_statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tfy_navigationItem.title = @"MainVC";
    self.tfy_navBackgroundColor = [UIColor redColor];
    self.tfy_statusBarStyle = UIStatusBarStyleLightContent;
    self.tfy_navTitleFont = [UIFont systemFontOfSize:18.0f];
    self.tfy_navTitleColor = [UIColor whiteColor];
    
    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    [self.tableView tfy_AutoSize:0 top:TFY_kNavBarHeight() right:0 bottom:TFY_kBottomBarHeight()];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:NAV_FourViewController.new animated:YES];
    } else if (indexPath.row == 1) {
        
    } else if (indexPath.row == 2) {
        
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        
    } else if (indexPath.row == 5) {
        
    } else if (indexPath.row == 6) {
        
    } else if (indexPath.row == 7) {
        
    }
}


@end
