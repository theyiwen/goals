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

static CGFloat const kDaysPerRow = 7;

@interface YNCCalendarView()

@property (nonatomic) CGFloat calendarWidth;
@property (nonatomic) CGFloat boxWidth;
@property (strong, nonatomic) NSMutableArray *boxes;
@property (nonatomic) BOOL initialLayersDrawn;
@property (strong, nonatomic) CALayer *container;
@property (strong, nonatomic) NSMutableArray *circleDays;
@property (strong, nonatomic) NSMutableDictionary *ringDays;
@property (strong, nonatomic) NSDictionary *userColors;
@property (strong, nonatomic) YNCGoal *goal;
@property (nonatomic) NSInteger todayInDays;

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
    [self drawInitial];
    self.initialLayersDrawn = YES;
  }
}

- (void)setLogs:(NSArray *)logs {
  _logs = logs;
  [self processLogs];
}

- (void)processLogs {
  self.circleDays = [[NSMutableArray alloc] init];
  self.ringDays = [[NSMutableDictionary alloc] init];
  for (YNCLog *log in self.logs) {
    NSNumber *dayNumber = @([self dayNumberFromDate:log.date]);
    if ([log.user.pfID isEqual:[PFUser currentUser].objectId]) {
      [self.circleDays addObject:dayNumber];
    } else {
      if (self.ringDays[log.user.pfID]) {
        [(NSMutableArray *)self.ringDays[log.user.pfID] addObject:dayNumber];
      } else {
        self.ringDays[log.user.pfID] = [[NSMutableArray alloc] initWithObjects:dayNumber, nil];
      }
    }
  }
  [self insertCircles];
}

- (void)drawInitial {
  self.container = [CALayer layer];
  self.container.bounds = self.bounds;
  self.container.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
  self.container.masksToBounds = YES;
  
  [self.layer addSublayer:self.container];
  
  self.boxWidth = self.container.bounds.size.width / kDaysPerRow;

  self.boxes = [[NSMutableArray alloc] init];
  CGFloat n = self.boxWidth;
  CGFloat r = self.boxWidth / 2;
  CGFloat y = 0;
  CGFloat circle_n = round(self.boxWidth - 10);
  CGFloat numRows = ceilf([self.goal.duration floatValue] / kDaysPerRow);
  int date = 1;
  for (int row = 1; row <= numRows; row++) {
    CGFloat x = 0;
    for (int col = 1; col <= kDaysPerRow; col++) {
      if (date > [self.goal.duration intValue]) {
        break;
      }
      CAShapeLayer *boxContainer = [CAShapeLayer layer];
      boxContainer.position = CGPointMake(x + r, y + r);
      boxContainer.bounds = CGRectMake(0, 0, self.boxWidth, self.boxWidth);
      
      CAShapeLayer *box = [CAShapeLayer layer];
      box.bounds = boxContainer.bounds;
      box.position = CGPointMake(r, r);
      box.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, n, n)].CGPath;
      box.fillColor = [UIColor whiteColor].CGColor;
      box.masksToBounds = YES;
      
      NSString *dateStr = [NSString stringWithFormat:@"%d", date];
      UIFont *font = [UIFont fontWithName:[YNCFont lightFontName] size:25];
      CGRect labelRect = [dateStr boundingRectWithSize:boxContainer.bounds.size
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{ NSFontAttributeName :  font}
                                            context:nil];

      CATextLayer *day = [CATextLayer layer];
      day.frame = labelRect;
      day.position = CGPointMake(r, r);
      [day setFont:(__bridge CFTypeRef)([YNCFont lightFontName])];
      [day setFontSize:25];
      [day setAlignmentMode:kCAAlignmentCenter];
      day.contentsScale = [[UIScreen mainScreen] scale];
      if (date > self.todayInDays + 1) {
        [day setForegroundColor:[UIColor lightGrayColor].CGColor];
      } else {
        [day setForegroundColor:[UIColor blackColor].CGColor];
      }
      [day setString:dateStr];
      
      CAShapeLayer *circle;
      if ([self.circleDays containsObject:@(date)]) {
        circle = [CAShapeLayer layer];
        circle.bounds = CGRectMake(0, 0, circle_n, circle_n);
        circle.position = CGPointMake(r, r);
    
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_n, circle_n)
                                                 cornerRadius:circle_n/2].CGPath;
        circle.fillColor = [YNCColor tealColor].CGColor;
        circle.masksToBounds = YES;
        circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
        circle.shouldRasterize = YES;
        [day setForegroundColor:[UIColor whiteColor].CGColor];
      }
      
      [boxContainer addSublayer:box];
      if (circle) {
        [boxContainer addSublayer:circle];
      }
      [boxContainer addSublayer:day];
      [self.boxes addObject:boxContainer];

      x = x + n;
      date = date + 1;
    }
    y = y + n;
  }
  
  for (CAShapeLayer *box in self.boxes) {
    [self.container addSublayer:box];
  }
}

- (void)insertCircles {
  CGFloat circle_n = round(self.boxWidth - 10);
  CGFloat circle_outer_n = round(self.boxWidth - 7);

  CGFloat r = self.boxWidth / 2;
  for (NSNumber *number in self.circleDays) {
    CAShapeLayer *box = self.boxes[[number integerValue]];
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.bounds = CGRectMake(0, 0, circle_n, circle_n);
    circle.position = CGPointMake(r, r);
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_n, circle_n)
                                             cornerRadius:circle_n/2].CGPath;
    circle.fillColor = [YNCColor tealColor].CGColor;
    circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    circle.shouldRasterize = YES;
    [box insertSublayer:circle atIndex:1];
    [box.sublayers[2] setForegroundColor:[UIColor whiteColor].CGColor];
  }
  for (NSString *userID in self.ringDays) {
    for (NSNumber *number in self.ringDays[userID]) {
      CAShapeLayer *box = self.boxes[[number integerValue]];
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
  NSDate *start = self.goal.startDate;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                             fromDate:start
                                               toDate:date
                                              options:0];
  return components.day;
}

@end
