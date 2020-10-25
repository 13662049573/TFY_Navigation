//
//  TFY_NavigationController.m
//
//  Created by 田风有 on 2019/03/27.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "TFY_NavigationController.h"
#import "TFY_NavAnimatedTransitioning.h"
#import "UIViewController+TFY_PopController.h"
#import <objc/runtime.h>
#import "TFY_NavigationConfig.h"

#define NAV_QueueStartAfterTime(time) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){

#define NAV_queueEnd  });

/**是否是苹果iPhoneX以上机型*/
CG_INLINE BOOL TFY_iPhoneX() {
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO);
}

static char ListenTabbarViewMove[] = "ListenTabbarViewMove";
static char const RootNavigationControllerKey = '\0';

#pragma mark - 容器控制器
@interface TFYContainerViewController : UIViewController

@property (nonatomic, weak) UIViewController *contentViewController;
@property (nonatomic, weak) UINavigationController *containerNavigationController;

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController;
- (instancetype)initWithViewController:(UIViewController *)viewController;


@end

@implementation TFYContainerViewController

+ (instancetype)containerViewControllerWithViewController:(UIViewController *)viewController {
    return [[self alloc] initWithViewController:viewController];
}


- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        if (viewController.parentViewController) {
            [viewController willMoveToParentViewController:nil];
            [viewController removeFromParentViewController];
        }
        
        Class cls = [viewController tfy_navigationControllerClass];
        NSAssert(![cls isKindOfClass:UINavigationController.class], @"`-tfy_navigationControllerClass` must return UINavigationController or its subclasses.");
        UINavigationController *navigationController = [[cls alloc] initWithRootViewController:viewController];
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        self.contentViewController = viewController;
        self.containerNavigationController = navigationController;
        self.tabBarItem = viewController.tabBarItem;
        self.hidesBottomBarWhenPushed = viewController.hidesBottomBarWhenPushed;
        [self addChildViewController:navigationController];
        [self.view addSubview:navigationController.view];

        navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                    metrics:nil
                                                      views:@{@"view": navigationController.view}]
        ];
        [NSLayoutConstraint activateConstraints:
            [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                    options:NSLayoutFormatDirectionLeadingToTrailing
                                                    metrics:nil
                                                      views:@{@"view": navigationController.view}]
        ];
        [navigationController didMoveToParentViewController:self];
    }
    return self;
}

@end


#pragma mark - 全局函数

/// 装包
UIKIT_STATIC_INLINE TFYContainerViewController* TFYWrapViewController(UIViewController *vc) {
    if ([vc isKindOfClass:TFYContainerViewController.class]) {
        return (TFYContainerViewController *)vc;
    }
    return [TFYContainerViewController containerViewControllerWithViewController:vc];
}

/// 解包
UIKIT_STATIC_INLINE UIViewController* TFYUnwrapViewController(UIViewController *vc) {
    if ([vc isKindOfClass:TFYContainerViewController.class]) {
        return ((TFYContainerViewController*)vc).contentViewController;
    }
    return vc;
}

/// 替换方法实现
UIKIT_STATIC_INLINE void TFY_swizzled(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma mark - 导航栏控制器

@interface TFY_NavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) TFY_NavAnimatedTransitioning *animatedTransitioning;
@property (nonatomic, strong) UIImageView *imageViews;
@property (nonatomic, assign) CGSize originContentSizeInPop;
@property (nonatomic, assign) CGSize originContentSizeInPopWhenLandscape;
@property (nonatomic, strong) UIPanGestureRecognizer * _Nonnull panGesture;
@property (strong ,nonatomic) NSMutableArray * _Nonnull arrayScreenshot;
@end

@implementation TFY_NavigationController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.originContentSizeInPop = self.contentSizeInPop;
    self.originContentSizeInPopWhenLandscape = self.contentSizeInPopWhenLandscape;
}

- (NSMutableArray *)arrayScreenshot {
    if (!_arrayScreenshot) {
        _arrayScreenshot = NSMutableArray.array;
    }
    return _arrayScreenshot;
}

