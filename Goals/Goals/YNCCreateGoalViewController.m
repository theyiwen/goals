//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCGoal.h"
#import "YNCUser.h"

@interface YNCCreateGoalViewController ()

@property (strong, nonatomic) UIView *container;

@property (strong, nonatomic) UILabel *goalTitleLabel;
@property (strong, nonatomic) UILabel *goalDescriptionLabel;
@property (strong, nonatomic) UILabel *goalTypeLabel;
@property (strong, nonatomic) UILabel *goalMembersLabel;
@property (strong, nonatomic) UILabel *goalDurationLabel;

@property (strong, nonatomic) UITextField *goalTitleTextField;
@property (strong, nonatomic) UITextField *goalDescriptionTextField;
@property (strong, nonatomic) NSMutableArray *typeButtons;
@property (strong, nonatomic) UIButton *dailyTypeButton;
@property (strong, nonatomic) UIButton *sumTypeButton;
@property (strong, nonatomic) UITextField *goalDurationTextField;
@property (strong, nonatomic) UIButton *submitButton;
@property (nonatomic) GoalType goalType;

@end

@implementation YNCCreateGoalViewController

- (void)loadView {
  self.title = @"Create Goal"; // how to change font of this?
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  UIView *container = self.container = [[UIView alloc] init];
  
  UILabel *goalTitleLabel = self.goalTitleLabel = [[UILabel alloc] init];
  goalTitleLabel.text = @"GOAL TITLE:";
  UILabel *goalDescriptionLabel = self.goalDescriptionLabel = [[UILabel alloc] init];
  goalDescriptionLabel.text = @"DESCRIPTION:";
  UILabel *goalTypeLabel = self.goalTypeLabel = [[UILabel alloc] init];
  goalTypeLabel.text = @"TYPE:";
  UILabel *goalMembersLabel = self.goalMembersLabel = [[UILabel alloc] init];
  goalMembersLabel.text = @"WITH:";
  UILabel *goalDurationLabel = self.goalDurationLabel = [[UILabel alloc] init];
  goalDurationLabel.text = @"DURATION:";
  
  UITextField *goalTitleTextField = self.goalTitleTextField = [[UITextField alloc] init];
  UITextField *goalDescriptionTextField = self.goalDescriptionTextField = [[UITextField alloc] init];
  UIButton *dailyTypeButton = self.dailyTypeButton = [[UIButton alloc] init];
  UIButton *sumTypeButton = self.sumTypeButton = [[UIButton alloc] init];
  NSMutableArray *typeButtons = self.typeButtons = [[NSMutableArray alloc] initWithArray:@[dailyTypeButton, sumTypeButton]];
  [dailyTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  dailyTypeButton.tag = daily;
  [dailyTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  [sumTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [sumTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  sumTypeButton.tag = sum;
  [sumTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  goalTitleTextField.backgroundColor = [UIColor grayColor];
  goalDurationTextField.backgroundColor = [UIColor grayColor];
  goalDescriptionTextField.backgroundColor = [UIColor grayColor];
  
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  goalTitleLabel.font = [YNCFont standardFont];
  goalDescriptionLabel.font = [YNCFont standardFont];
  goalTypeLabel.font = [YNCFont standardFont];
  goalMembersLabel.font = [YNCFont standardFont];
  goalDurationLabel.font = [YNCFont standardFont];
  goalTitleTextField.font = [YNCFont standardFont];
  goalDescriptionTextField.font = [YNCFont standardFont];
  goalDurationTextField.font = [YNCFont standardFont];
  goalDurationTextField.font = [YNCFont standardFont];
  dailyTypeButton.titleLabel.font = [YNCFont standardFont];
  sumTypeButton.titleLabel.font = [YNCFont standardFont];
  submitButton.titleLabel.font = [YNCFont standardFont];
  
  [self.view addSubview:container];
  [container addSubview:goalTitleLabel];
  [container addSubview:goalTitleTextField];
  [container addSubview:goalTypeLabel];
  [container addSubview:dailyTypeButton];
  [container addSubview:sumTypeButton];
  [container addSubview:goalDurationLabel];
  [container addSubview:goalDurationTextField];
  [container addSubview:goalMembersLabel];
  [container addSubview:goalDescriptionLabel];
  [container addSubview:goalDescriptionTextField];
  [container addSubview:submitButton];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, goalTitleLabel, goalTitleTextField, goalTypeLabel, dailyTypeButton, sumTypeButton, goalDurationLabel, goalDurationTextField, goalMembersLabel, goalDescriptionLabel, goalDescriptionTextField, submitButton);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleLabel]-20-[goalTypeLabel]-20-[goalDurationLabel]-20-[goalMembersLabel]-20-[goalDescriptionLabel]-100-[submitButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleTextField(25)]" toView:container];
  [autoLayout addVflConstraint:@"V:|-134-[dailyTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-134-[sumTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-175-[goalDurationTextField(25)]" toView:container];
  [autoLayout addVflConstraint:@"V:|-250-[goalDescriptionTextField(100)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTitleLabel]-10-[goalTitleTextField(200)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTypeLabel]-10-[dailyTypeButton]-10-[sumTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalDurationLabel]-10-[goalDurationTextField(200)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalDescriptionLabel]-10-[goalDescriptionTextField(200)]" toView:container];
  [autoLayout addVflConstraint:@"H:[submitButton]-50-|" toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];
  
  // todo (calvin) -- person picker
  
}

- (void)selectType:(UIButton *)sender {
  self.goalType = sender.tag;
  
  for (UIButton *button in self.typeButtons) {
    if (button != sender) {
      [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else {
      [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
  }
}

- (void)submitButtonPressed:(UIButton *)button {
  
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  NSNumber *duration = [f numberFromString:self.goalDurationTextField.text];
  
  NSMutableArray *usersBuilder = [[NSMutableArray alloc] init];
  [usersBuilder addObject:[PFUser currentUser]];
  /* for (PFObject *userObject in self.pfObject[YNCGoalPFKey.usersListKey]) {
    [usersBuilder addObject:[[YNCUser alloc] initWithPFObject:userObject]];
  }
   */
  NSArray *usersList = [usersBuilder copy];
  
  [YNCGoal createAndSaveGoalWithTitle:self.goalTitleTextField.text desc:self.goalDescriptionTextField.text type:self.goalType duration:duration usersList:usersList];
  [self.navigationController popViewControllerAnimated:YES];
  // TODO (REFRESH list view after)
}

@end