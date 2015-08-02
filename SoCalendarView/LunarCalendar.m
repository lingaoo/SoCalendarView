//
//  LunarCalendar.m
//  LearnCalendar
//
//  Created by soso on 15/6/12.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "LunarCalendar.h"
//数组存入阴历1900年到2100年每年中的月天数信息，
//阴历每月只能是29或30天，一年用12（或13）个二进制位表示，对应位为1表30天，否则为29天
int LunarCalendarInfo[] = {
    0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
	0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
	0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
	0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
	0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
    
	0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
	0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
	0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b6a0,0x195a6,
	0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
	0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x055c0,0x0ab60,0x096d5,0x092e0,
    
	0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
	0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
	0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
	0x05aa0,0x076a3,0x096d0,0x04bd7,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
	0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
    
    0x04b63,0x0937f,0x049f8,0x04970,0x064b0,0x068a6,0x0ea5f,0x06b20,0x0a6c4,0x0aaef,
    0x092e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
    0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
    0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x04b55,0x04b6f,0x0a570,0x054e4,0x0d260,
    0x0e968,0x0d520,0x0daa0,0x06aa6,0x056df,0x04ae0,0x0a9d4,0x0a4d0,0x0d150,0x0f252,
    0x0d520};

@implementation LunarCalendar

-(id)init
{
	HeavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
	EarthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
	LunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
	
	SolarTerms = [NSArray arrayWithObjects:@"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", @"小寒", @"大寒", nil];
	
	arrayMonth = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
	
	arrayDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
	
    arrayHoliday = [NSArray arrayWithObjects:@"元旦",@"春节",@"元宵节",@"情人节",@"国际妇女节",@"植树节",@"国际消费者权益日",@"世界睡眠日",@"世界水日",@"愚人节",@"清明节",@"国际劳动节",@"青年节",@"母亲节",@"护士节",@"国际儿童节",@"端午节",@"建党纪念日",@"香港回归纪念日",@"建军节",@"七夕情人节",@"教师节",@"九一八事变纪念日",@"世界旅游日",@"中秋节",@"国庆节",@"重阳节",@"世界爱滋病日",@"澳门回归纪念日",@"圣诞节",@"除夕", nil];
    
	return self;
}

-(void)loadWithDate:(NSDate *)adate
{
	if (adate == nil)
		[self loadWithDate:[NSDate date]];
	else
	{
		HeavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
        EarthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
        LunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
        
        SolarTerms = [NSArray arrayWithObjects:@"立春", @"雨水", @"惊蛰", @"春分", @"清明", @"谷雨", @"立夏", @"小满", @"芒种", @"夏至", @"小暑", @"大暑", @"立秋", @"处暑", @"白露", @"秋分", @"寒露", @"霜降", @"立冬", @"小雪", @"大雪", @"冬至", @"小寒", @"大寒", nil];
        
        arrayMonth = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
        
        arrayDay = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		[dateFormatter setDateFormat:@"yyyy"];
		year = [[dateFormatter stringFromDate:adate] intValue];
		
		[dateFormatter setDateFormat:@"MM"];
		month = [[dateFormatter stringFromDate:adate] intValue];
		
		[dateFormatter setDateFormat:@"dd"];
		day = [[dateFormatter stringFromDate:adate] intValue];
						
		thisdate = adate;
	}
}

