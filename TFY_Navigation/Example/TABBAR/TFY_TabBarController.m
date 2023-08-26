//
//  TFY_TabBarController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/30.
//  Copyright © 2020 浙江日报集团. All rights reserved.
//

#import "TFY_TabBarController.h"
#import "ViewController.h"
#import "NAV_OneController.h"
#import "NAV_FourViewController.h"
#import "TFY_NavigationController.h"
#import "NAV_MainViewController.h"
#import "NAV_FiveViewController.h"
@interface TFY_TabBarController ()<TfySY_TabBarDelegate>

@end

@implementation TFY_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子VC
    [self addChildViewControllers];
}
- (void)addChildViewControllers{
    // 创建选项卡的数据 想怎么写看自己，这块我就写笨点了
    NSArray <NSDictionary *>*VCArray =
    @[@{@"vc":[ViewController new],@"normalImg":@"home_normal",@"selectImg":@"home_highlight",@"itemTitle":@"首页"},
      @{@"vc":[NAV_OneController new],@"normalImg":@"mycity_normal",@"selectImg":@"mycity_highlight",@"itemTitle":@"同城"},
      @{@"vc":[NAV_FourViewController new],@"normalImg":@"",@"selectImg":@"",@"itemTitle":@"发布"},
      @{@"vc":[NAV_MainViewController new],@"normalImg":@"message_normal",@"selectImg":@"message_highlight",@"itemTitle":@"消息"},
      @{@"vc":[NAV_FiveViewController new],@"normalImg":@"account_normal",@"selectImg":@"account_highlight",@"itemTitle":@"我的"}];
    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2.根据集合来创建TabBar构造器
        TfySY_TabBarConfigModel *model = [TfySY_TabBarConfigModel new];
        // 3.item基础数据三连
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        // 4.设置单个选中item标题状态下的颜色
        model.selectColor = [UIColor blackColor];
        model.normalColor = [UIColor blackColor];
        
        /***********************************/
        if (idx == 2 ) { // 如果是中间的
            // 设置凸出 矩形
            model.bulgeStyle = TfySY_TabBarConfigBulgeStyleSquare;
            // 设置凸出高度
            model.bulgeHeight = 30;
            // 设置成图片文字展示
            model.itemLayoutStyle = TfySY_TabBarItemLayoutStyleTopPictureBottomTitle;
            // 设置图片
            model.selectImageName = @"post_normal";
            model.normalImageName = @"post_normal";
            model.selectBackgroundColor = model.normalBackgroundColor = [UIColor clearColor];
            model.backgroundImageView.hidden = YES;
            // 设置图片大小c上下左右全边距
            model.componentMargin = UIEdgeInsetsMake(0, 0, 0, 0 );
            // 设置图片的高度为40
            model.icomImgViewSize = CGSizeMake(self.tabBar.frame.size.width / 5, 60);
            model.titleLabelSize = CGSizeMake(self.tabBar.frame.size.width / 5, 20);
            // 图文间距0
            model.pictureWordsMargin = 0;
            // 设置标题文字字号
            model.titleLabel.font = [UIFont systemFontOfSize:11];
            // 设置大小/边长 自动根据最大值进行裁切
            model.itemSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 5.0 ,self.tabBar.frame.size.height + 20);
        }else{  // 其他的按钮来点小动画吧
            // 来点效果好看
            model.interactionEffectStyle = TfySY_TabBarInteractionEffectStyleShake;
            // 点击背景稍微明显点吧
            model.selectBackgroundColor = TfySY_TabBarRGBA(248, 248, 248, 1);
            model.normalBackgroundColor = [UIColor clearColor];
        }
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        vc.view.backgroundColor =  TfySY_TabBarRGBA(248, 248, 248, 1);
        vc.title = [obj objectForKey:@"itemTitle"];
        TFY_NavigationController *nav = [[TFY_NavigationController alloc] initWithRootViewController:vc];
        [tabBarVCs addObject:nav];
        [tabBarConfs addObject:model];
    }];
  
    [self controllerArr:tabBarVCs TabBarConfigModelArr:tabBarConfs];
    
}

@end
