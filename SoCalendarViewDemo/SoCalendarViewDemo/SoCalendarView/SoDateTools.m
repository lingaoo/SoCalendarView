//
//  SoTools.m
//  LearnCalendar
//
//  Created by soso on 15/6/12.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "SoDateTools.h"

@implementation SoDateTools

-(NSString*)currentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentMooth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"MM";
    return [formatter stringFromDate:[NSDate date]];
}
-(NSString *)currentDay
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"dd";
    return [formatter stringFromDate:[NSDate date]];
}

//按格式输出日期
+(NSString *)currentDate:(NSString *)dateFormatter
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = dateFormatter;
    return [formatter stringFromDate:[NSDate date]];
}

//按条件输出日期
+ (NSString *)beformDate:(NSString *)currentDate beformDay:(NSInteger)day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date = [formatter dateFromString:currentDate];
    
    NSDate *yesterSevenday = [NSDate dateWithTimeInterval:-60 * 60 * 24 * day sinceDate:date];
    
    return [formatter stringFromDate:yesterSevenday];
}

//当前月第一天
+ (NSString *)firstDayInCurrentMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-01";
    return [formatter stringFromDate:[NSDate date]];
}

//当前月最后一天
+ (NSString *)lastDayInCurrentMonth
{
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    dateComponents.day = 1;
    NSDate *nextMontFirDay = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:nextMontFirDay];
    lastComponents.day = -1;
    NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:lastComponents toDate:nextMontFirDay options:NSCalendarWrapComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:lastDate];
}

//日期比较大小
+ (BOOL)startDate:(NSString *)startDate biggerThranEndDate:(NSString *)endDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *sDate = [formatter dateFromString:startDate];
    NSDate *eDate = [formatter dateFromString:endDate];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:sDate toDate:eDate options:NSCalendarWrapComponents];
    return dateComponents.day < 0 ? YES : NO;
}

//获取星期本周（星期一）
+(NSDate *)dateStartOfWeek:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:1]; //monday is first day 可改变一周第一天是星期几。
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: - ((([components weekday] - [gregorian firstWeekday])
                                      + 7 ) % 7)];
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    NSDateComponents *componentsStripped = [gregorian components: (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                        fromDate: beginningOfWeek];
    
    //gestript
    beginningOfWeek = [gregorian dateFromComponents: componentsStripped];
    
    return beginningOfWeek;
}


//以YYYY年MMdd格式输出此时的农历年月日
+(NSString*)getLunarDateTime {
    SoCalendar* date = [[SoCalendar alloc]init];
    date.year = [[SoDateTools currentDate:@"yyyy"] intValue],date.month =[[SoDateTools currentDate:@"MM"] intValue],date.day = [[SoDateTools currentDate:@"dd"] intValue];
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    NSString * lunar = [[NSString alloc]initWithFormat:
                        @"%@%@年%@%@",lunarCalendar.YearHeavenlyStem,lunarCalendar.YearEarthlyBranch,lunarCalendar.MonthLunar,lunarCalendar.DayLunar];
    return lunar;
}