- (UIImageView *)imageViews {
    if (!_imageViews) {
        _imageViews = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if (TFY_iPhoneX()) {
            _imageViews.layer.masksToBounds = YES;
            _imageViews.layer.cornerRadius = 40;
        }
    }
    return _imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.IsCanleSystemPan = YES;
    self.distancebottomStart = 0;
    self.distanceliftStart = 0;
    [[UITabBar appearance]setTranslucent:NO];
    self.delegate = self;
    
    NAV_QueueStartAfterTime(1.5)
    [[self lastWindow] insertSubview:self.imageViews atIndex:0];
    NAV_queueEnd
    
}

- (void)adjustContentSizeBy:(UIViewController *)controller {

    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight: {
            CGSize contentSize = controller.contentSizeInPopWhenLandscape;
            if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
                self.contentSizeInPopWhenLandscape = contentSize;
            } else {
                self.contentSizeInPopWhenLandscape = self.originContentSizeInPopWhenLandscape;
            }
        }
            break;
        default: {
            CGSize contentSize = controller.contentSizeInPop;
            if (!CGSizeEqualToSize(contentSize, CGSizeZero)) {
                self.contentSizeInPop = contentSize;
            } else {
                self.contentSizeInPop = self.originContentSizeInPop;
            }
        }
            break;
    }

}

#pragma mark Lifecycle

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self commonInit];
        [self setupNavigationBarTheme];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
        [self setupNavigationBarTheme];
    }
    return self;
}
//背景颜色
-(void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    _barBackgroundColor  = barBackgroundColor;
   [self setupNavigationBarTheme];
}
//背景图片
- (void)setBarBackgroundImage:(UIImage *)barBackgroundImage {
    _barBackgroundImage = barBackgroundImage;
    [self setupNavigationBarTheme];
}
//字体颜色
-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    [self setupNavigationBarTheme];
}
//字体大小
- (void)setFont:(UIFont *)font {
    _font = font;
    [self setupNavigationBarTheme];
}
//左边按钮图片
-(void)setLeftimage:(UIImage *)leftimage {
    _leftimage = leftimage;
}
//右边按钮图片
- (void)setRightimage:(UIImage *)rightimage {
    _rightimage = rightimage;
}

- (void)setDefaultFixSpace:(CGFloat)defaultFixSpace {
    _defaultFixSpace = defaultFixSpace;
    TFY_NavigationConfig.shared.tfy_defaultFixSpace = _defaultFixSpace;
}

- (void)setDisableFixSpace:(BOOL)disableFixSpace {
    _disableFixSpace = disableFixSpace;
    TFY_NavigationConfig.shared.tfy_disableFixSpace = _disableFixSpace;
}

- (void)setDistanceliftStart:(CGFloat)distanceliftStart {
    _distanceliftStart = distanceliftStart;
}

- (void)setDistancebottomStart:(CGFloat)distancebottomStart {
    _distancebottomStart = distancebottomStart;
}

