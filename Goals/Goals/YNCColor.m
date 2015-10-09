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
           [UIColor colorWithRed:54/255.0f green:159/255.0f blue:188/255.0f alpha:1.0f],
           [UIColor colorWithRed:46/255.0f green:103/255.0f blue:133/255.0f alpha:1.0f],
           [UIColor colorWithRed:57/255.0f green:161/255.0f blue:172/255.0f alpha:1.0f],
           [UIColor colorWithRed:86/255.0f green:176/255.0f blue:201/255.0f alpha:1.0f],
           ];
}

@end
