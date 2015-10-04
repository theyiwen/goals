//
//  YNCDate.m
//  Goals
//
//  Created by Yiwen Zhan on 10/4/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCDate.h"

@interface YNCDate()

@property (strong, nonatomic, readwrite) NSDateFormatter *monthDayFormatter;
@property (strong, nonatomic, readwrite) NSDateFormatter *monthDayYearFormatter;
@property (strong, nonatomic) NSCalendar *calendar;

@end

@implementation YNCDate

+ (instancetype)shared {
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  if (self = [super init]) {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  }
  return self;
}

- (NSDateFormatter *)monthDayFormatter {
  if (!_monthDayFormatter) {
    _monthDayFormatter = [[NSDateFormatter alloc] init];
    _monthDayFormatter.dateFormat = @"MM/dd";
  }
  return _monthDayFormatter;
}

- (NSDateFormatter *)monthDayYearFormatter {
  if (!_monthDayFormatter) {
    _monthDayFormatter = [[NSDateFormatter alloc] init];
    _monthDayFormatter.dateFormat = @"MM/dd/yyyy";
  }
  return _monthDayFormatter;
}

- (NSTimeZone *)userTimeZone {
  return nil;
}
- (NSDate *)localDateFromUTC:(NSDate *)utcDate {
  return nil;
}

- (NSDate *)startDateLocalFromStartDateUTC:(NSDate *)startDateUTC {
  NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:startDateUTC];
  components.minute = 0;
  components.hour = 0;
  NSDate *localDate = [self.calendar dateFromComponents:components];
  return localDate;
}

- (NSInteger)dayNumberFromDate:(NSDate *)currentDate start:(NSDate *)startDate {
  NSDate *start = [self startDateLocalFromStartDateUTC:startDate];
  NSDateComponents *components = [self.calendar components:NSCalendarUnitDay
                                             fromDate:start
                                               toDate:currentDate
                                              options:0];
  return components.day;
}

@end
