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
        UIButton *btn = [self button:object action:action];
        [btn setImage:[[UIImage imageNamed:image_str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        UIBarButtonItem *item = [self Itemview:btn];
        return item;
    };
}
/**
 *  添加 title_str 字体文本  fontOfSize字体大小  color 字体颜色
 */
-(UIBarButtonItem *(^)(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action))tfy_titleItem{
    return ^(NSString *title_str,CGFloat fontOfSize,UIColor *color,id object, SEL action){
        UIButton *button = [self button:object action:action];
        [button setTitle:title_str forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:fontOfSize]];
        UIBarButtonItem *item = [self Itemview:button];
        return item;
    };
}


-(UIButton *)button:(id)object action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    if (object!=nil) {
        [button addTarget:object action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

-(UIBarButtonItem *)Itemview:(UIView *)topView{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:topView];
    return item;
}
@end