//赋值
- (void)setupNavigationBarTheme {
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIColor *color = self.barBackgroundColor ?: [UIColor whiteColor];
    if ([self.barBackgroundImage isKindOfClass:[UIImage class]]) {
        [navBar setBackgroundImage:self.barBackgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else{
       [navBar setBackgroundImage:[self tfy_createImage:color] forBarMetrics:UIBarMetricsDefault];
    }
    [navBar setShadowImage:[[UIImage alloc] init]];
    // 设置标题文字颜色
    UIColor *titlecolor = self.titleColor ?: [UIColor blackColor];
    UIFont *font = self.font?:[UIFont boldSystemFontOfSize:15.0];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = font;
    textAttrs[NSForegroundColorAttributeName] = titlecolor;
    [navBar setTitleTextAttributes:textAttrs];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TFYContainerViewController *container = TFYWrapViewController(viewController);
   if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    // 返回按钮目前仅支持图片
    UIImage *leftImage = [self.leftimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ?: [[self navigationBarBackIconImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   UIImage *rightImage = [self.rightimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (self.viewControllers.count > 0) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wundeclared-selector"
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:viewController action:@selector(tfy_popViewController)];
         UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:viewController action:@selector(tfy_rightController)];
        #pragma clang diagnostic pop
         viewController.navigationItem.leftBarButtonItem = leftItem;
         viewController.navigationItem.rightBarButtonItem = rightImage!=nil?rightItem:nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height), YES, 0);
    [[self lastWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.arrayScreenshot addObject:viewImage];
    
    if (viewImage) self.imageViews.image = viewImage;

    [super pushViewController:container animated:animated];
    
    // pop手势
    self.interactivePopGestureRecognizer.enabled = !_IsCanleSystemPan;
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGesture.delegate = self;
    self.panGesture.delaysTouchesBegan = YES;
    [self.view addGestureRecognizer:self.panGesture];
    
    objc_setAssociatedObject(container.containerNavigationController, &RootNavigationControllerKey, self, OBJC_ASSOCIATION_ASSIGN);
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.arrayScreenshot removeLastObject];
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        self.imageViews.image = image;
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    return viewController;
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.arrayScreenshot.count > 2) {
        [self.arrayScreenshot removeObjectsInRange:NSMakeRange(1, self.arrayScreenshot.count - 1)];
    }
    UIImage *image = [self.arrayScreenshot lastObject];
    if (image)
        self.imageViews.image = image;
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *arr = [super popToViewController:viewController animated:animated];
    if (self.arrayScreenshot.count > arr.count){
        for (int i = 0; i < arr.count; i++) {
            [self.arrayScreenshot removeLastObject];
        }
    }
    return arr;
}

- (UIImage *)tfy_createImage:(UIColor *)imageColor {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [imageColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    [toVC view];
    [self adjustContentSizeBy:toVC];
    self.animatedTransitioning.state = operation == UINavigationControllerOperationPush ? PopStatePop : PopStateDismiss;
    return self.animatedTransitioning;
}


#pragma mark <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.view == self.view && [gestureRecognizer locationInView:self.view].x < (self.distanceliftStart == 0 ? UIScreen.mainScreen.bounds.size.width : self.distanceliftStart)) {
       if ([gestureRecognizer locationInView:self.view].y > UIScreen.mainScreen.bounds.size.height - self.distancebottomStart){
            return NO;
        } else {
            CGPoint translate = [gestureRecognizer translationInView:self.view];
            BOOL possible = translate.x != 0 && fabs(translate.y) == 0;
            if (possible)
                return YES;
            else
                return NO;
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] || [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")]|| [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPagingSwipeGestureRecognizer")]) {
        UIView *aView = otherGestureRecognizer.view;
        if ([aView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *sv = (UIScrollView *)aView;
            if (sv.contentOffset.x==0) {
                if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] && otherGestureRecognizer.state != UIGestureRecognizerStateBegan) {
                    return NO;
                }else{
                    return YES;
                }
            }
        }
        return NO;
    }
    return YES;
}

// 在pop手势生效后能够确保滚动视图静止
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return (gestureRecognizer == self.interactivePopGestureRecognizer);
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    UIViewController *rootVC = [self lastWindow].rootViewController;
    if (self.viewControllers.count == 1) {return;}
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (TFY_iPhoneX()) {
            rootVC.view.layer.masksToBounds = YES;
            rootVC.view.layer.cornerRadius = 40;
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= 10) {//(拖拽的范围,大于此值才有效果)
            rootVC.view.transform = CGAffineTransformMakeTranslation(point_inView.x - 10, 0);
        }
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint point_inView = [panGesture translationInView:self.view];
        if (point_inView.x >= 70) {//(距离左边多少距离，可以自动返回)
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformMakeTranslation(([UIScreen mainScreen].bounds.size.width), 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                rootVC.view.transform = CGAffineTransformIdentity;
            }];
        }
        else {
            [UIView animateWithDuration:0.3 animations:^{
                rootVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                if (TFY_iPhoneX()) {
                    rootVC.view.layer.masksToBounds = NO;
                    rootVC.view.layer.cornerRadius = 0;
                }
            }];
        }
    }
    [rootVC.view addObserver:self forKeyPath:@"transform" options:NSKeyValueObservingOptionNew context:ListenTabbarViewMove];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1)    return NO;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x < [UIScreen mainScreen].bounds.size.width) {
            return YES;
        }
    }
    return NO;
}

- (UIWindow*)lastWindow {
    NSEnumerator  *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden&& window.alpha>0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        BOOL windowKeyWindow = window.isKeyWindow;
        if (windowOnMainScreen && windowIsVisible && windowLevelSupported && windowKeyWindow) {return window;}
    }
    return [UIApplication sharedApplication].keyWindow;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == ListenTabbarViewMove){
        NSValue *value  = [change objectForKey:NSKeyValueChangeNewKey];
        CGAffineTransform newTransform = [value CGAffineTransformValue];
        [self showEffectChange:CGPointMake(newTransform.tx, 0) ];
    }
}

