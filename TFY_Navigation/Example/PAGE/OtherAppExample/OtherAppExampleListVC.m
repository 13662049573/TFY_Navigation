//
//  OtherAppExampleListVC.m
//  XLPageViewControllerExample
//
//  Created by MengXianLiang on 2019/5/10.
//  Copyright © 2019 xianliang meng. All rights reserved.
//

#import "OtherAppExampleListVC.h"
#import "CommonPageViewController.h"
#import "CustomTitleCellExampleVC2.h"
#import "CustomTitleCellExampleVC3.h"
#import "NAV_OneController.h"
@interface OtherAppExampleListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OtherAppExampleListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView tfy_AutoSize:0 top:0 right:0 bottom:0];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellTitles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self cellTitles][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self cellImageNames][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self cellTitles][indexPath.row] containsString:@"网易新闻"]) {
        CustomTitleCellExampleVC2 *vc = [[CustomTitleCellExampleVC2 alloc] init];
        vc.title = @"网易新闻";
        [self.navigationController pushViewController:vc animated:true];
        return;
    }
    if ([[self cellTitles][indexPath.row] containsString:@"人民日报"]) {
        CustomTitleCellExampleVC3 *vc = [[CustomTitleCellExampleVC3 alloc] init];
        vc.title = @"人民日报";
        [self.navigationController pushViewController:vc animated:true];
        return;
    }
    if ([[self cellTitles][indexPath.row] containsString:@"导航栏处理"]) {
        NAV_OneController *vc = [NAV_OneController new];
        vc.title = @"导航栏处理";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    CommonPageViewController *exampleVC = [[CommonPageViewController alloc] init];
    exampleVC.title = [self cellTitles][indexPath.row];
    exampleVC.config = [self configOfIndexPath:indexPath];
    exampleVC.titles = [self vcTitlesOfIndexPath:indexPath];
    exampleVC.index = indexPath.row;
    [self.navigationController pushViewController:exampleVC animated:true];
    
}

- (NSArray *)cellTitles {
    return @[
             @"今日头条",
             @"腾讯新闻",
             @"澎湃新闻",
             @"爱奇艺",
             @"优酷",
             @"腾讯视频",
             @"网易新闻",
             @"人民日报",
             @"导航栏处理"
             ];
}

- (NSArray *)cellImageNames {
    return @[
             @"icon_jrtt",
             @"icon_txxw",
             @"icon_ppxw",
             @"icon_iqyi",
             @"icon_yk",
             @"icon_txsp",
             @"icon_wyxw",
             @"icon_rmrb",
             @"me_data_icom"
             ];
}

