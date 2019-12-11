//
//  ZXLGCDTimer.m
//  testTimer
//
//  Created by 张小龙 on 2018/7/18.
//  Copyright © 2018年 张小龙. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ZXLGCDTimer.h"
@interface ZXLGCDTimer()
@property (nonatomic, copy) NSString  * timerKey;
@property (nonatomic, strong) NSMutableDictionary * timerContainer;
@end

@implementation ZXLGCDTimer

+(instancetype)manager{
    static dispatch_once_t pred = 0;
    static ZXLGCDTimer * manager = nil;
    dispatch_once(&pred, ^{
        manager = [[ZXLGCDTimer alloc] init];
    });
    return manager;
}

-(void)dealloc{
    [self cancel];
}

-(instancetype)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)selector parameter:(id)parameter{
    if (interval == 0 || !target || !selector) {
        return nil;
    }
    
    if (self = [super init]) {
        self.timerKey = [self addTimerWithTimeInterval:interval target:target selector:selector userInfo:parameter repeats:YES fire:NO];
    }
    return self;
}

-(NSMutableDictionary *)timerContainer{
    if (!_timerContainer) {
        _timerContainer = [NSMutableDictionary dictionary];
    }
    return _timerContainer;
}

-(NSString *)addTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats fire:(BOOL)fire{
    
    __block  NSString *timerKey = [NSString stringWithFormat:@"%p%@%f%f",target,NSStringFromSelector(selector),timeInterval,[[NSDate date] timeIntervalSinceNow]];
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    [self.timerContainer setObject:timer forKey:timerKey];
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeInterval * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    typeof(self) __weak weakSelf = self;
    __weak id weakTarget = target;
    dispatch_source_set_event_handler(timer, ^{
        if (weakTarget && selector && [weakTarget respondsToSelector:selector]) {
            IMP imp = [weakTarget methodForSelector:selector];
            void (*func)(id, SEL,id) = (void *)imp;
            func(weakTarget, selector,userInfo);
            if (!repeats) {
                dispatch_cancel(timer);
                [weakSelf.timerContainer removeObjectForKey:timerKey];
            }
        }else{
            dispatch_cancel(timer);
            [weakSelf.timerContainer removeObjectForKey:timerKey];
        }
    });
    
    if (fire) {
        dispatch_resume(timer);
    }
    return timerKey;
}

//启动
- (void)start{
    [self resume];
}
//暂停
- (void)pause{
    dispatch_source_t timer = (dispatch_source_t)[self.timerContainer objectForKey:self.timerKey];
    if (timer) {
        dispatch_suspend(timer);
    }
}
//继续
- (void)resume{
    dispatch_source_t timer = (dispatch_source_t)[self.timerContainer objectForKey:self.timerKey];
    if (timer) {
        dispatch_resume(timer);
    }
}
//销毁
- (void)cancel{
    dispatch_source_t timer = (dispatch_source_t)[self.timerContainer objectForKey:self.timerKey];
    if (timer) {
        dispatch_cancel(timer);
        [self.timerContainer removeObjectForKey:self.timerKey];
    }
}


+(void)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats{
    [[ZXLGCDTimer manager] addTimerWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats fire:YES];
}

//启动
+ (void)start{
    [[ZXLGCDTimer manager] start];
}
//暂停
+ (void)pause{
   [[ZXLGCDTimer manager] pause];
}

//继续
+ (void)resume{
    [[ZXLGCDTimer manager] resume];
}

//销毁
+ (void)cancel{
    [[ZXLGCDTimer manager] cancel];
}




+(NSInteger)nowDateDifferWithDate:(NSDate *)date TimeDifference:(TimeDifference)timeDifference {
    //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    NSTimeZone *zone=[NSTimeZone systemTimeZone];//得到时区，根据手机系统时区设置（systemTimeZone）
    
    NSDate *nowDate=[NSDate date];//获取当前日期
    
    /*GMT：格林威治标准时间*/
    //格林威治标准时间与系统时区之间的偏移量（秒）
    NSInteger nowInterval=[zone secondsFromGMTForDate:nowDate];
    
    //将偏移量加到当前日期
    NSDate *nowTime=[nowDate dateByAddingTimeInterval:nowInterval];
    
    //传入日期设置日期格式
    NSString *stringDate = [dateFormatter stringFromDate:date];
    NSDate *yourDate = [dateFormatter dateFromString:stringDate];
    
    //格林威治标准时间与传入日期之间的偏移量
    NSInteger yourInterval = [zone secondsFromGMTForDate:yourDate];
    
    //将偏移量加到传入日期
    NSDate *yourTime = [yourDate dateByAddingTimeInterval:yourInterval];
    
    //time为两个日期的相差秒数
    NSTimeInterval time=[yourTime timeIntervalSinceDate:nowTime];
    
    //最后通过秒数time计算时间相差 几年？几月？几天？几时？几分钟？几秒？
    CGFloat div = 1.0;
    switch (timeDifference) {
        case SecondsDifference:
            div = 1.0;
            break;
        case MinuteDifference:
            div = 60.0;
            break;
        case HourDifference:
            div = 60.0 * 60.0;
            break;
        case DaysDifference:
            div = 60.0 * 60.0 * 24;
            break;
        case MonthlDifference:
            div = 60.0 * 60.0 * 24 * 30;
            break;
        case YearDifference:
            div = 60.0 * 60.0 * 24 * 30 * 365;
            break;
    }
    time = round(time/div);//最后选择四舍五入
    return (NSInteger)time;
}

@end
