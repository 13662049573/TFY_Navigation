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
        _dataSource = @[@"导航功能测试"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

- (void)setupTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.tableView];
    
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
        NAV_FiveViewController *vc =NAV_FiveViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
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
