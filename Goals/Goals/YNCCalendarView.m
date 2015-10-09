//
//  YNCCalendarView.m
//  Goals
//
//  Created by Yiwen Zhan on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCalendarView.h"
#import "YNCFont.h"
#import "YNCColor.h"
#import "YNCLog.h"
#import "YNCCalendarDayView.h"
#import "YNCDate.h"

static CGFloat const kDaysPerRow = 7;

@interface YNCCalendarView()

@property (nonatomic) CGFloat calendarWidth;
@property (nonatomic) CGFloat boxWidth;
@property (strong, nonatomic) NSMutableDictionary *boxes;
@property (nonatomic) BOOL initialLayersDrawn;
@property (strong, nonatomic) CALayer *container;
@property (strong, nonatomic) NSMutableArray *circleDays;
@property (strong, nonatomic) NSMutableDictionary *ringDays; // { dayNumber: [userIds] }
@property (strong, nonatomic) NSDictionary *userColors;
@property (strong, nonatomic) YNCGoal *goal;
@property (nonatomic) NSInteger todayInDays;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end
@implementation YNCCalendarView

- (instancetype)initWithFrame:(CGRect)frame
                         goal:(YNCGoal *)goal
                         logs:(NSArray *)logs
                   userColors:(NSDictionary *)userColors {
  if (self = [super initWithFrame:frame]) {
    _calendarWidth = frame.size.width;
    _initialLayersDrawn = NO;
    _userColors = userColors;
    _logs = logs;
    _circleDays = [[NSMutableArray alloc] init];
    _goal = goal;
    [self processLogs];
    _todayInDays = [self dayNumberFromDate:[NSDate date]];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (!self.initialLayersDrawn) {
    [self drawInitialViews];
    self.initialLayersDrawn = YES;
  }
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGesture {
  UIView *tappedView = tapGesture.view;
  [self.delegate calendarView:self didSelectDate:[self dateFromDayNumber:tappedView.tag]];
}

- (void)setLogs:(NSArray *)logs {
  _logs = logs;
  [self processLogs];
}

- (void)processLogs {
  self.circleDays = [[NSMutableArray alloc] init];
  self.ringDays = [[NSMutableDictionary alloc] init];
  for (YNCLog *log in self.logs) {
    NSNumber *dayNumber = @(log.dayNumber);
    if ([log.user.pfID isEqual:[PFUser currentUser].objectId]) {
      [self.circleDays addObject:dayNumber];
    } else { // other person
      if (self.ringDays[dayNumber]) {
        [(NSMutableArray *)self.ringDays[dayNumber] addObject:log.user.pfID];
      } else {
        self.ringDays[dayNumber] = [[NSMutableArray alloc] initWithObjects:log.user.pfID, nil];
      }
    }
  }
  [self updateCircles];
}

- (void)drawInitialViews {
  self.boxes = [[NSMutableDictionary alloc] init];
  self.boxWidth = self.bounds.size.width / kDaysPerRow;
  int date = 0;
  CGFloat numRows = ceilf([self.goal.duration floatValue] / kDaysPerRow);
  CGFloat n = self.boxWidth;
  CGFloat y = 0;
  for (int row = 1; row <= numRows; row++) {
    CGFloat x = 0;
    for (int col = 1; col <= kDaysPerRow; col++) {
      if (date >= [self.goal.duration intValue]) {
        break;
      }
      CGRect frame = CGRectMake(x, y, self.boxWidth, self.boxWidth);
      YNCCalendarDayView *view = [[YNCCalendarDayView alloc] initWithFrame:frame day:date];
      view.tag = date;
      if (date > self.todayInDays) {
        [view setDayTextColor:[UIColor lightGrayColor]];
      } else {
        [view setDayTextColor:[UIColor blackColor]];
      }
      UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
      tapGesture.numberOfTapsRequired = 1;
      [view addGestureRecognizer:tapGesture];
      self.boxes[@(date)] = view;
      [self addSubview:view];
      date = date + 1;
      x = x + n;
    }
    y = y + n;
  }
  [self setHeightToFit];
}

- (void)setHeightToFit {
  CGFloat numRows = ceilf([self.goal.duration floatValue] / kDaysPerRow);
  CGFloat height = numRows * self.boxWidth;
  [self.delegate calendarView:self didUpdateHeight:height];
}

- (void)updateCircles {
  for (NSNumber *number in self.circleDays) {
    YNCCalendarDayView *view = self.boxes[number];
    [view setCircleSolidColor:[YNCColor tealColor]];
    [view setDayTextColor:[UIColor whiteColor]];
  }
  for (NSNumber *number in self.ringDays) {
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    YNCCalendarDayView *view = self.boxes[number];
    for (NSString *userId in self.ringDays[number]) {
      if (![colors containsObject:self.userColors[userId]]) {
        [colors addObject:self.userColors[userId]];
      }
    }
    [view setRingColors:[colors copy]];
  }
}

- (void)setCalendarWidth:(CGFloat)calendarWidth {
  _calendarWidth = calendarWidth;
}

- (NSInteger)dayNumberFromDate:(NSDate *)date {
  return [[YNCDate shared] dayNumberFromDate:date start:self.goal.startDate];
}

- (NSDate *)dateFromDayNumber:(NSInteger)dayNumber {
  NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
  dayComponent.day = dayNumber - 1;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  return [calendar dateByAddingComponents:dayComponent toDate:self.goal.startDate options:0];
}

@end
