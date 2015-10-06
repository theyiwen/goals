//
//  YNCGoalUserView.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNCUser.h"

static CGFloat const kYNCGoalUserViewWidth = 45;

@interface YNCGoalUserView : UIView

@property (strong, nonatomic) NSNumber *score;

- (instancetype)initWithUser:(YNCUser *)user color:(UIColor *)color;
- (void)setColor:(UIColor *)color;
- (void)setUser:(YNCUser *)user;
@end