- (void)showEffectChange:(CGPoint)pt{
    
    if (pt.x > 0){
        self.imageViews.transform = CGAffineTransformMakeScale(0.95 + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - 0.95)), 0.95 + (pt.x / ([UIScreen mainScreen].bounds.size.width) * (1 - 0.95)));
    }
    if (pt.x < 0){
        self.imageViews.transform = CGAffineTransformIdentity;
    }
}

#pragma mark Private

- (void)commonInit {
    UIViewController *topViewController = self.topViewController;
    if (topViewController) {
        UIViewController *wrapViewController = TFYWrapViewController(topViewController);
        [super setViewControllers:@[wrapViewController] animated:NO];
    }
    [self setNavigationBarHidden:YES animated:NO];
}

- (UIImage *)navigationBarBackIconImage {
    CGSize const size = CGSizeMake(15.0, 21.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    UIColor *color = [UIColor blackColor];
    [color setFill];
    [color setStroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.9, 0)];
    [bezierPath addLineToPoint: CGPointMake(12, 1.1)];
    [bezierPath addLineToPoint: CGPointMake(1.1, 11.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.7)];
    [bezierPath addLineToPoint: CGPointMake(10.9, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath addLineToPoint: CGPointMake(10.88, 21)];
    [bezierPath addLineToPoint: CGPointMake(0.54, 11.21)];
    [bezierPath addLineToPoint: CGPointMake(1.64, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath closePath];
    [bezierPath setLineWidth:1.0];
    [bezierPath fill];
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (TFY_NavAnimatedTransitioning *)animatedTransitioning {
    if (!_animatedTransitioning) {
        _animatedTransitioning = [[TFY_NavAnimatedTransitioning alloc] initWithState:PopStatePop];
    }
    return _animatedTransitioning;
}
#pragma mark setter & getter

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:NO];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:TFYWrapViewController(vc)];
    }
    [super setViewControllers:aViewControllers animated:animated];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    NSMutableArray<UIViewController *> *aViewControllers = [NSMutableArray array];
    for (UIViewController *vc in viewControllers) {
        [aViewControllers addObject:TFYWrapViewController(vc)];
    }
    [super setViewControllers:[NSArray arrayWithArray:aViewControllers]];
}

- (NSArray<UIViewController *> *)viewControllers {
    //返回真正的控制器给外界
    NSMutableArray<UIViewController *> *vcs = [NSMutableArray array];
    NSArray<UIViewController *> *viewControllers = [super viewControllers];
    for (UIViewController *vc in viewControllers) {
        [vcs addObject:TFYUnwrapViewController(vc)];
    }
    return [NSArray arrayWithArray:vcs];
}

@end


#pragma mark -

@implementation UIViewController (TFYNavigationContainer)

/// 通过返回不同的导航栏控制器可以给每个控制器定制不同的导航栏样式
- (Class)tfy_navigationControllerClass {
#ifdef kTFYNavigationControllerClassName
    return NSClassFromString(kTFYNavigationControllerClassName);
#else
    return [TFYContainerNavigationController class];
#endif
}

- (TFY_NavigationController *)tfy_rootNavigationController {
    UIViewController *parentViewController = self.navigationController.parentViewController;
    if (parentViewController && [parentViewController isKindOfClass:TFYContainerViewController.class]) {
        TFYContainerViewController *container = (TFYContainerViewController*)parentViewController;
        return (TFY_NavigationController*)container.navigationController;
    }
    return nil;
}

