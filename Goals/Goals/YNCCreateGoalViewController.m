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

@property (strong, nonatomic) UILabel *goalTitleLabel;
@property (strong, nonatomic) UILabel *goalDescriptionLabel;
@property (strong, nonatomic) UILabel *goalTypeLabel;
@property (strong, nonatomic) UILabel *goalDurationLabel;

@property (strong, nonatomic) UITextField *goalTitleTextField;
@property (strong, nonatomic) UITextField *goalDescriptionTextField;
@property (strong, nonatomic) UIButton *dailyTypeButton;
@property (strong, nonatomic) UIButton *totalTypeButton;
@property (strong, nonatomic) UITextField *goalDurationTextField;

@property (strong, nonatomic) NSArray *pickerOptions;

@end

@implementation YNCCreateGoalViewController

- (void)loadView {
  self.title = @"Create Goal";
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  UIView *container = self.container = [[UIView alloc] init];
  
  UILabel *goalTitleLabel = self.goalTitleLabel = [[UILabel alloc] init];
  goalTitleLabel.text = @"GOAL TITLE:";
  UILabel *goalDescriptionLabel = self.goalDescriptionLabel = [[UILabel alloc] init];
  goalDescriptionLabel.text = @"DESCRIPTION:";
  UILabel *goalTypeLabel = self.goalTypeLabel = [[UILabel alloc] init];
  goalTypeLabel.text = @"TYPE:";
  UILabel *goalDurationLabel = self.goalDurationLabel = [[UILabel alloc] init];
  goalDurationLabel.text = @"DURATION:";
  
  UITextField *goalTitleTextField = self.goalTitleTextField = [[UITextField alloc] init];
  UITextField *goalDescriptionTextField = self.goalDescriptionTextField = [[UITextField alloc] init];
  UIButton *dailyTypeButton = self.dailyTypeButton = [[UIButton alloc] init];
  UIButton *totalTypeButton = self.totalTypeButton = [[UIButton alloc] init];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  [totalTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  
  
  [self.view addSubview:container];
  [container addSubview:goalTitleLabel];
  [container addSubview:goalTitleTextField];
  [container addSubview:goalTypeLabel];
  [container addSubview:dailyTypeButton];
  [container addSubview:totalTypeButton];
  [container addSubview:goalDurationLabel];
  [container addSubview:goalDurationTextField];
  [container addSubview:goalDescriptionLabel];
  [container addSubview:goalDescriptionTextField];
  
  // todo (calvin) -- person picker
  
}

@end