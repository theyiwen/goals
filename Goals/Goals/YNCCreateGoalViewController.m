//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"
#import "YNCAutoLayout.h"
#import "YNCGoal.h"

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
@property (strong, nonatomic) UIButton *totalTypeButton;
@property (strong, nonatomic) UITextField *goalDurationTextField;
@property (strong, nonatomic) UIButton *submitButton;
@property (nonatomic) GoalType goalType;

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
  UILabel *goalMembersLabel = self.goalMembersLabel = [[UILabel alloc] init];
  goalMembersLabel.text = @"WITH:";
  UILabel *goalDurationLabel = self.goalDurationLabel = [[UILabel alloc] init];
  goalDurationLabel.text = @"DURATION:";
  
  UITextField *goalTitleTextField = self.goalTitleTextField = [[UITextField alloc] init];
  UITextField *goalDescriptionTextField = self.goalDescriptionTextField = [[UITextField alloc] init];
  UIButton *dailyTypeButton = self.dailyTypeButton = [[UIButton alloc] init];
  UIButton *totalTypeButton = self.totalTypeButton = [[UIButton alloc] init];
  NSMutableArray *typeButtons = self.typeButtons = [[NSMutableArray alloc] initWithArray:@[dailyTypeButton, totalTypeButton]];
  [dailyTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  dailyTypeButton.tag = daily;
  [dailyTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  [totalTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [totalTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  totalTypeButton.tag = sum;
  [totalTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  goalTitleTextField.backgroundColor = [UIColor grayColor];
  goalDurationTextField.backgroundColor = [UIColor grayColor];
  goalDescriptionTextField.backgroundColor = [UIColor grayColor];
  
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:container];
  [container addSubview:goalTitleLabel];
  [container addSubview:goalTitleTextField];
  [container addSubview:goalTypeLabel];
  [container addSubview:dailyTypeButton];
  [container addSubview:totalTypeButton];
  [container addSubview:goalDurationLabel];
  [container addSubview:goalDurationTextField];
  [container addSubview:goalMembersLabel];
  [container addSubview:goalDescriptionLabel];
  [container addSubview:goalDescriptionTextField];
  [container addSubview:submitButton];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, goalTitleLabel, goalTitleTextField, goalTypeLabel, dailyTypeButton, totalTypeButton, goalDurationLabel, goalDurationTextField, goalMembersLabel, goalDescriptionLabel, goalDescriptionTextField, submitButton);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleLabel]-20-[goalTypeLabel]-20-[goalDurationLabel]-20-[goalMembersLabel]-20-[goalDescriptionLabel]-100-[submitButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-100-[goalTitleTextField(25)]" toView:container];
  [autoLayout addVflConstraint:@"V:|-134-[dailyTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-134-[totalTypeButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-175-[goalDurationTextField(25)]" toView:container];
  [autoLayout addVflConstraint:@"V:|-250-[goalDescriptionTextField(100)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTitleLabel]-10-[goalTitleTextField(200)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[goalTypeLabel]-10-[dailyTypeButton]-10-[totalTypeButton]" toView:container];
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
  // [YNCGoal createAndSaveGoalWithTitle:<#(NSString *)#> desc:<#(NSString *)#> type:<#(GoalType)#> duration:<#(NSNumber *)#> usersList:<#(NSArray *)#>
  /* PFObject *pfObject = [PFObject objectWithClassName:@"Goal"];
  pfObject[logKey.goal] = goal.pfObject;
  pfObject[logKey.user] = [PFUser currentUser];
  pfObject[logKey.count] = count;
  pfObject[logKey.notes] = notes;
  [pfObject saveInBackgroundWithBlock:nil];
   */
}

@end