//
//  SoCalendarView.h
//  LearnCalendar
//
//  Created by soso on 15/6/17.
//  Copyright (c) 2015年 seebon. All rights reserved.
//
//  实现日常日历的功能,不费话先举个栗子。
//
//  eg.
//
//   SoCalendarView *calenarView = [[SoCalendarView alloc]initWithSoCalendarViewWithFrame:self.view.frame];
//   calenarView.deleagte = self;
//   [self.view addSubview:calenarView];
//

#import <UIKit/UIKit.h>
#import "SoDateTools.h"
@class SoCalendarView;
@protocol SoCalendarViewDelegate <NSObject>

-(void)soCalendarView:(SoCalendarView *)calendarView selectCalendarDay:(SoCalendar *)calendar;

@optional
-(void)soCalendarView:(SoCalendarView *)calendarView currenCalendarWithYear:(int)year andMonth:(int)month;
@end

@interface SoCalendarView : UIView
{
    NSArray *dayArray;           // 公历
    NSArray *lunarDayArray;      // 农历
    
    int varMonth;                
    int varYear;
    
}
@property (nonatomic,strong) id <SoCalendarViewDelegate> deleagte;

/** 初始化 */
-(instancetype)initWithSoCalendarView;
/** 初始化 */
-(instancetype)initWithSoCalendarViewWithFrame:(CGRect)frame;
/** 获取某一年月的日历 */
-(void)soCalendarWithYear:(int)year andMonth:(int)month;
@end

