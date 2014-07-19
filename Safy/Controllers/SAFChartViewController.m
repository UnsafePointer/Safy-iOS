//
//  SAFChartViewController.m
//  Safy
//
//  Created by Renzo Crisostomo on 19/07/14.
//  Copyright (c) 2014 Renzo Crisóstomo. All rights reserved.
//

#import "SAFChartViewController.h"
#import "SAFSafy.h"
#import "SAFTime.h"

@interface SAFChartViewController ()

@property (nonatomic, weak) IBOutlet PNLineChart *lineChart;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (NSArray *)generateDataSource;
- (NSCalendarUnit)calendarUnitForSelection;
- (NSInteger)valueForSelection:(NSDateComponents *)dateComponents;
- (IBAction)onSelectChartType:(id)sender;

@end

@implementation SAFChartViewController

typedef NS_ENUM(NSInteger, SAFChartType) {
    SAFChartTypeSeconds,
    SAFChartTypeMinutes,
    SAFChartTypeHours,
    SAFChartTypeDays,
    SAFChartTypeMonths,
    SAFChartTypeYears
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.safy.text;
    [self drawGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (IBAction)onSelectChartType:(id)sender
{
    [self drawGraph];
}

- (void)drawGraph
{
    CGRect frame = self.lineChart.frame;
    PNLineChart *lineChart= [[PNLineChart alloc] initWithFrame:frame];
    [lineChart setXLabels:[self generateXLabels]];
    PNLineChartData *lineChartData = [[PNLineChartData alloc] init];
    lineChartData.color = [UIColor colorWithHexString:@"#FF9500"];
    NSArray *dataSource = [self generateDataSource];
    lineChartData.itemCount = dataSource.count;
    lineChartData.getData = ^(NSUInteger index) {
        CGFloat yValue = [dataSource[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    lineChart.chartData = @[lineChartData];
    [lineChart strokeChart];
    
    [self.lineChart removeFromSuperview];
    [self.view addSubview:lineChart];
    self.lineChart = lineChart;
}

- (NSCalendarUnit)calendarUnitForSelection
{
    SAFChartType chartType = self.segmentedControl.selectedSegmentIndex;
    switch (chartType) {
        case SAFChartTypeSeconds:
            return NSCalendarUnitSecond;
        case SAFChartTypeMinutes:
            return NSCalendarUnitMinute;
        case SAFChartTypeHours:
            return NSCalendarUnitHour;
        case SAFChartTypeDays:
            return NSCalendarUnitDay;
        case SAFChartTypeMonths:
            return NSCalendarUnitMonth;
        case SAFChartTypeYears:
            return NSCalendarUnitYear;
    }
}

- (NSInteger)valueForSelection:(NSDateComponents *)dateComponents
{
    SAFChartType chartType = self.segmentedControl.selectedSegmentIndex;
    switch (chartType) {
        case SAFChartTypeSeconds:
            return [dateComponents second];
        case SAFChartTypeMinutes:
            return [dateComponents minute];
        case SAFChartTypeHours:
            return [dateComponents hour];
        case SAFChartTypeDays:
            return [dateComponents day];
        case SAFChartTypeMonths:
            return [dateComponents month];
        case SAFChartTypeYears:
            return [dateComponents year];
    }
}

- (NSArray *)generateDataSource
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithCapacity:self.safy.times.count];
    [dataSource addObject:@0];
    for (SAFTime *time in self.safy.times) {
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:[self calendarUnitForSelection]
                                                                           fromDate:time.startDate
                                                                             toDate:time.endDate
                                                                            options:0];
        [dataSource addObject:[NSNumber numberWithInt:(int)[self valueForSelection:dateComponents]]];
    }
    return [dataSource copy];
}

- (NSArray *)generateXLabels
{
    NSMutableArray *XLabels = [[NSMutableArray alloc] initWithCapacity:self.safy.times.count];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    SAFTime *firstTime = [self.safy.times objectAtIndex:0];
    [XLabels addObject:[dateFormatter stringFromDate:firstTime.startDate]];
    for (SAFTime *time in self.safy.times) {
        [XLabels addObject:[dateFormatter stringFromDate:time.endDate]];
    }
    return [XLabels copy];
}

@end
