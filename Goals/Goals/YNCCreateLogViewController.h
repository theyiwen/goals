//
//  YNCCreateLogViewController.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCCreateLogViewControllerDelegate;

@interface YNCCreateLogViewController : UIViewController

@property (weak, nonatomic) id<YNCCreateLogViewControllerDelegate> delegate;

@end

@protocol YNCCreateLogViewControllerDelegate

- (void)createLogViewControllerDidSubmit:(YNCCreateLogViewController *)createLogViewController
                               withValue:(NSNumber *)value
                                   notes:(NSString *)notes;

@end
