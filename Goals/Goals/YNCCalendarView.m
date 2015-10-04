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
@property (strong, nonatomic) NSMutableDictionary *ringDays;
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
//      NSLog(@"adding %ld to circle days", (long)log.dayNumber);
      [self.circleDays addObject:dayNumber];
    } else {
      if (self.ringDays[log.user.pfID]) {
        [(NSMutableArray *)self.ringDays[log.user.pfID] addObject:dayNumber];
      } else {
        self.ringDays[log.user.pfID] = [[NSMutableArray alloc] initWithObjects:dayNumber, nil];
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
  for (NSString *userID in self.ringDays) {
    for (NSNumber *number in self.ringDays[userID]) {
      YNCCalendarDayView *view = self.boxes[number];
      [view setCircleOutlineColor:(UIColor *)self.userColors[userID]];
    }
  }
}

- (void)insertCircles {
  CGFloat circle_n = round(self.boxWidth - 10);
  CGFloat circle_outer_n = round(self.boxWidth - 7);

  CGFloat r = self.boxWidth / 2;
  for (NSNumber *number in self.circleDays) {
    CAShapeLayer *box = (CAShapeLayer *)((UIView *)self.boxes[number]).layer;
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.bounds = CGRectMake(0, 0, circle_n, circle_n);
    circle.position = CGPointMake(r, r);
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_n, circle_n)
                                             cornerRadius:circle_n/2].CGPath;
    circle.fillColor = [YNCColor tealColor].CGColor;
    circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    circle.shouldRasterize = YES;
    [box insertSublayer:circle atIndex:1];
    [(CATextLayer *)box.sublayers[2] setForegroundColor:[UIColor whiteColor].CGColor];
  }
  for (NSString *userID in self.ringDays) {
    for (NSNumber *number in self.ringDays[userID]) {
      CAShapeLayer *box = self.boxes[number];
      CAShapeLayer *circle = [CAShapeLayer layer];
      circle.bounds = CGRectMake(0, 0, circle_outer_n, circle_outer_n);
      circle.position = CGPointMake(r, r);
      circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_outer_n, circle_outer_n)
                                               cornerRadius:circle_outer_n/2].CGPath;
      circle.strokeColor = ((UIColor *)self.userColors[userID]).CGColor;
      circle.fillColor = [UIColor clearColor].CGColor;
      circle.lineWidth = 3;
      circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
      circle.shouldRasterize = YES;
      [box insertSublayer:circle atIndex:1];
    }
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
