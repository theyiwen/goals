//
//  YNCGoalViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCGoalViewController.h"
#import "YNCAutoLayout.h"
#import "YNCUser.h"
#import "YNCGoalUserView.h"
#import "YNCLog.h"

@interface YNCGoalViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *usersContainer;
@property (strong, nonatomic) NSMutableArray *usersLabels;
@property (strong, nonatomic) UIButton *addLog;

@property (strong, nonatomic) YNCGoal *goal;

@end

@implementation YNCGoalViewController

- (instancetype)initWithGoal:(YNCGoal *)goal {
  if (self = [super init]) {
    _goal = goal;
  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  UIView *usersContainer = self.usersContainer = [[UIView alloc] init];
  UILabel *titleLabel = self.titleLabel = [[UILabel alloc] init];
  UILabel *descLabel = self.descLabel = [[UILabel alloc] init];
  UIButton *addLog = self.addLog = [[UIButton alloc] init];

  self.usersLabels = [[NSMutableArray alloc] init];
  
  [self.view addSubview:container];
  [container addSubview:titleLabel];
  [container addSubview:descLabel];
  [container addSubview:usersContainer];
  [container addSubview:addLog];

  NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, descLabel, usersContainer, addLog);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[titleLabel]-10-[descLabel]-50-[usersContainer]-20-[addLog]" toView:container];
  [autoLayout addConstraintForViews:@[container, titleLabel, descLabel, addLog] equivalentAttribute:NSLayoutAttributeCenterX toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[usersContainer]|" toView:container];
  [autoLayout addConstraintForView:addLog withSize:CGSizeMake(20,20) toView:addLog];

  YNCGoalUserView *lastLabel;
  NSInteger count = 0;
  for (YNCUser *user in self.goal.users) {
    YNCGoalUserView *label = [[YNCGoalUserView alloc] initWithUser:user];
    [self.usersLabels addObject:label];
    [self.usersContainer addSubview:label];
    if (count == 0) {
      [autoLayout addConstraintWithItem:label
                                 toItem:usersContainer
                    equivalentAttribute:NSLayoutAttributeTop
                             multiplier:1
                               constant:0
                                 toView:usersContainer];
    }
    if (lastLabel) {
      [autoLayout addConstraintWithItem:lastLabel
                                 toItem:label
                    equivalentAttribute:NSLayoutAttributeTop
                             multiplier:1
                               constant:-50
                                 toView:usersContainer];
    }
    if (count == self.goal.users.count - 1) {
      [autoLayout addConstraintWithItem:label
                                 toItem:usersContainer
                    equivalentAttribute:NSLayoutAttributeBottom
                             multiplier:1
                               constant:0
                                 toView:usersContainer];
    }
    [autoLayout addConstraintForViews:@[label,usersContainer]
                  equivalentAttribute:NSLayoutAttributeWidth
                               toView:usersContainer];
    lastLabel = label;
    count = count + 1;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self setGoalDetails];
  [addLog addTarget:self action:@selector(addLogPressed) forControlEvents:UIControlEventTouchUpInside];
  addLog.layer.cornerRadius = 10;
  addLog.backgroundColor = [UIColor grayColor];
}

- (void)setGoalDetails {
  self.titleLabel.text = self.goal.title;
  self.descLabel.text = self.goal.desc;

}

- (void)addLogPressed {
  [YNCLog createAndSaveLogWithGoal:self.goal
                             count:@1
                             notes:@"test"];
}


@end
