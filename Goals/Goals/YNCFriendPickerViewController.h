//
//  YNCFriendPickerViewController.h
//  Goals
//
//  Created by Calvin Lee on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCFriendPickerViewControllerDelegate;

@interface YNCFriendPickerViewController : UIViewController

@property (weak, nonatomic) id<YNCFriendPickerViewControllerDelegate> delegate;

@end

@protocol YNCFriendPickerViewControllerDelegate

- (void)friendPickerViewControllerDidSubmit:(YNCFriendPickerViewController *)friendPickerViewController
                                withFriends:(NSArray *)friends;

@end