-(void)InitializeValue
{
	NSString *start = @"1900-01-31";
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *end = [dateFormatter stringFromDate:thisdate];
	
	NSDateFormatter *f = [[NSDateFormatter alloc] init];
	[f setDateFormat:@"yyyy-MM-dd"];
	NSDate *startDate = [f dateFromString:start];
	NSDate *endDate = [f dateFromString:end];
	
	NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
	NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:startDate toDate:endDate options:0];
	
	int dayCyclical=(int)(([components day] + 30)/(86400/(3600*24)))+10;

	int sumdays = (int)[components day];
		
	int tempdays = 0;

	//计算农历年
	for (lunarYear = 1900; lunarYear < 2100 && sumdays > 0; lunarYear++)
	{
		tempdays = [self LunarYearDays:lunarYear];
		sumdays -= tempdays;
	}
	
	if (sumdays < 0)
	{
		sumdays += tempdays;
		lunarYear--;
	}
	
	//计算闰月
	doubleMonth = [self DoubleMonth:lunarYear];
	isLeap = false;
	
	//计算农历月
	for (lunarMonth = 1; lunarMonth < 13 && sumdays > 0; lunarMonth++)
	{
		//闰月
		if (doubleMonth > 0 && lunarMonth == (doubleMonth + 1) && isLeap == false)
		{
			--lunarMonth;
			isLeap = true;
			tempdays = [self DoubleMonthDays:lunarYear];
		}
		else
		{
			tempdays = [self MonthDays:lunarYear:lunarMonth];
		}
		
		//解除闰月
		if (isLeap == true && lunarMonth == (doubleMonth + 1))
		{
			isLeap = false;
		}
		sumdays -= tempdays;
	}
	
	//计算农历日
	if (sumdays == 0 && doubleMonth > 0 && lunarMonth == doubleMonth + 1)
	{
		if (isLeap)
		{
			isLeap = false;
		}
		else
		{
			isLeap = true;
			--lunarMonth;
		}
	}
	
	if (sumdays < 0)
	{
		sumdays += tempdays;
		--lunarMonth;
	}
	
	lunarDay = sumdays + 1;
	
	//计算节气
	[self ComputeSolarTerm];
	
	solarTermTitle = @"";
	for (int i=0; i<2; i++)
	{
		NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
		
		[currentFormatter setDateFormat:@"yyyyMMdd"];
		
		if (solarTerm[i].solarDate == [[currentFormatter stringFromDate:thisdate] intValue])
			solarTermTitle = solarTerm[i].solarName;
	}

	monthLunar = (NSString *)[arrayMonth objectAtIndex:(lunarMonth - 1)];
	dayLunar = (NSString *)[arrayDay objectAtIndex:(lunarDay - 1)];
	zodiacLunar = (NSString *)[LunarZodiac objectAtIndex:((lunarYear - 4) % 60 % 12)];
	
	yearHeavenlyStem = (NSString *)[HeavenlyStems objectAtIndex:((lunarYear - 4) % 60 % 10)];
	if ((((year-1900)*12+month+13)%10) == 0)
		monthHeavenlyStem = (NSString *)[HeavenlyStems objectAtIndex:9];
	else
		monthHeavenlyStem = (NSString *)[HeavenlyStems objectAtIndex:(((year-1900)*12+month+13)%10-1)];

	dayHeavenlyStem = (NSString *)[HeavenlyStems objectAtIndex:(dayCyclical%10)];
	
	yearEarthlyBranch = (NSString *)[EarthlyBranches objectAtIndex:((lunarYear - 4) % 60 % 12)];
	if ((((year-1900)*12+month+13)%12) == 0)
		monthEarthlyBranch = (NSString *)[EarthlyBranches objectAtIndex:11];
	else
		monthEarthlyBranch = (NSString *)[EarthlyBranches objectAtIndex:(((year-1900)*12+month+13)%12-1)];
	dayEarthlyBranch = (NSString *)[EarthlyBranches objectAtIndex:(dayCyclical%12)];
}

-(int)LunarYearDays:(int)y
{
	int i, sum = 348;
	for (i = 0x8000; i > 0x8; i >>= 1)
	{
		if ((LunarCalendarInfo[y - 1900] & i) != 0)
			sum += 1;
	}
	return (sum + [self DoubleMonthDays:y]);
}

-(int)DoubleMonth:(int)y
{
	return (LunarCalendarInfo[y - 1900] & 0xf);
}

///返回农历年闰月的天数
-(int)DoubleMonthDays:(int)y
{
	if ([self DoubleMonth:y] != 0)
		return (((LunarCalendarInfo[y - 1900] & 0x10000) != 0) ? 30 : 29);
	else
		return (0);
}