- (TFY_PageControllerConfig *)configOfIndexPath:(NSIndexPath *)indexPath {
    TFY_PageControllerConfig *config = [TFY_PageControllerConfig defaultConfig];
    switch (indexPath.row) {
        case 0://今日头条
            //标题间距
            config.titleSpace = 15;
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:211 G:60 B:61];
            //标题选中字体
            config.titleSelectedFont = [UIFont systemFontOfSize:18];
            //标题正常颜色
            config.titleNormalColor = [self colorOfR:34 G:34 B:34];
            //标题正常字体
            config.titleNormalFont = [UIFont systemFontOfSize:17];
            //隐藏动画线条
            config.shadowLineHidden = true;
            //分割线颜色
            config.separatorLineColor = [self colorOfR:231 G:231 B:231];
            //cell文字动画
            config.celltextAnimationType = TFY_PageTitleCellAnimationTypeZoom;
            break;
        case 1://腾讯新闻
            //标题间距
            config.titleSpace = 15;
            //标题高度
            config.titleViewHeight = 45;
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:34 G:34 B:34];
            //标题选中字体
            config.titleSelectedFont = [UIFont boldSystemFontOfSize:17];
            //标题正常颜色
            config.titleNormalColor = [self colorOfR:142 G:153 B:160];
            //标题正常字体
            config.titleNormalFont = [UIFont systemFontOfSize:17];
            //阴影颜色
            config.shadowLineColor = [self colorOfR:19 G:121 B:214];
            //阴影宽度
            config.shadowLineWidth = 22;
            //分割线颜色
            config.separatorLineColor = [self colorOfR:238 G:238 B:238];
            break;
        case 2://澎湃新闻
            //标题间距
            config.titleSpace = 15;
            //标题高度
            config.titleViewHeight = 44;
            //在NavigationBar上显示
            config.showTitleInNavigationBar = true;
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:1 G:165 B:235];
            //标题选中字体
            config.titleSelectedFont = [UIFont systemFontOfSize:17];
            //标题正常颜色
            config.titleNormalColor = [self colorOfR:51 G:51 B:51];
            //标题正常字体
            config.titleNormalFont = [UIFont systemFontOfSize:17];
            //阴影颜色
            config.shadowLineColor = [self colorOfR:1 G:165 B:235];
            //阴影宽度
            config.shadowLineWidth = 22;
            //阴影末端是直角
            config.shadowLineCap = TFY_PageShadowLineCapSquare;
            //分割线颜色
            config.separatorLineHidden = true;
            break;
        case 3://爱奇艺
            //标题间距
            config.titleSpace = 15;
            //在NavigationBar上显示
            config.showTitleInNavigationBar = true;
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:10 G:190 B:6];
            //标题选中字体
            config.titleSelectedFont = [UIFont systemFontOfSize:18];
            //标题正常颜色
            config.titleNormalColor = [UIColor whiteColor];
            //标题正常字体
            config.titleNormalFont = [UIFont systemFontOfSize:18];
            //阴影颜色
            config.shadowLineColor = [self colorOfR:10 G:190 B:6];
            //阴影宽度
            config.shadowLineWidth = 22;
            //设置阴影动画方式为缩放
            config.shadowLineAnimationType = TFY_PageShadowLineAnimationTypeZoom;
            //隐藏分割线
            config.separatorLineHidden = true;
            break;
        case 4://优酷
            //标题间距
            config.titleSpace = 15;
            //在NavigationBar上显示
            config.showTitleInNavigationBar = true;
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:39 G:145 B:254];
            //标题选中字体
            config.titleSelectedFont = [UIFont boldSystemFontOfSize:19];
            //标题正常颜色
            config.titleNormalColor = [self colorOfR:210 G:210 B:210];
            //标题正常字体
            config.titleNormalFont = [UIFont systemFontOfSize:19];
            //阴影颜色
            config.shadowLineColor = [self colorOfR:39 G:145 B:254];
            //阴影宽度
            config.shadowLineWidth = 4;
            config.shadowLineHeight = 4;
            //设置阴影动画方式为缩放
            config.shadowLineAnimationType = TFY_PageShadowLineAnimationTypeZoom;
            //隐藏分割线
            config.separatorLineHidden = true;
            break;
        case 5://腾讯视频
            //标题间距
            config.titleSpace = 15;
            //在NavigationBar上显示
            config.showTitleInNavigationBar = true;
            //标题缩进
            config.titleViewInset = UIEdgeInsetsMake(5, 10, 0, 10);
            //标题选中颜色
            config.titleSelectedColor = [self colorOfR:254 G:77 B:2];
            //标题选中字体
            config.titleSelectedFont = [UIFont boldSystemFontOfSize:24];
            //标题正常颜色
            config.titleNormalColor = [self colorOfR:132 G:132 B:148];
            //标题正常字体
            config.titleNormalFont = [UIFont boldSystemFontOfSize:17];
            //隐藏阴影
            config.shadowLineHidden = true;
            //隐藏分割线
            config.separatorLineHidden = true;
            //文字居上
            config.textVerticalAlignment = TFY_PageTextVerticalAlignmentTop;
            //关闭标题颜色过渡
            config.titleColorTransition = false;
            break;
        default:
            break;
    }
    return config;
}

- (NSArray *)vcTitlesOfIndexPath:(NSIndexPath *)indexPath {
    NSArray *titleArr = @[@"关注",@"推荐",@"热点",@"问答",@"科技",@"国风",@"直播",@"新时代",@"北京",@"国际",@"数码",@"小说",@"军事"];
    return titleArr;
}

#pragma mark -
#pragma mark 辅助方法
- (UIColor *)colorOfR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B {
    return [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1];
}

@end