//获取指定年份指定月份的星期排列表
+(NSArray *)getDayArrayByYear:(int)year andMonth:(int)month {
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    NSArray *beformArray =[self getSimpleDayArrayByYear:month-1>0?year:year-1 andMonth:month-1>0?month-1:12];
    NSArray *nextArray = [self getSimpleDayArrayByYear:month+1<13?year:year+1 andMonth:month+1<13?month+1:1];
    int sunNextDay = 0;
    
    for (int i = 0; i< 42; i++) {
        NSString *days = @"";
        SoCalendar *calendar = [[SoCalendar alloc]init];
        if (i < [self getTheWeekOfDayByYera:year andByMonth:month]) {
            days = beformArray[beformArray.count-1-[self getTheWeekOfDayByYera:year andByMonth:month]+(i+1)];
            
            [calendar jbCalendarWithYear:year
                                andMonth:month-1>0?month-1:12
                                  andday:[days integerValue]
                              andShowDay:[self getHolidayWithYear:year andMonth:month-1>0?month-1:12 andDay:(int)[days integerValue]]
                           andLunarMonth:@""
                             andLunarDay:@""
                              andHoliday:@""
                               andSeason:@""];
            days = [self getHolidayWithYear:year andMonth:month-1>0?month-1:12 andDay:(int)[days integerValue]];
        }else if ((i>[self getTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self getTheWeekOfDayByYera:year andByMonth:month]+[self getNumberOfDayByYera:year andByMonth:month])) {
            
            if((i - [self getTheWeekOfDayByYera:year andByMonth:month] +1)< 10)
                days = [NSString stringWithFormat:@"%02d",i-[self getTheWeekOfDayByYera:year andByMonth:month]+1];
            else
                days = [NSString stringWithFormat:@"%02d",i-[self getTheWeekOfDayByYera:year andByMonth:month]+1];
            
            [calendar jbCalendarWithYear:year
                                andMonth:month
                                  andday:[days integerValue]
                              andShowDay:[self getHolidayWithYear:year andMonth:month andDay:(int)[days integerValue]]
                           andLunarMonth:@""
                             andLunarDay:@""
                              andHoliday:@""
                               andSeason:@""];
            days = [self getHolidayWithYear:year andMonth:month andDay:(int)[days integerValue]];
          
            
        }else {
            days = nextArray[i-[self getTheWeekOfDayByYera:year andByMonth:month]-[self getNumberOfDayByYera:year andByMonth:month]];
            [calendar jbCalendarWithYear:year
                                andMonth:month+1<13?month+1:1
                                  andday:[days integerValue]
                              andShowDay:[self getHolidayWithYear:year andMonth:month+1<13?month+1:1 andDay:(int)[days integerValue]]
                           andLunarMonth:@""
                             andLunarDay:@""
                              andHoliday:@""
                               andSeason:@""];
            days = [self getHolidayWithYear:year andMonth:month+1<13?month+1:1 andDay:(int)[days integerValue]];
            sunNextDay ++ ;
        }
        
        [dayArray addObject:calendar];

    }
    if (sunNextDay >= 7) {
        [dayArray removeObjectsInRange:NSMakeRange(42-7*(sunNextDay/7), 7*(sunNextDay/7))];
    }
    return dayArray;
}

//获取指定年份指定月份的星期排列表 (不带空隔)
+(NSArray *)getSimpleDayArrayByYear:(int)year andMonth:(int)month {
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
        if ((i>[self getTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self getTheWeekOfDayByYera:year andByMonth:month]+[self getNumberOfDayByYera:year andByMonth:month])) {
            SoCalendar *calendar = [[SoCalendar alloc]init];
            NSString * days;
            
            // 公历日期
            if((i - [self getTheWeekOfDayByYera:year andByMonth:month] +1)< 10)
                days = [NSString stringWithFormat:@"%02d",i-[self getTheWeekOfDayByYera:year andByMonth:month]+1];
            else days = [NSString stringWithFormat:@"%02d",i-[self getTheWeekOfDayByYera:year andByMonth:month]+1];
            
            // 农历日期
            SoCalendar *tempCalendar = [[SoCalendar alloc]init];
            tempCalendar.year = year,tempCalendar.month = month,tempCalendar.day = [days integerValue];
            NSDate *date = [tempCalendar nsDate];
            LunarCalendar *lunarCalendar = [date chineseCalendarDate];
            
//             NSString * lunardays = [self getLunarDayByYear:year andMonth:month andDay:(i-[self getTheWeekOfDayByYera:year andByMonth:month]+1)];
            
            // 保存calendar Model数据
            [calendar jbCalendarWithYear:year
                                andMonth:month
                                  andday:[days integerValue]
                              andShowDay:[self getHolidayWithYear:year andMonth:month andDay:(int)[days integerValue]]
                           andLunarMonth:lunarCalendar.MonthLunar
                             andLunarDay:lunarCalendar.DayLunar
                              andHoliday:@""
                               andSeason:lunarCalendar.SolarTermTitle];
            
            [dayArray addObject:days];
            
        }
    }
    return dayArray;
}

