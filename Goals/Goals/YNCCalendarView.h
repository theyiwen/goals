//
//  YNCCalendarView.h
//  Goals
//
//  Created by Yiwen Zhan on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNCGoal.h"

@interface YNCCalendarView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                         goal:(YNCGoal *)goal
                         logs:(NSArray *)logs;

@property (strong, nonatomic) NSArray *logs;
@end