- (void)tfy_popViewController {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)setRight_block:(void (^)(void))right_block {
    objc_setAssociatedObject(self, &@selector(right_block), right_block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(void))right_block {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)tfy_rightController {
    if (self.right_block) {
        self.right_block();
    }
}

@end


#pragma mark -

@interface UINavigationController (TFYNavigationContainer)
@end

@implementation UINavigationController (TFYNavigationContainer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *actions = @[
                             NSStringFromSelector(@selector(pushViewController:animated:)),
                             NSStringFromSelector(@selector(popViewControllerAnimated:)),
                             NSStringFromSelector(@selector(popToViewController:animated:)),
                             NSStringFromSelector(@selector(popToRootViewControllerAnimated:)),
                             NSStringFromSelector(@selector(viewControllers))
                             ];
        for (NSString *str in actions) {
            TFY_swizzled(self, NSSelectorFromString(str), NSSelectorFromString([@"tfy_" stringByAppendingString:str]));
        }
    });
}

#pragma mark Private

- (TFY_NavigationController *)rootNavigationController {
    if (self.parentViewController && [self.parentViewController isKindOfClass:TFYContainerViewController.class]) {
        TFYContainerViewController *containerViewController = (TFYContainerViewController *)self.parentViewController;
        TFY_NavigationController *rootNavigationController = (TFY_NavigationController *)containerViewController.navigationController;
        // 如果用户执行了pop操作, 则此时`rootNavigationController`将为nil
        // 将尝试从关联对象中取出`XPRootNavigationController`
        return (rootNavigationController ?: objc_getAssociatedObject(self, &RootNavigationControllerKey));
    }
    return nil;
}

#pragma mark Override

- (void)tfy_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController pushViewController:viewController animated:animated];;
    }
    [self tfy_pushViewController:viewController animated:animated];
}

- (UIViewController *)tfy_popViewControllerAnimated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        TFYContainerViewController *containerViewController = (TFYContainerViewController*)[rootNavigationController popViewControllerAnimated:animated];
        return containerViewController.contentViewController;
    }
    return [self tfy_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)tfy_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        TFYContainerViewController *container = (TFYContainerViewController*)viewController.navigationController.parentViewController;
        NSArray<UIViewController*> *array = [rootNavigationController popToViewController:container animated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:TFYUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self tfy_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)tfy_popToRootViewControllerAnimated:(BOOL)animated {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        NSArray<UIViewController*> *array = [rootNavigationController popToRootViewControllerAnimated:animated];
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (UIViewController *vc in array) {
            [viewControllers addObject:TFYUnwrapViewController(vc)];
        }
        return viewControllers;
    }
    return [self tfy_popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)tfy_viewControllers {
    TFY_NavigationController *rootNavigationController = [self rootNavigationController];
    if (rootNavigationController) {
        return [rootNavigationController viewControllers];
    }
    return [self tfy_viewControllers];
}

- (UITabBarController *)tfy_tabBarController {
    UITabBarController *tabController = [self tfy_tabBarController];
    if (self.parentViewController && [self.parentViewController isKindOfClass:TFYContainerViewController.class]) {
        if (self.viewControllers.count > 1 && self.topViewController.hidesBottomBarWhenPushed) {
            // 解决滚动视图在iOS11以下版本中底部留白问题
            return nil;
        }
        if (!tabController.tabBar.isTranslucent) {
            return nil;
        }
    }
    return tabController;
}


@end


#pragma mark - 状态栏样式 & 屏幕旋转

@implementation TFYContainerNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarStyle];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredStatusBarStyle];
    }
    return [super preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredStatusBarUpdateAnimation];
    }
    return [super preferredStatusBarUpdateAnimation];
}

- (BOOL)prefersStatusBarHidden {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (BOOL)shouldAutorotate {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) shouldAutorotate];
    }
    return [super shouldAutorotate];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredInterfaceOrientationForPresentation];
    }
    return [super preferredInterfaceOrientationForPresentation];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) supportedInterfaceOrientations];
    }
    return [super supportedInterfaceOrientations];
}

#if __IPHONE_11_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
- (nullable UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForScreenEdgesDeferringSystemGestures];
}

- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) preferredScreenEdgesDeferringSystemGestures];
    }
    return [super preferredScreenEdgesDeferringSystemGestures];
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return [TFYUnwrapViewController(self.topViewController) prefersHomeIndicatorAutoHidden];
    }
    return [super prefersHomeIndicatorAutoHidden];
}

- (UIViewController *)childViewControllerForHomeIndicatorAutoHidden
{
    if (self.topViewController) {
        return TFYUnwrapViewController(self.topViewController);
    }
    return [super childViewControllerForHomeIndicatorAutoHidden];
}
#endif

@end