///返回农历年月份的总天数
-(int)MonthDays:(int)y :(int)m
{
	return (((LunarCalendarInfo[y - 1900] & (0x10000 >> m)) != 0) ? 30 : 29);
}

-(void)ComputeSolarTerm
{
	for (int n = month * 2 - 1; n <= month * 2; n++)
	{
		double Termdays = [self Term:year:n:YES];
		double mdays = [self AntiDayDifference:year:floor(Termdays)];
		//double sm1 = floor(mdays / 100);
		int hour = (int)floor((double)[self Tail:Termdays] * 24);
		int minute = (int)floor((double)([self Tail:Termdays] * 24 - hour) * 60);
		int tMonth = (int)ceil((double)n / 2);
		int tday = (int)mdays % 100;
		
		if (n >= 3)
			solarTerm[n - month * 2 + 1].solarName = [SolarTerms objectAtIndex:(n - 3)];
		else
			solarTerm[n - month * 2 + 1].solarName = [SolarTerms objectAtIndex:(n + 21)];
		
		NSDateComponents *components = [[NSDateComponents alloc] init];
		[components setYear:year];
		[components setMonth:tMonth]; 
		[components setDay:tday];
		[components setHour:hour];
		[components setMinute:minute];

		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		NSDate *ldate = [gregorian dateFromComponents:components];
		

		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setDateFormat:@"yyyyMMdd"];
				
		solarTerm[n - month * 2 + 1].solarDate = [[dateFormatter stringFromDate:ldate] intValue];
	}
}

-(double)Tail:(double)x
{
	return x - floor(x);
}

-(double)Term:(int)y :(int)n :(bool)pd
{
	//儒略日
	double juD = y * (365.2423112 - 6.4e-14 * (y - 100) * (y - 100) - 3.047e-8 * (y - 100)) + 15.218427 * n + 1721050.71301;
	
	//角度
	double tht = 3e-4 * y - 0.372781384 - 0.2617913325 * n;
	
	//年差实均数
	double yrD = (1.945 * sin(tht) - 0.01206 * sin(2 * tht)) * (1.048994 - 2.583e-5 * y);
	
	//朔差实均数
	double shuoD = -18e-4 * sin(2.313908653 * y - 0.439822951 - 3.0443 * n);
	
	double vs = (pd) ? (juD + yrD + shuoD - [self EquivalentStandardDay:y:1:0] - 1721425) : (juD - [self EquivalentStandardDay:y:1:0] - 1721425);
	return vs;
}

-(double)AntiDayDifference:(int)y :(double)x
{
	int m = 1;
	for (int j = 1; j <= 12; j++)
	{
		int mL = [self DayDifference:y:(j+1):1] - [self DayDifference:y:j:1];
		if (x <= mL || j == 12)
		{
			m = j;
			break;
		}
		else
			x -= mL;
	}
	return 100 * m + x;
}

-(double)EquivalentStandardDay:(int)y :(int)m :(int)d
{
	//Julian的等效标准天数
	double v = (y - 1) * 365 + floor((double)((y - 1) / 4)) + [self DayDifference:y:m:d] - 2;
	
	if (y > 1582)
	{//Gregorian的等效标准天数
		v += -floor((double)((y - 1) / 100)) + floor((double)((y - 1) / 400)) + 2; 
	} 
	return v;
}

