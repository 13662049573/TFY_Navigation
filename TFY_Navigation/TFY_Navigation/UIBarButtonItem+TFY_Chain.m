//
//  UIBarButtonItem+TFY_Chain.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/6/6.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "UIBarButtonItem+TFY_Chain.h"

#define WSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@implementation UIBarButtonItem (TFY_Chain)
/**
 *  按钮初始化
 */
UIBarButtonItem *tfy_barbtnItem(void){
    return [UIBarButtonItem new];
}
/**
 *  添加图片和点击事件
 */
-(UIBarButtonItem *(^)(NSString *image_str,id object, SEL action))tfy_imageItem{
    return ^(NSString *image_str,id object, SEL action){
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:image_str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:object action:action];
        return item;
    };
}
/**
 *  添加 title_str 字体文本  fontOfSize字体大小  color 字体颜色
 */
-(UIBarButtonItem *(^)(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action))tfy_titleItem{
    return ^(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action){
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title_str style:UIBarButtonItemStylePlain target:object action:action];
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontOfSize],NSFontAttributeName, color,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        return item;
    };
}

@end
