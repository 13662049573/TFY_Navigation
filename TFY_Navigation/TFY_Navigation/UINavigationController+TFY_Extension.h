//
//  UINavigationController+TFY_Extension.h
//  WYBasisKit
//
//  Created by 田风有 on 2019/03/27.
//  Copyright © 2019 恋机科技. All rights reserved.
//  https://github.com/13662049573/TFY_AutoLayoutModelTools

/*
 如果设置了导航栏的translucent = YES这时在添加子视图的坐标原点相对屏幕坐标是(0,0).如果设置了translucent = NO这时添加子视图的坐标原点相对屏幕坐标就是(0, navViewHeight)
 */

#import <UIKit/UIKit.h>


@interface UINavigationController (TFY_Extension)

/** 导航栏标题字体颜色 */
@property (nonatomic, strong) UIColor *tfy_titleColor;

/** 导航栏标题字号 */
@property (nonatomic, strong) UIFont *tfy_titleFont;

/** 导航栏背景色 */
@property (nonatomic, strong) UIColor *tfy_barBackgroundColor;

/** 导航栏背景图片 */
@property (nonatomic, strong) UIImage *tfy_barBackgroundImage;

/** 导航栏左侧返回按钮背景图片 */
@property (nonatomic, strong) UIImage *tfy_barReturnButtonImage;

/** 导航栏左侧返回按钮背景颜色 */
@property (nonatomic, strong) UIColor *tfy_barReturnButtonColor;

/** 设置导航栏完全透明  会设置translucent = YES */
- (void)tfy_navigationBarTransparent;

/** 让导航栏完全不透明 会设置translucent = NO */
- (void)tfy_navigationBarOpaque;

/** 设置导航栏上滑收起,下滑显示(iOS8及以后有效) */
- (void)tfy_hidesNavigationBarsOnSwipe;

/** 去掉返回按钮 0 左 1 右 */
- (void)tfy_barReturnButtonHideItemType:(NSInteger)itemType navigationItem:(UINavigationItem *)navigationItem;

/** 导航栏左侧返回按钮文本 */
- (void)tfy_pushControllerBarReturnButtonTitle:(NSString *)barReturnButtonTitle navigationItem:(UINavigationItem *)navigationItem;

/** 自定义导航栏左侧返回按钮文本 */
- (void)tfy_customLeftbarbuttonTitle:(NSString *)barButtonTitle barButtonColorWithHexString:(NSString *)color titlesize:(CGFloat)fontSize navigationItem:(UINavigationItem *)navigation target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

/** 自定义导航栏右侧返回按钮文本 */
- (void)tfy_customRightbarbuttonTitle:(NSString *)barButtonTitle barButtonColorWithHexString:(NSString *)color titlesize:(CGFloat)fontSize navigationItem:(UINavigationItem *)navigation target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

/** 自定义leftBarButtonItem */
- (void)tfy_customLeftBarButtonItem:(UINavigationItem *)navigationItem barReturnButtonImage:(NSString *)buttonimage target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

/** 自定义rightBarButtonItem */
- (void)tfy_customRightBarButtonItem:(UINavigationItem *)navigationItem barReturnButtonImage:(NSString *)buttonimage target:(id)target selector:(SEL)selector complete:(void(^)(UIButton *itemButton))complete;

@end
