//
//  YNCCalendarDayView.h
//  Goals
//
//  Created by Yiwen Zhan on 9/29/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCCalendarDayView : UIView

- (instancetype)initWithFrame:(CGRect)frame day:(NSInteger)day;
- (void)setCircleSolidColor:(UIColor *)color;
- (void)setCircleOutlineColor:(UIColor *)color;
- (void)setDayTextColor:(UIColor *)color;
- (void)setRingColors:(NSArray *)colors;

@end
