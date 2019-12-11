//
//  ViewController.m
//  TFY_Navigation
//
//  Created by 田风有 on 2019/5/23.
//  Copyright © 2019 恋机科技. All rights reserved.
//

#import "ViewController.h"
#import "TFY_Navigation/TFY_Navigation.h"
#import "RootController.h"
#import "ZXLGCDTimer.h"



@interface ViewController ()
@property (nonatomic , strong)UILabel *time_label;
@property(nonatomic, assign) NSInteger seconds;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航栏测试";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.navigationItem.leftBarButtonItem = tfy_barbtnItem().tfy_imageItem(@"me_data_icom",self,@selector(imageClick));
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItem(@"开始计时",20,[UIColor redColor],self,@selector(timeimageClick));
    
    self.time_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, 40)];
    self.time_label.textColor = [UIColor redColor];
    self.time_label.backgroundColor = [UIColor whiteColor];
    self.time_label.font = [UIFont boldSystemFontOfSize:15];
    self.time_label.textAlignment = NSTextAlignmentCenter;
    self.time_label.text= @"00:00";
    [self.view addSubview:self.time_label];
    
       
}

-(void)imageClick{
//    [self.navigationController pushViewController:[RootController new] animated:YES];
    [ZXLGCDTimer cancel];
}
-(void)timeimageClick{
   [ZXLGCDTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(print) userInfo:0 repeats:YES];
}


-(void)print{
    self.seconds++;
   
    
    self.time_label.text= [NSString stringWithFormat:@"%.2ld:%.2ld",self.seconds/60,self.seconds%60];
    
   
}

/**
 *  获取当天的字符串
 *  @return 格式为年-月-日 时分秒
 */
- (NSString *)getCurrentTimeyyyymmdd {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"mm:ss";
    NSString *dayStr = [formatDay stringFromDate:now];
    
    return dayStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineSecond : 计时器持续时间（单位/秒）
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineSecond:(CGFloat)deadlineSecond {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [nowDate timeIntervalSince1970] + deadlineSecond;
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
/**
 *  监听生命周期的方法
 *
 */
- (void)statistic{
    /**
     *  @brief App启动
     *
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameLaunch) name:UIApplicationDidFinishLaunchingNotification object:nil];
    
    /**
     *  App进入前台
     *
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    /**
     *   App挂起
     *
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
}

-(void)gameLaunch{
    NSLog(@"===================================================================================App启动");
}

-(void)gameBecomeActive{
    NSLog(@"===================================================================================App进入前台");
}

-(void)gameResignActive{
    NSLog(@"===================================================================================App挂起");
}

-(void)WillResignActiveNotification{
//    //得到当前应用程序的UIApplication对象
//     NSLog(@"==============================================================得到当前应用程序的UIApplication对象");
//    UIApplication *app = [UIApplication sharedApplication];
//     //一个后台任务标识符
//     UIBackgroundTaskIdentifier taskID = 0;
//     taskID = [app beginBackgroundTaskWithExpirationHandler:^{
//     //如果超时(一般超时时间为10min)，将执行这个程序块，并停止运行应用程序,
//         NSLog(@"===================================================================================如果超时(一般超时时间为10min)，将执行这个程序块，并停止运行应用程序,");
//     [app endBackgroundTask:taskID];
//         NSLog(@"==============================================================并停止运行应用程序");
//     }];
}
@end
