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

@property (strong, nonatomic) CAShapeLayer *box;
@property (strong, nonatomic) CAShapeLayer *circle;
@property (strong, nonatomic) CAShapeLayer *ring;
@property (strong, nonatomic) CATextLayer *dayText;
@property (nonatomic) CGFloat width;

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
    CGFloat r = self.width / 2;
    CGFloat circle_n = round(self.width - 10);
    CGFloat circle_outer_n = round(self.width - 7);
    CAShapeLayer *boxContainer = [CAShapeLayer layer];
    boxContainer.position = CGPointMake(r, r);
    boxContainer.bounds = CGRectMake(0, 0, self.width, self.width);
    
    CAShapeLayer *box = self.box;
    box.bounds = boxContainer.bounds;
    box.position = CGPointMake(r, r);
    box.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, n, n)].CGPath;
    box.fillColor = [UIColor whiteColor].CGColor;
    box.masksToBounds = YES;
    
    NSString *dateStr = [NSString stringWithFormat:@"%ld", (long)day];
    UIFont *font = [UIFont fontWithName:[YNCFont lightFontName] size:25];
    CGRect labelRect = [dateStr boundingRectWithSize:boxContainer.bounds.size
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName :  font}
                                             context:nil];
    
    CATextLayer *dayText = self.dayText;
    dayText.frame = labelRect;
    dayText.position = CGPointMake(r, r);
    [dayText setFont:(__bridge CFTypeRef)([YNCFont lightFontName])];
    [dayText setFontSize:25];
    [dayText setAlignmentMode:kCAAlignmentCenter];
    dayText.contentsScale = [[UIScreen mainScreen] scale];
    [dayText setString:dateStr];
    
    CAShapeLayer *circle = self.circle;
    circle.bounds = CGRectMake(0, 0, circle_n, circle_n);
    circle.position = CGPointMake(r, r);
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_n, circle_n)
                                             cornerRadius:circle_n/2].CGPath;
    circle.masksToBounds = YES;
    circle.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    circle.shouldRasterize = YES;
    [dayText setForegroundColor:[UIColor whiteColor].CGColor];
    
    CAShapeLayer *ring = self.ring;
    ring.bounds = CGRectMake(0, 0, circle_outer_n, circle_outer_n);
    ring.position = CGPointMake(r, r);
    ring.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circle_outer_n, circle_outer_n)
                                             cornerRadius:circle_outer_n/2].CGPath;
    ring.fillColor = [UIColor clearColor].CGColor;
    ring.lineWidth = 3;
    ring.rasterizationScale = 2.0 * [UIScreen mainScreen].scale;
    ring.shouldRasterize = YES;
    
    [boxContainer addSublayer:box];
    [boxContainer addSublayer:ring];
    [boxContainer addSublayer:circle];
    [boxContainer addSublayer:dayText];
    [self.layer addSublayer:boxContainer];
    
    // defaults
    circle.hidden = YES;
    ring.hidden = YES;
  }
  return self;
}

- (void)setCircleSolidColor:(UIColor *)color {
  self.circle.fillColor = color.CGColor;
  self.circle.hidden = NO;
}

- (void)setCircleOutlineColor:(UIColor *)color {
  self.ring.fillColor = color.CGColor;
  self.ring.hidden = NO;
}

- (void)setDayTextColor:(UIColor *)color {
  [self.dayText setForegroundColor:color.CGColor];
}

@end