//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)getLunarDayArrayByYear:(int) year andMonth:(int) month{
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    NSArray *beformArray =[self getSimpleLunarDayArrayByYear:month-1>0?year:year-1 andMonth:month-1>0?month-1:12];
    NSArray *nextArray = [self getSimpleLunarDayArrayByYear:month+1<13?year:year+1 andMonth:month+1<13?month+1:1];
    for (int i = 0; i< 42; i++) {
        if (i < [self getTheWeekOfDayByYera:year andByMonth:month]) {
            [dayArray addObject:beformArray[beformArray.count-1-[self getTheWeekOfDayByYera:year andByMonth:month]+(i+1)]];
        }else if ((i>[self getTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self getTheWeekOfDayByYera:year andByMonth:month]+[self getNumberOfDayByYera:year andByMonth:month])){
            NSString * days = [self getLunarDayByYear:year andMonth:month andDay:(i-[self getTheWeekOfDayByYera:year andByMonth:month]+1)];
            [dayArray addObject:days];
        }else {
            [dayArray addObject:nextArray[i-[self getTheWeekOfDayByYera:year andByMonth:month]-[self getNumberOfDayByYera:year andByMonth:month]]];
        }
    }
    return dayArray;
}

//获取指定年份指定月份的星期排列表(农历：不带空隔)
+(NSArray *)getSimpleLunarDayArrayByYear:(int) year andMonth:(int) month {
    NSMutableArray * dayArray = [[NSMutableArray alloc]init];
    for (int i = 0; i< 42; i++) {
       if ((i>[self getTheWeekOfDayByYera:year andByMonth:month]-1)&&(i<[self getTheWeekOfDayByYera:year andByMonth:month]+[self getNumberOfDayByYera:year andByMonth:month])) {
            NSString * days = [self getLunarDayByYear:year andMonth:month andDay:(i-[self getTheWeekOfDayByYera:year andByMonth:month]+1)];
            [dayArray addObject:days];
        }
    }
    return dayArray;
}

//获取某年某月某日的对应农历日
+(NSString *)getLunarDayByYear:(int) year
                      andMonth:(int) month
                        andDay:(int) day {
    SoCalendar* date = [[SoCalendar alloc]init];
    date.year = year,date.month = month,date.day = day;
    LunarCalendar *lunarCalendar = [[date nsDate] chineseCalendarDate];
    if(![lunarCalendar.SolarTermTitle isEqualToString:@""])
        return [NSString stringWithString:lunarCalendar.SolarTermTitle];
    if([lunarCalendar.DayLunar isEqualToString:@"初一"])
        return [NSString stringWithString:lunarCalendar.MonthLunar];
    NSString * lunarday = [[NSString alloc]initWithString:lunarCalendar.DayLunar];
    
    return lunarday;
}


//计算year年month月第一天是星期几，周日则为0
+(int)getTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month{
    int numWeek = ((year-1)+ (year-1)/4-(year-1)/100+(year-1)/400+1)%7;//numWeek为years年的第一天是星期几
    //NSLog(@"%d",numWeek);
    int ar[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    int numdays = (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))?(ar[month-1]+1):(ar[month-1]);
    //numdays为month月years年的第一天是这一年的第几天
    //NSLog(@"%d",numdays);
    int dayweek = (numdays%7 + numWeek)%7;//month月第一天是星期几，周日则为0
    //NSLog(@"%d",dayweek);
    return dayweek;
}

//判断year年month月有多少天
+(int)getNumberOfDayByYera:(int)year
                andByMonth:(int)month{
    int nummonth = 0;
    //判断month月有多少天
    if ((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
        nummonth = 31;
    else if ((month == 4)|| (month == 6)||(month == 9)||(month == 11))
        nummonth = 30;
    else if (((year/4==0&&year/100!=0)||(year/400==0))&&(month>2))
        nummonth = 29;
    else nummonth = 28;
    return nummonth;
}
// 此月共多少天
+(int)sunDayWithYear:(int)year andMonth:(int)month{
    SoCalendar *calendar = [[SoCalendar alloc]init];
    calendar.year = year;
    calendar.month = month;
    calendar.day = 1;
    NSDate *date = [calendar nsDate];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    dateComponents.day = 1;
    NSDate *nextMontFirDay = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSDateComponents *lastComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:nextMontFirDay];
    lastComponents.day = -1;
    NSDate *lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:lastComponents toDate:nextMontFirDay options:NSCalendarWrapComponents];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    return (int)[[formatter stringFromDate:lastDate] integerValue];
}

