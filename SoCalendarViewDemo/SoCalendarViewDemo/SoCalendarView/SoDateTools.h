//
//  SoTools.h
//  LearnCalendar
//
//  Created by soso on 15/6/12.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LunarCalendar.h"
#import "SoCalendar.h"
@interface SoDateTools : NSObject
{
    
}
/**指定格式输出日期 eg. dateFormatter:@"yyyy-mm-dd" or @"yyyy" and other */
+(NSString*)currentDate:(NSString*)dateFormatter;

/** 输出某天的前几天的日期 ps."date"的前“day”天 */
+(NSString *)beformDate:(NSString *)date beformDay:(NSInteger)day;

/** 输出当月1号 */
+ (NSString *)firstDayInCurrentMonth;

/** 输出当月月底 */
+ (NSString *)lastDayInCurrentMonth;

/** 返回本星期的第一天，可用于判断是否在同一星期内*/
+(NSDate *)dateStartOfWeek:(NSDate *)date;

/** 此月共多少天 */
+(int)sunDayWithYear:(int)year andMonth:(int)month;

/** YES:start较大 */
+ (BOOL)startDate:(NSString *)startDate biggerThranEndDate:(NSString *)endDate;

//=====================================================================================================//


//获取指定年份指定月份的星期排列表
+(NSArray *)getDayArrayByYear:(int)year andMonth:(int)month;

//获取指定年份指定月份的星期排列表(农历)
+(NSArray *)getLunarDayArrayByYear:(int) year andMonth:(int) month;

//计算year年month月第一天是星期几，周日则为0
+(int)getTheWeekOfDayByYera:(int)year
                 andByMonth:(int)month;

//所有星期
+(NSArray *)getAllWeekArray;
@end
