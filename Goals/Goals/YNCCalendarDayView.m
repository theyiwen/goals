//
//  YNCCalendarDayView.m
//  Goals
//
//  Created by Yiwen Zhan on 9/29/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCalendarDayView.h"
#import "YNCFont.h"

@interface YNCCalendarDayView ()

@property (strong, nonatomic) CAShapeLayer *boxContainer;
@property (strong, nonatomic) CAShapeLayer *box;
@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) CAShapeLayer *ring;
@property (strong, nonatomic) CATextLayer *dayText;
@property (strong, nonatomic) NSMutableArray *rings;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat circle_n;
@property (nonatomic) CGFloat circle_outer_n;
@property (nonatomic) CGFloat r;

@end

@implementation YNCCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame day:(NSInteger)day {
  if (self = [super initWithFrame:frame]) {
    _width = frame.size.width;
    _box = [CAShapeLayer layer];
    _circle = [CAShapeLayer layer];
    _ring = [CAShapeLayer layer];
    _dayText = [CATextLayer layer];
    
    CGFloat n = self.width;
    self.r = self.width / 2;
    self.circle_n = round(self.width - 10);
    self.circle_outer_n = round(self.width - 7);
    CAShapeLayer *boxContainer = self.boxContainer = [CAShapeLayer layer];
    boxContainer.position = CGPointMake(self.r, self.r);
    boxContainer.bounds = CGRectMake(0, 0, self.width, self.width);
    
    CAShapeLayer *box = self.box;
    box.bounds = boxContainer.bounds;
    box.position = CGPointMake(self.r, self.r);
    box.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, n, n)].CGPath;
    box.fillColor = [UIColor whiteColor].CGColor;
    box.masksToBounds = YES;
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)(day + 1)];
    UIFont *font = [UIFont fontWithName:[YNCFont lightFontName] size:25];
    CGRect labelRect = [dateStr boundingRectWithSize:boxContainer.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName :  font}
                                             context:nil];
    
    CATextLayer *dayText = self.dayText;
    dayText.frame = labelRect;
    dayText.position = CGPointMake(self.r, self.r);
    [dayText setFont:(__bridge CFTypeRef)([YNCFont lightFontName])];
    [dayText setFontSize:25];
    [dayText setAlignmentMode:kCAAlignmentCenter];
    dayText.contentsScale = [[UIScreen mainScreen] scale];
    [dayText setString:dateStr];
    
    CAShapeLayer *circle = self.circle;
    circle.bounds = CGRectMake(0, 0, self.circle_n, self.circle_n);
    circle.position = CGPointMake(self.r, self.r);
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.circle_n, self.circle_n)
                                             cornerRadius:self.circle_n/2].CGPath;
    circle.masksToBounds = YES;
    circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    circle.shouldRasterize = YES;
    [dayText setForegroundColor:[UIColor whiteColor].CGColor];
   
    [boxContainer addSublayer:box];
    [boxContainer addSublayer:circle];
    [boxContainer addSublayer:dayText];
    [self.layer addSublayer:boxContainer];
    
    // defaults
    circle.hidden = YES;
  }
  return self;
}

- (void)setRingColors:(NSArray *)colors {
  if (!self.rings) {
    self.rings = [[NSMutableArray alloc] init];
  }
  if (self.rings.count > 0) {
    for (CAShapeLayer *layer in self.rings) {
      [layer removeFromSuperlayer];
    }
  }
  NSInteger numSegments = colors.count;
  CGFloat startAngle = 0;
  CGFloat segmentArcLength = 2*M_PI/numSegments;
  CGFloat endAngle = segmentArcLength;
  for (int i=0; i < numSegments; i++) {
    CAShapeLayer *segment = [CAShapeLayer layer];
    segment.bounds = CGRectMake(0, 0, self.circle_outer_n, self.circle_outer_n);
    segment.position = CGPointMake(self.r, self.r);
    segment.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.circle_outer_n/2, self.circle_outer_n/2)
                                                  radius:self.circle_outer_n/2
                                              startAngle:startAngle
                                                endAngle:endAngle
                                               clockwise:YES].CGPath;
    segment.fillColor = [UIColor clearColor].CGColor;
    segment.lineWidth = 3;
    segment.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    segment.shouldRasterize = YES;
    segment.strokeColor = ((UIColor *)colors[i]).CGColor;
    [self.boxContainer addSublayer:segment];
    [self.rings addObject:segment];
    startAngle = endAngle;
    endAngle = endAngle + segmentArcLength;
  }
}
- (void)setCircleSolidColor:(UIColor *)color {
  self.circle.fillColor = color.CGColor;
  self.circle.hidden = NO;
}

- (void)setCircleOutlineColor:(UIColor *)color {
  self.ring.strokeColor = color.CGColor;
  self.ring.hidden = NO;
}

- (void)setDayTextColor:(UIColor *)color {
  [self.dayText setForegroundColor:color.CGColor];
}

@end
