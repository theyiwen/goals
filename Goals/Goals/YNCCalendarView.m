//
//  YNCCalendarView.m
//  Goals
//
//  Created by Yiwen Zhan on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCalendarView.h"
#import "YNCFont.h"

@interface YNCCalendarView()

@property (nonatomic) CGFloat calendarWidth;
@property (nonatomic) CGFloat boxWidth;
@property (strong, nonatomic) NSMutableArray *boxes;
@property (nonatomic) BOOL initialLayersDrawn;
@property (strong, nonatomic) CALayer *container;
@property (nonatomic) NSArray *boldDays;

@end
@implementation YNCCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _calendarWidth = frame.size.width;
    _initialLayersDrawn = NO;
    _boldDays = @[@1, @6, @7, @12, @17, @22, @18];
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

- (void)drawInitial {
  self.container = [CALayer layer];
  self.container.bounds = self.bounds;
  self.container.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
  self.container.masksToBounds = YES;
  
  [self.layer addSublayer:self.container];
  
  self.boxWidth = self.container.bounds.size.width / 7;

  self.boxes = [[NSMutableArray alloc] init];
  CGFloat n = self.boxWidth;
  CGFloat r = self.boxWidth / 2;
  CGFloat y = 0;
  CGFloat circle_n = round(self.boxWidth - 10);
  int date = 1;
  for (int row = 1; row <= 4; row++) {
    CGFloat x = 0;
    for (int col = 1; col <= 7; col++) {
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
      [day setForegroundColor:[UIColor blackColor].CGColor];
      [day setString:dateStr];
      
      CAShapeLayer *circle;
      if ([self.boldDays containsObject:@(date)]) {
        circle = [CAShapeLayer layer];
        circle.bounds = CGRectMake(0, 0, circle_n, circle_n);
        circle.position = CGPointMake(r, r);
    
        circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_n, circle_n)
                                                 cornerRadius:circle_n/2].CGPath;
        circle.fillColor = [UIColor blackColor].CGColor;
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

- (void)setCalendarWidth:(CGFloat)calendarWidth {
  _calendarWidth = calendarWidth;
}


@end
