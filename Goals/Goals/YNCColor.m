//
//  YNCColor.m
//  Goals
//
//  Created by Calvin Lee on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCColor.h"

@implementation YNCColor

+ (UIColor *) tealColor {
  return [UIColor colorWithRed:135.0/255.0f green:202.0/255.0f blue:187.0/255.0f alpha:1.0f];
}

+ (UIColor *) tealHighlightColor {
  return [UIColor colorWithRed:215.0/255.0f green:241.0/255.0f blue:235.0/255.0f alpha:1.0f];
}

+ (NSArray *)userColors {
  
  return @[[YNCColor tealColor],
           [UIColor colorWithRed:161.0/255.0f green:210.0/255.0f blue:216.0/255.0f alpha:1.0f],
           [UIColor colorWithRed:215.0/255.0f green:253.0/255.0f blue:236.0/255.0f alpha:1.0f],
           [UIColor colorWithRed:33.0/255.0f green:137.0/255.0f blue:126.0/255.0f alpha:1.0f],
           [UIColor colorWithRed:59.0/255.0f green:169.0/255.0f blue:156.0/255.0f alpha:1.0f],
           ];
}

@end
