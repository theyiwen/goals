//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"
#import "YNCAutoLayout.h"

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
  [dailyTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [totalTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  [totalTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  goalTitleTextField.backgroundColor = [UIColor grayColor];
  
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
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, goalTitleLabel, goalTitleTextField, goalTypeLabel, dailyTypeButton, totalTypeButton, goalDurationLabel, goalDurationTextField, goalDescriptionLabel, goalDescriptionTextField);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleLabel]-20-[goalTypeLabel]-20-[goalDurationLabel]-20-[goalDescriptionLabel]" toView:container];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleTextField(25)]" toView:container];
  [autoLayout addVflConstraint:@"V:|-135-[dailyTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-135-[totalTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTitleLabel]-10-[goalTitleTextField(200)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTypeLabel]-10-[dailyTypeButton]-10-[totalTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];
  
  // todo (calvin) -- person picker
  
}

@end