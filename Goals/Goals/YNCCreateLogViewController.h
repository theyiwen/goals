//
//  YNCCreateLogViewController.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNCGoal.h"

@protocol YNCCreateLogViewControllerDelegate;

@interface YNCCreateLogViewController : UIViewController

@property (weak, nonatomic) id<YNCCreateLogViewControllerDelegate> delegate;

- (instancetype)initWithGoalType:(GoalType)type;

@end

@protocol YNCCreateLogViewControllerDelegate

- (void)createLogViewControllerDidSubmit:(YNCCreateLogViewController *)createLogViewController
                               withValue:(NSNumber *)value
                                   notes:(NSString *)notes;

@end
