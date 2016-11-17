//
//  ViewController.m
//  SoCalendarViewDemo
//
//  Created by soso on 15/6/17.
//  Copyright (c) 2015年 seebon. All rights reserved.
//

#import "ViewController.h"
#import "ViewController.h"
#import "SoDateTools.h"
#import "SoCalendarView.h"
@interface ViewController ()<SoCalendarViewDelegate>
{
    SoCalendarView *calenarView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        
    calenarView = [[SoCalendarView alloc]initWithSoCalendarViewWithFrame:self.view.frame];
    calenarView.deleagte = self;
    [self.view addSubview:calenarView];
    
}

// SocalendarViewDelegate delegate
-(void)soCalendarView:(SoCalendarView *)calendarView currenCalendarWithYear:(int)year andMonth:(int)month
{
    NSLog(@"%d年%d月",year,month);

}
-(void)soCalendarView:(SoCalendarView *)calendarView selectCalendarDay:(SoCalendar *)calendar
{
    NSLog(@"%@",calendar);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
