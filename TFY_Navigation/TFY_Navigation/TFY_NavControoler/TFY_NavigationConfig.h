//
//  TFY_NavigationConfig.h
//  TFY_Navigation
//
//  Created by 田风有 on 2020/9/26.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_NavigationConfig : NSObject

@property (nonatomic, assign) CGFloat tfy_defaultFixSpace; //item距离两端的间距,默认为0
@property (nonatomic, assign) BOOL tfy_disableFixSpace;    //是否禁止使用修正,默认为NO

+ (instancetype)shared;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (CGFloat)tfy_systemSpace;

@end

@interface UINavigationItem (FixSpace)
@end

@interface NSObject (FixSpace)
@end

NS_ASSUME_NONNULL_END
