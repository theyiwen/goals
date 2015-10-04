//
//  YNCDate.h
//  Goals
//
//  Created by Yiwen Zhan on 10/4/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YNCDate : NSObject

@property (strong, nonatomic, readonly) NSDateFormatter *monthDayFormatter;
@property (strong, nonatomic, readonly) NSDateFormatter *monthDayYearFormatter;

+ (YNCDate *)shared;

- (NSDateFormatter *)monthDayFormatter;
- (NSTimeZone *)userTimeZone;
- (NSDate *)localDateFromUTC:(NSDate *)utcDate;
- (NSDate *)startDateLocalFromStartDateUTC:(NSDate *)startDateUTC;
- (NSInteger)dayNumberFromDate:(NSDate *)currentDate start:(NSDate *)startDate;

@end
