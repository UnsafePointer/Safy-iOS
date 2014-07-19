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

static int const kMaxGraphLenght = 12;

typedef NS_ENUM(NSInteger, SAFChartType) {
    SAFChartTypeSeconds,
    SAFChartTypeMinutes,
    SAFChartTypeHours,
    SAFChartTypeDays,
    SAFChartTypeMonths,
    SAFChartTypeYears
};

#pragma mark - View controller life cycle

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
    lineChartData.color = [UIColor colorWithHexString:@"#FF5E3A"];
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
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    NSArray *iterable;
    if (self.safy.times.count >= kMaxGraphLenght) {
        iterable = [self.safy.times objectsAtIndexes:[NSIndexSet
                                                      indexSetWithIndexesInRange:
                                                      NSMakeRange(self.safy.times.count - kMaxGraphLenght, kMaxGraphLenght)]];
    } else {
        iterable = [self.safy.times array];
    }
    for (SAFTime *time in iterable) {
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
    [dateFormatter setDateFormat:@"MM-dd-yy"];
    NSArray *iterable;
    if (self.safy.times.count >= kMaxGraphLenght) {
        iterable = [self.safy.times objectsAtIndexes:[NSIndexSet
                                                      indexSetWithIndexesInRange:
                                                      NSMakeRange(self.safy.times.count - kMaxGraphLenght, kMaxGraphLenght)]];
    } else {
        iterable = [self.safy.times array];
    }
    for (SAFTime *time in iterable) {
        [XLabels addObject:[dateFormatter stringFromDate:time.endDate]];
    }
    return [XLabels copy];
}

@end
