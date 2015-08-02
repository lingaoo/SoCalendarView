//
//  SoCalendar.m
//  LearnCalendar
//
//  Created by soso on 15/6/12.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "SoCalendar.h"

@implementation SoCalendar

-(NSDate*)nsDate
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = self.year;
    components.month = self.month;
    components.day = self.day;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

-(void)jbCalendarWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day                andShowDay:(NSString *)showDay andLunarMonth:(NSString *)lunarMonth andLunarDay:(NSString *)lunarDay andHoliday:(NSString *)holiday andSeason:(NSString *)season
{
    [self jbCalendarWithYear:year andMonth:month andday:day andShowDay:showDay andLunarMonth:lunarMonth andLunarDay:lunarDay andWeek:@"" andHoliday:holiday andSeason:season andMessage:@""];
}

-(void)jbCalendarWithYear:(NSInteger)year andMonth:(NSInteger)month andday:(NSInteger)day                andShowDay:(NSString *)showDay  andLunarMonth:(NSString *)lunarMonth andLunarDay:(NSString *)lunarDay andWeek:(NSString *)week andHoliday:(NSString *)holiday andSeason:(NSString *)season andMessage:(NSString *)message
{
    _year = year,_month=month,_day=day,_lunarDay = lunarDay,_showDay = showDay,_lunarMonth = lunarMonth,_week = week,_holiday = holiday,_season = season, _message = message;
}

@end
