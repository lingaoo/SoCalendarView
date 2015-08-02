//
//  SoCalendar.h
//  LearnCalendar
//
//  Created by soso on 15/6/12.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoCalendar : NSObject
{
    
}
@property (nonatomic,assign) NSInteger year;
@property (nonatomic,assign) NSInteger month;
@property (nonatomic,assign) NSInteger day;
@property (nonatomic,strong) NSString *showDay;

@property (nonatomic,strong) NSString *lunarMonth;
@property (nonatomic,strong) NSString *lunarDay;

@property (nonatomic,strong) NSString *week;
@property (nonatomic,strong) NSString *holiday;
@property (nonatomic,strong) NSString *season;

@property (nonatomic,strong) NSString *message;

-(NSDate*)nsDate;

/** 构造赋值 */
-(void)jbCalendarWithYear:(NSInteger)year
                 andMonth:(NSInteger)month
                   andday:(NSInteger)day
               andShowDay:(NSString *)showDay
            andLunarMonth:(NSString *)lunarMonth
              andLunarDay:(NSString *)lunarDay
                  andWeek:(NSString *)week
               andHoliday:(NSString *)holiday
                andSeason:(NSString *)season
               andMessage:(NSString *)message;

/** 不带备注的星期 */
-(void)jbCalendarWithYear:(NSInteger)year
                 andMonth:(NSInteger)month
                   andday:(NSInteger)day
               andShowDay:(NSString *)showDay
            andLunarMonth:(NSString *)lunarMonth
              andLunarDay:(NSString *)lunarDay
               andHoliday:(NSString *)holiday
                andSeason:(NSString *)season;



@end
