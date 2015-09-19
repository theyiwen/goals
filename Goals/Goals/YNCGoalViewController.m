//
//  YNCGoalViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCGoalViewController.h"
#import "YNCAutoLayout.h"

@interface YNCGoalViewController ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIView *container;

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
  UILabel *titleLabel = self.titleLabel = [[UILabel alloc] init];
  UILabel *descLabel = self.descLabel = [[UILabel alloc] init];
  
  [self.view addSubview:container];
  [container addSubview:titleLabel];
  [container addSubview:descLabel];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, descLabel);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-100-[titleLabel]-10-[descLabel]" toView:container];
  [autoLayout addConstraintForViews:@[container, titleLabel, descLabel] equivalentAttribute:NSLayoutAttributeCenterX toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];

  self.view.backgroundColor = [UIColor whiteColor];
  [self setGoalDetails];
}

- (void)setGoalDetails {
  self.titleLabel.text = self.goal.title;
  self.descLabel.text = self.goal.desc;
}


@end
