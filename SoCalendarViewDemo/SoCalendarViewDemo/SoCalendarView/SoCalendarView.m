//
//  SoCalendarView.m
//  LearnCalendar
//
//  Created by soso on 15/6/17.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "SoCalendarView.h"

#define KK_WEEKSTITLE_HEiGHT (30*(self.frame.size.width/320.0))
#define KK_CURREND_DAY_COLOR [UIColor cyanColor]
#define KK_HOLIDAY_DAY_COLOR [UIColor brownColor];

@implementation SoCalendarView


-(instancetype)initWithSoCalendarView
{
    return [self initWithSoCalendarViewWithFrame:CGRectZero];
}
-(instancetype)initWithSoCalendarViewWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) {
        // 初始化
        self = [[SoCalendarView alloc]initWithFrame:frame];
        
    }
    // 设置默认当前月的所有新历数据
    dayArray = [SoDateTools getDayArrayByYear:(int)[[SoDateTools currentDate:@"yyyy"] integerValue] andMonth:(int)[[SoDateTools currentDate:@"MM"] integerValue]];
    // 设置默认当前月所有的农历数据
    lunarDayArray = [SoDateTools getLunarDayArrayByYear:(int)[[SoDateTools currentDate:@"yyyy"] integerValue] andMonth:(int)[[SoDateTools currentDate:@"MM"] integerValue]];
    // 设置默认当前月
    varMonth = (int)[[SoDateTools currentDate:@"MM"] integerValue];
    // 设置默认当前年
    varYear = (int)[[SoDateTools currentDate:@"yyyy"] integerValue];
    // 铺设日历排版
    [self addCalendarButton];
    [self addWeekLableToCalendarWatch];
    // 添加左右滑动手势
    [self addHandleSwipe];
    return self;
}

//向日历中添加星期标号（周日到周六）
-(void)addWeekLableToCalendarWatch {
    CGFloat btnWidth = self.frame.size.width/7.0;
    NSMutableArray* array = [[NSMutableArray alloc]initWithArray:[SoDateTools getAllWeekArray]];
    for (int i = 0; i < 7; i++) {
        UILabel* lable = [[UILabel alloc]init];
        lable.text = [NSString stringWithString:array[i]];
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor grayColor];
        lable.frame = CGRectMake(i%7*btnWidth,0, btnWidth, KK_WEEKSTITLE_HEiGHT);
        lable.adjustsFontSizeToFitWidth = YES;
        lable.font = [UIFont systemFontOfSize:12*(self.frame.size.width/320.0)];
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
    }
}

//  --bgView---    
//  |         |      bgView.tag = 10 +i
//  |   11    |  "11"   lunCalendar.tag = 200+i
//  |         |
//  |   初二   | " 初二" jBCalendar.tag = 300+i
//  -----------         btn.tag = 100 +i
//  日历排版
-(void)addCalendarButton
{
    CGFloat btnWidth = (self.frame.size.width/7.0);
    CGFloat btnheigh = (self.frame.size.width/7.0);
    
    NSInteger begain = [SoDateTools getTheWeekOfDayByYera:varYear andByMonth:varMonth];
    
    for (NSInteger i = 0 ; i<dayArray.count; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i%7*btnWidth,i/7*btnheigh+KK_WEEKSTITLE_HEiGHT, btnWidth, btnheigh)];
        bgView.tag = 10+i;
        bgView.layer.cornerRadius = btnWidth/2.0f;
        // 当前天设为cyan背色
        if(i==[[SoDateTools currentDate:@"dd"] integerValue] && varMonth == [[SoDateTools currentDate:@"MM"] integerValue] &&varYear == [[SoDateTools currentDate:@"yyyy"] integerValue])
            bgView.backgroundColor = KK_CURREND_DAY_COLOR ;
