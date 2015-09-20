//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"

@interface YNCCreateGoalViewController ()

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation YNCCreateGoalViewController

- (void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  UILabel *titleLabel = self.titleLabel = [[UILabel alloc] init];
  titleLabel.text = @"Test";
  UIView *container = self.container = [[UIView alloc] init];
  [self.view addSubview:container];
  [container addSubview:titleLabel];
}

@end