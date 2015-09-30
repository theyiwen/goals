//
//  YNCCalendarView.h
//  Goals
//
//  Created by Yiwen Zhan on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNCGoal.h"

@protocol YNCCalendarViewDelegate;

@interface YNCCalendarView : UIView

@property (weak, nonatomic) id<YNCCalendarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                         goal:(YNCGoal *)goal
                         logs:(NSArray *)logs
                   userColors:(NSDictionary *)userColors;

@property (strong, nonatomic) NSArray *logs;

@end

@protocol YNCCalendarViewDelegate

- (void)calendarView:(YNCCalendarView *)calendarView didSelectDate:(NSDate *)date;
- (void)calendarView:(YNCCalendarView *)calendarView didUpdateHeight:(CGFloat)height;

@end