//        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        // 当前月显示上月排版与下月排版调低阶色。
        if(i<begain) bgView.alpha = 0.3;
        if(i>=begain+[SoDateTools sunDayWithYear:varYear andMonth:varMonth]) bgView.alpha = 0.3;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0,0, btnWidth, btnheigh);
        btn.tag = i+100;
        [btn addTarget:self action:@selector(btnAtionCalendar:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lunCalendar = [[UILabel alloc]initWithFrame:
                                CGRectMake(6*(self.frame.size.width/320.0),
                                           10*(self.frame.size.width/320.0),
                                           btnWidth-(12*(self.frame.size.width/320.0)),
                                           btnheigh-30*(self.frame.size.width/320.0))];
        lunCalendar.tag = i+200;
        lunCalendar.numberOfLines = 2;
        lunCalendar.adjustsFontSizeToFitWidth = YES;
        lunCalendar.minimumScaleFactor = 0.4;
        lunCalendar.textAlignment = NSTextAlignmentCenter;
        lunCalendar.font = [UIFont systemFontOfSize:14*(self.frame.size.width/320.0)];
        // 节日用其他色标示
        UIColor *color = KK_HOLIDAY_DAY_COLOR;
        lunCalendar.textColor =[((SoCalendar *)dayArray[i]).showDay integerValue] == 0? color:[UIColor blackColor];
        lunCalendar.text =  [NSString stringWithFormat:@"%@",((SoCalendar *)dayArray[i]).showDay];
        
        UILabel *jBCalendar = [[UILabel alloc]initWithFrame:
                               CGRectMake(6*(self.frame.size.width/320.0) ,
                                          lunCalendar.frame.size.height + lunCalendar.frame.origin.y -10*(self.frame.size.width/320.0) ,
                                          btnWidth-(12*(self.frame.size.width/320.0)),
                                          30*(self.frame.size.width/320.0))];
        jBCalendar.font = [UIFont systemFontOfSize:8*(self.frame.size.width/320.0)];
        jBCalendar.tag= i+300;
        jBCalendar.textAlignment = NSTextAlignmentCenter;
        jBCalendar.text = lunarDayArray[i];
        
        [bgView addSubview:lunCalendar];
        [bgView addSubview:jBCalendar];
        [bgView addSubview:btn];
        
    }    
}
// 点击日期；
-(void)btnAtionCalendar:(UIButton*)sender
{
    NSLog(@"click.tag = %ld",(long)sender.tag);
    NSLog(@"%@ , %@",dayArray[sender.tag -100],lunarDayArray[sender.tag -100]);

    for (int i= 0; i<dayArray.count; i++) {
        UIView *bgView = [self viewWithTag:10+i];
        if ([bgView.backgroundColor isEqual:[UIColor colorWithRed:254.0/255 green:208.0/255 blue:55.0/255 alpha:1]]) {
            bgView.backgroundColor = [UIColor clearColor];
            if(i==[[SoDateTools currentDate:@"dd"] integerValue] && varMonth == [[SoDateTools currentDate:@"MM"] integerValue] &&varYear == [[SoDateTools currentDate:@"yyyy"] integerValue])
                bgView.backgroundColor = KK_CURREND_DAY_COLOR ;

        }
    }
    UIView *bgView = [self viewWithTag:10+sender.tag - 100];
    bgView.backgroundColor = [UIColor colorWithRed:254.0/255 green:208.0/255 blue:55.0/255 alpha:1];
    
    if([_deleagte respondsToSelector:@selector(soCalendarView:selectCalendarDay:)]){
        [_deleagte soCalendarView:self selectCalendarDay:dayArray[sender.tag -100]];
    }
}
//添加左右滑动手势
-(void)addHandleSwipe{
    //声明和初始化手势识别器
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftHandleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightHandleSwipe:)];
    //对手势识别器进行属性设定
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    //把手势识别器加到view中去
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    //    [self.view addGestureRecognizer:pan];
    //
    //    [pan requireGestureRecognizerToFail:swipeRight];
    //    [pan requireGestureRecognizerToFail:swipeLeft];
    
}
//左滑事件
- (void)leftHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    varMonth = varMonth+1;
    if(varMonth == 13){
        varYear++;varMonth = 1;
    }
    [self reloadDateForCalendarWatch];
    if ([_deleagte respondsToSelector:@selector(soCalendarView:currenCalendarWithYear:andMonth:)]) {
        [_deleagte soCalendarView:self currenCalendarWithYear:varYear andMonth:varMonth];
    }
}
//右滑事件
- (void)rightHandleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    varMonth = varMonth-1;
    if(varMonth == 0){
        varYear--;varMonth = 12;
    }
    [self reloadDateForCalendarWatch];
    if ([_deleagte respondsToSelector:@selector(soCalendarView:currenCalendarWithYear:andMonth:)]) {
        [_deleagte soCalendarView:self currenCalendarWithYear:varYear andMonth:varMonth];
    }
}

// 跳到某一年月
-(void)soCalendarWithYear:(int)year andMonth:(int)month
{
    varYear = year,varMonth =month;
    [self reloadDateForCalendarWatch];
    if ([_deleagte respondsToSelector:@selector(soCalendarView:currenCalendarWithYear:andMonth:)]) {
        [_deleagte soCalendarView:self currenCalendarWithYear:varYear andMonth:varMonth];
    }
}

-(void)reloadDateForCalendarWatch{
    dayArray = nil,lunarDayArray = nil;
    
    dayArray = [SoDateTools getDayArrayByYear:varYear andMonth:varMonth];
    lunarDayArray =
    [SoDateTools getLunarDayArrayByYear:varYear andMonth:varMonth];
    [self reloadDaybuttenToCalendarWatch];
}
-(void)reloadDaybuttenToCalendarWatch{
    for (int i = 0; i < 42; i++)
        [[self viewWithTag:10+i] removeFromSuperview];
    [self addCalendarButton];
}

// - (void)drawRect:(CGRect)rect {
//
//}

@end
