//
//  TFY_NavigationConfig.m
//  TFY_Navigation
//
//  Created by 田风有 on 2020/9/26.
//  Copyright © 2020 恋机科技. All rights reserved.
//

#import "TFY_NavigationConfig.h"
#import <objc/runtime.h>

void tfy_swizzle(Class oldClass, NSString *oldSelector, Class newClass) {
    NSString *newSelector = [NSString stringWithFormat:@"tfy_%@", oldSelector];
    Method old = class_getInstanceMethod(oldClass, NSSelectorFromString(oldSelector));
    Method new = class_getInstanceMethod(newClass, NSSelectorFromString(newSelector));
    method_exchangeImplementations(old, new);
}

@implementation TFY_NavigationConfig

+ (instancetype)shared {
    static TFY_NavigationConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[self alloc] init];
    });
    return config;
}

-(instancetype)init {
    if (self = [super init]) {
        self.tfy_defaultFixSpace = 15;
        self.tfy_disableFixSpace = NO;
    }
    return self;
}

- (CGFloat)tfy_systemSpace {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) > 375 ? 20 : 16;
}

@end

@implementation UINavigationItem (FixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {} else {
            NSArray <NSString *>*oriSels = @[@"setLeftBarButtonItem:",
                                             @"setLeftBarButtonItem:animated:",
                                             @"setLeftBarButtonItems:",
                                             @"setLeftBarButtonItems:animated:",
                                             @"setRightBarButtonItem:",
                                             @"setRightBarButtonItem:animated:",
                                             @"setRightBarButtonItems:",
                                             @"setRightBarButtonItems:animated:"];
            
            [oriSels enumerateObjectsUsingBlock:^(NSString * _Nonnull oriSel, NSUInteger idx, BOOL * _Nonnull stop) {
                tfy_swizzle(self, oriSel, self);
            }];
        }
    });
}

-(void)tfy_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
}

-(void)tfy_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated {
    if (!TFY_NavigationConfig.shared.tfy_disableFixSpace && leftBarButtonItem) {//存在按钮且需要调节
        [self setLeftBarButtonItems:@[leftBarButtonItem] animated:animated];
    } else {//不存在按钮,或者不需要调节
        [self tfy_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}

-(void)tfy_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [self setLeftBarButtonItems:leftBarButtonItems animated:NO];
}

-(void)tfy_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated {
    if (!TFY_NavigationConfig.shared.tfy_disableFixSpace && leftBarButtonItems.count) {//存在按钮且需要调节
        UIBarButtonItem *firstItem = leftBarButtonItems.firstObject;
        CGFloat width = TFY_NavigationConfig.shared.tfy_defaultFixSpace - TFY_NavigationConfig.shared.tfy_systemSpace;
        if (firstItem.width == width) {//已经存在space
            [self tfy_setLeftBarButtonItems:leftBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self tfy_setLeftBarButtonItems:items animated:animated];
        }
    } else {//不存在按钮,或者不需要调节
        [self tfy_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

-(void)tfy_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    [self setRightBarButtonItem:rightBarButtonItem animated:NO];
}

- (void)tfy_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated {
    if (![TFY_NavigationConfig shared].tfy_disableFixSpace && rightBarButtonItem) {//存在按钮且需要调节
        [self setRightBarButtonItems:@[rightBarButtonItem] animated:animated];
    } else {//不存在按钮,或者不需要调节
        [self tfy_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }
}

-(void)tfy_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems{
    [self setRightBarButtonItems:rightBarButtonItems animated:NO];
}

- (void)tfy_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems animated:(BOOL)animated {
    if (!TFY_NavigationConfig.shared.tfy_disableFixSpace && rightBarButtonItems.count) {//存在按钮且需要调节
        UIBarButtonItem *firstItem = rightBarButtonItems.firstObject;
        CGFloat width = TFY_NavigationConfig.shared.tfy_defaultFixSpace - TFY_NavigationConfig.shared.tfy_systemSpace;
        if (firstItem.width == width) {//已经存在space
            [self tfy_setRightBarButtonItems:rightBarButtonItems animated:animated];
        } else {
            NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonItems];
            [items insertObject:[self fixedSpaceWithWidth:width] atIndex:0];
            [self tfy_setRightBarButtonItems:items animated:animated];
        }
    } else {//不存在按钮,或者不需要调节
        [self tfy_setRightBarButtonItems:rightBarButtonItems animated:animated];
    }
}

-(UIBarButtonItem *)fixedSpaceWithWidth:(CGFloat)width {
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = width;
    return fixedSpace;
}

@end

@implementation NSObject (SXFixSpace)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *)) {
            NSDictionary <NSString *, NSString *>*oriSels = @{@"_UINavigationBarContentView": @"layoutSubviews",
                                                              @"_UINavigationBarContentViewLayout": @"_updateMarginConstraints"};
            [oriSels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull cls, NSString * _Nonnull oriSel, BOOL * _Nonnull stop) {
                tfy_swizzle(NSClassFromString(cls), oriSel, NSObject.class);
            }];
        }
    });
}

- (void)tfy_layoutSubviews {
    [self tfy_layoutSubviews];
    if (TFY_NavigationConfig.shared.tfy_disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentView")]) return;
    id layout = [self valueForKey:@"_layout"];
    if (!layout) return;
    SEL selector = NSSelectorFromString(@"_updateMarginConstraints");
    IMP imp = [layout methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(layout, selector);
}

- (void)tfy__updateMarginConstraints {
    [self tfy__updateMarginConstraints];
    if (TFY_NavigationConfig.shared.tfy_disableFixSpace) return;
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationBarContentViewLayout")]) return;
    [self tfy_adjustLeadingBarConstraints];
    [self tfy_adjustTrailingBarConstraints];
}

- (void)tfy_adjustLeadingBarConstraints {
    if (TFY_NavigationConfig.shared.tfy_disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *leadingBarConstraints = [self valueForKey:@"_leadingBarConstraints"];
    if (!leadingBarConstraints) return;
    CGFloat constant = TFY_NavigationConfig.shared.tfy_defaultFixSpace - TFY_NavigationConfig.shared.tfy_systemSpace;
    for (NSLayoutConstraint *constraint in leadingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeading &&
            constraint.secondAttribute == NSLayoutAttributeLeading) {
            constraint.constant = constant;
        }
    }
}

- (void)tfy_adjustTrailingBarConstraints {
    if (TFY_NavigationConfig.shared.tfy_disableFixSpace) return;
    NSArray<NSLayoutConstraint *> *trailingBarConstraints = [self valueForKey:@"_trailingBarConstraints"];
    if (!trailingBarConstraints) return;
    CGFloat constant = TFY_NavigationConfig.shared.tfy_systemSpace - TFY_NavigationConfig.shared.tfy_defaultFixSpace;
    for (NSLayoutConstraint *constraint in trailingBarConstraints) {
        if (constraint.firstAttribute == NSLayoutAttributeTrailing &&
            constraint.secondAttribute == NSLayoutAttributeTrailing) {
            constraint.constant = constant;
        }
    }
}

@end

