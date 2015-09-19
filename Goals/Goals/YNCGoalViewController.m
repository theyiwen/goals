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

@interface YNCGoalViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *usersContainer;
@property (strong, nonatomic) NSMutableArray *usersLabels;

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
  self.usersLabels = [[NSMutableArray alloc] init];
  
  [self.view addSubview:container];
  [container addSubview:titleLabel];
  [container addSubview:descLabel];
  [container addSubview:usersContainer];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, descLabel, usersContainer);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[titleLabel]-10-[descLabel]-10-[usersContainer]" toView:container];
  [autoLayout addConstraintForViews:@[container, titleLabel, descLabel] equivalentAttribute:NSLayoutAttributeCenterX toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[usersContainer]|" toView:container];

  UILabel *lastLabel;
  NSInteger count = 0;
  for (YNCUser *user in self.goal.users) {
    UILabel *label = [[UILabel alloc] init];
    label.text = user.fullName;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
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
                               constant:-30
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
    lastLabel = label;
    count = count + 1;
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self setGoalDetails];
}

- (void)setGoalDetails {
  self.titleLabel.text = self.goal.title;
  self.descLabel.text = self.goal.desc;

}


@end
