//
//  ZXLGCDTimer.h
//  testTimer
//
//  Created by 张小龙 on 2018/7/18.
//  Copyright © 2018年 张小龙. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, TimeDifference) {
    YearDifference,   //计算年差
    MonthlDifference, //计算月差
    DaysDifference,   //计算日差
    HourDifference,   //计算小时差
    MinuteDifference, //计算分差
    SecondsDifference //计算秒差
};


@interface ZXLGCDTimer : NSObject

/**
 * 定时器GCD版 timeInterval 时间 单位:秒  target target  selector 函数  userInfo 参数  repeats 是否重复
*/
-(instancetype)initWithTimeInterval:(NSInteger)interval target:(id)target selector:(SEL)selector parameter:(id)parameter;

/**启动*/
- (void)start;
/**暂停*/
- (void)pause;

/**继续*/
- (void)resume;

/**销毁*/
- (void)cancel;

/**
 * 定时器GCD版 timeInterval 时间 单位:秒  target target  selector 函数  userInfo 参数  repeats 是否重复
 */
+(void)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats;

/**启动*/
+ (void)start;
/**暂停*/
+ (void)pause;

/**继续*/
+ (void)resume;

/**销毁*/
+ (void)cancel;

+(NSInteger)nowDateDifferWithDate:(NSDate *)date TimeDifference:(TimeDifference)timeDifference;
@end