-(int)DayDifference:(int)y :(int)m :(int)d
{
	int ifG = [self IfGregorian:y:m:d:1];
	//NSArray *monL = [NSArray arrayWithObjects:, nil];
	NSInteger monL[] = {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	if (ifG == 1)
	{
		if ((y % 100 != 0 && y % 4 == 0) || (y % 400 == 0))
			monL[2] += 1;
		else
		{
			if (y % 4 == 0)
				monL[2] += 1;
		}
	}

	int v = 0;
	
	for (int i = 0; i <= m - 1; i++)
		v += monL[i];

	v += d;
	if (y == 1582)
	{
		if (ifG == 1)
			v -= 10;
		if (ifG == -1)
			v = 0;  //infinity 
	}
	return v;
}

-(int)IfGregorian:(int)y :(int)m :(int)d :(int)opt
{
	if (opt == 1)
	{
		if (y > 1582 || (y == 1582 && m > 10) || (y == 1582 && m == 10 && d > 14))
			return (1);	 //Gregorian
		else
			if (y == 1582 && m == 10 && d >= 5 && d <= 14)
				return (-1);  //空
			else
				return (0);  //Julian
	}
	
	if (opt == 2)
		return (1);	 //Gregorian
	if (opt == 3)
		return (0);	 //Julian
	return (-1);
}

-(NSString *)MonthLunar
{
	return monthLunar;
}

-(NSString *)DayLunar
{
	return dayLunar;
}

-(NSString *)ZodiacLunar
{
	return zodiacLunar;
}

-(NSString *)YearHeavenlyStem
{
	return yearHeavenlyStem;
}

-(NSString *)MonthHeavenlyStem
{
	return monthHeavenlyStem;
}

-(NSString *)DayHeavenlyStem
{
	return dayHeavenlyStem;
}

-(NSString *)YearEarthlyBranch
{
	return yearEarthlyBranch;
}

-(NSString *)MonthEarthlyBranch
{
	return monthEarthlyBranch;
}

-(NSString *)DayEarthlyBranch
{
	return dayEarthlyBranch;
}

-(NSString *)SolarTermTitle
{
	return solarTermTitle;
}

-(bool)IsLeap
{
	return isLeap;
}

-(int)GregorianYear
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	int ret = [[formatter stringFromDate:thisdate] intValue];

	return ret;
}

-(int)GregorianMonth
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM"];
	int ret = [[formatter stringFromDate:thisdate] intValue];

	return ret;
}

-(int)GregorianDay
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"dd"];
	int ret = [[formatter stringFromDate:thisdate] intValue];
	return ret;
}

-(int)Weekday
{
	NSCalendar* cal = [NSCalendar currentCalendar];
	NSDateComponents* weekday = [cal components:NSCalendarUnitWeekday fromDate:thisdate];
	return (int)[weekday weekday];
}

//计算星座
-(NSString *)Constellation
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMdd"];
	int intConstellation = [[formatter stringFromDate:thisdate] intValue];
	
	if (intConstellation >= 120 && intConstellation <= 218)
		return @"Aquarius";
	else if (intConstellation >= 219 && intConstellation <= 320)
		return @"Pisces";
	else if (intConstellation >= 321 && intConstellation <= 420)
		return @"Aries";
	else if (intConstellation >= 421 && intConstellation <= 520)
		return @"Taurus";
	else if (intConstellation >= 521 && intConstellation <= 621)
		return @"Gemini";
	else if (intConstellation >= 622 && intConstellation <= 722)
		return @"Cancer";
	else if (intConstellation >= 723 && intConstellation <= 822)
		return @"Leo";
	else if (intConstellation >= 823 && intConstellation <= 922)
		return @"Virgo";
	else if (intConstellation >= 923 && intConstellation <= 1022)
		return @"Libra";
	else if (intConstellation >= 1023 && intConstellation <= 1121)
		return @"Scorpio";
	else if (intConstellation >= 1122 && intConstellation <= 1221)
		return @"Sagittarius";
	else
		return @"Capricorn";
}

@end


//方法获取农历数具包的方法
@implementation NSDate (LunarCalendar)

/****************************************************
 *@Description:获得NSDate对应的中国日历（农历）的NSDate
 *@Params:nil
 *@Return:NSDate对应的中国日历（农历）的LunarCalendar
 ****************************************************/
- (LunarCalendar *)chineseCalendarDate
{
    LunarCalendar *lunarCalendar = [[LunarCalendar alloc] init];
    [lunarCalendar loadWithDate:self];
    [lunarCalendar InitializeValue];
    return lunarCalendar;
}

@end