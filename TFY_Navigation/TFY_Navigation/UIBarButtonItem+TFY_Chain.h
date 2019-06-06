//
//  UIBarButtonItem+TFY_Chain.h
//  TFY_Navigation
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (TFY_Chain)
/**
 *  按钮初始化 也是隐藏返回按钮
 */
UIBarButtonItem *tfy_barbtnItem(void);
/**
 *  添加图片 image_str 图片字符串 object self  action 点击方法
 */
@property(nonatomic,copy,readonly)UIBarButtonItem *(^tfy_imageItem)(NSString *image_str,id object, SEL action);
/**
 *  添加 title_str 字体文本  fontOfSize字体大小  color 字体颜色 object self  action 点击方法
 */
@property(nonatomic,copy,readonly)UIBarButtonItem *(^tfy_titleItem)(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action);

@end

NS_ASSUME_NONNULL_END