//所有年列表
+(NSArray *)getAllYearArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1901; i<2050; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//所有月列表
+(NSArray *)getAllMonthArray{
    NSMutableArray * monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i<13; i++) {
        NSString * days = [[NSString alloc]initWithFormat:@"%d",i];
        [monthArray addObject:days];
    }
    return monthArray;
}

//所有星期
+(NSArray *)getAllWeekArray
{
    return @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六"];
}

//获取节日
+(NSString *)getHolidayWithYear:(int)year andMonth:(int)month andDay:(int)day
{
    SoCalendar *tempCal = [[SoCalendar alloc]init];
    tempCal.year = year;
    tempCal.month = month;
    tempCal.day = day;
    NSDate *ludate = [tempCal nsDate];
    LunarCalendar *lunarCal = [ludate chineseCalendarDate];
    NSString *lunarString = [NSString stringWithFormat:@"%@%@",lunarCal.MonthLunar,lunarCal.DayLunar];
    NSString *holiday = @"";
    if (month == 1 && day == 1) {
        holiday = @"元旦";
    }else if([lunarString isEqualToString:@"正月初一"]){
        holiday = @"春节";
    }else if([lunarString isEqualToString:@"正月十五"]){
        holiday = @"元宵节";
    }else if(month == 2 && day == 14)
        holiday = @"情人节";
    else if(month == 3 && day == 8)
        holiday = @"妇女节";
    else if(month == 3 && day == 12)
        holiday = @"植树节";
    else if(month == 3 && day == 15)
        holiday = @"消费者权益日";
    else if(month == 3 && day == 21)
        holiday = @"世界睡眠日";
    else if(month == 3 && day == 22)
        holiday = @"世界水日";
    else if(month == 4 && day == 1)
        holiday = @"愚人节";
    else if(month == 4 && day == 5)
        holiday = @"清明节";
    else if(month == 5 && day == 1){
        holiday = @"劳动节";
    }else if(month == 5 && day == 4){
        holiday = @"青年节";
    }else if(month == 5 && day == 111){
        holiday = @"母亲节";
    }else if(month == 5 && day == 12){
        holiday = @"护士节";
    }else if(month == 5 && day == 17){
        holiday = @"世界电信日";
    }else if(month == 6 && day == 1){
        holiday = @"儿童节";
    }else if(month == 6 && day == 111){
        holiday = @"父亲节";
    }else if([lunarString isEqualToString:@"五月初五"]){
        holiday = @"端午节";
    }else if(month == 7 && day == 1){
        holiday = @"建党&香港回归";
    }else if(month == 8 && day == 1){
        holiday = @"建军节";
    }else if([lunarString isEqualToString:@"七月初七"]){
        holiday = @"七夕情人节";
    }else if(month == 9 && day == 3){
        holiday = @"抗战胜利纪念日";
    }else if(month == 9 && day == 10){
        holiday = @"教师节";
    }else if(month == 9 && day == 18){
        holiday = @"九一八事变纪念日";
    }else if(month == 9 && day == 27){
        holiday = @"世界旅游日";
    }else if([lunarString isEqualToString:@"八月十五"]){
        holiday = @"中秋节";
    }else if(month == 10 && day == 1){
        holiday = @"国庆节";
    }else if([lunarString isEqualToString:@"九月初九"]){
        holiday = @"重阳节";
    }else if(month == 12 && day == 1){
        holiday = @"爱滋病日";
    }else if(month == 12 && day == 20){
        holiday = @"澳门回归纪念日";
    }else if(month == 12 && day == 25){
        holiday = @"圣诞节";
    }else if([lunarString isEqualToString:@"腊月三十"]){
        holiday = @"除夕";
    }
    else
        return [NSString stringWithFormat:@"%02d",day];
    
    
    
    return holiday;
}



@end
