//
//  UIScrollView+NAVCategory.h
//  TFY_Navigation
//
//  Created by 田风有 on 2020/10/25.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (NAVCategory)
// 禁止手势处理，默认为NO，设置为YES表示不对手势冲突进行处理
@property (nonatomic, assign) BOOL  tfy_disableGestureHandle;

@end

NS_ASSUME_NONNULL_END
