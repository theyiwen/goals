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
#import "YNCCreateLogViewController.h"
#import "YNCFont.h"
#import "YNCCalendarView.h"
#import "YNCColor.h"

@interface YNCGoalViewController ()<YNCCreateLogViewControllerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *dates;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *usersLabel;
@property (strong, nonatomic) UILabel *calLabel;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *usersContainer;
@property (strong, nonatomic) NSMutableDictionary *usersLabels;
@property (strong, nonatomic) UIButton *addLog;
@property (strong, nonatomic) YNCCalendarView *calendar;

@property (strong, nonatomic) YNCGoal *goal;
@property (strong, nonatomic) NSArray *logs;
@property (strong, nonatomic) NSMutableDictionary *userSums;
@property (strong, nonatomic) NSMutableDictionary *userColors;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation YNCGoalViewController

- (instancetype)initWithGoal:(YNCGoal *)goal {
  if (self = [super init]) {
    _goal = goal;
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"MM/dd";
    _userColors = [[NSMutableDictionary alloc] init];
    int count = 0;
    for (YNCUser *user in self.goal.users) {
      self.userColors[user.pfID] = [YNCColor userColors][count];
      count = count + 1;
    }

  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  UIScrollView *scrollView = self.scrollView = [[UIScrollView alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  UIView *usersContainer = self.usersContainer = [[UIView alloc] init];
  UILabel *name = self.name = [[UILabel alloc] init];
  UILabel *dates = self.dates = [[UILabel alloc] init];
  UILabel *desc = self.desc = [[UILabel alloc] init];
  UILabel *descLabel = self.descLabel = [[UILabel alloc] init];
  UILabel *calLabel = self.calLabel = [[UILabel alloc] init];
  UILabel *usersLabel = self.usersLabel = [[UILabel alloc] init];

  UIButton *addLog = self.addLog = [[UIButton alloc] init];
  CGRect calFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 40, 250);
  YNCCalendarView *calendar = self.calendar = [[YNCCalendarView alloc] initWithFrame:calFrame
                                                                                goal:self.goal
                                                                                logs:self.logs
                                                                          userColors:self.userColors];

  self.usersLabels = [[NSMutableDictionary alloc] init];
  
  [self.view addSubview:scrollView];
  [self.view addSubview:addLog];
  [scrollView addSubview:container];
  [container addSubview:name];
  [container addSubview:dates];
  [container addSubview:desc];
  [container addSubview:usersContainer];
  [container addSubview:calendar];
  [container addSubview:descLabel];
  [container addSubview:usersLabel];
  [container addSubview:calLabel];


  NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, container, name, dates, desc, usersContainer, addLog, calendar,
                                                       descLabel, calLabel, usersLabel);

  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-30-[name][dates]-20-[descLabel]-5-[desc]-20-[usersLabel]-5-[usersContainer]-20-[calLabel]-5-[calendar(250)]-20-|" toView:container];
  [autoLayout addConstraintForViews:@[self.view, scrollView, container, addLog] equivalentAttribute:NSLayoutAttributeCenterX toView:self.view];
  [autoLayout addVflConstraint:@"V:[addLog]-20-|" toView:self.view];
  [autoLayout addVflConstraint:@"V:|[scrollView]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[scrollView]|" toView:self.view];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:scrollView];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:scrollView];
  [autoLayout addVflConstraint:@"H:|-20-[name]" toView:container];
  [autoLayout addConstraintForViews:@[name, desc, descLabel, calLabel, usersLabel, dates]
                equivalentAttribute:NSLayoutAttributeLeft
                             toView:container];

  // Set width equal to scroll view port, not scroll view content size
  [autoLayout addConstraintForViews:@[container, scrollView]
                     equivalentAttribute:NSLayoutAttributeWidth
                                  toView:self.view];
  scrollView.scrollEnabled = YES;
  [autoLayout addVflConstraint:@"H:|-20-[usersContainer]-20-|" toView:container];
  [autoLayout addConstraintForView:addLog withSize:CGSizeMake(75,75) toView:addLog];
  [autoLayout addVflConstraint:@"H:|-20-[calendar]-20-|" toView:container];

  YNCGoalUserView *lastLabel;
  NSInteger count = 0;
  for (YNCUser *user in self.goal.users) {
    YNCGoalUserView *label = [[YNCGoalUserView alloc] initWithUser:user color:(UIColor *)self.userColors[user.pfID]];
    self.usersLabels[user.pfID] = label;
    [self.usersContainer addSubview:label];
    if (count == 0) {
      [autoLayout addConstraintWithItem:label
                                 toItem:usersContainer
                    equivalentAttribute:NSLayoutAttributeLeft
                             multiplier:1
                               constant:0
                                 toView:usersContainer];
    }
    if (lastLabel) {
      [autoLayout addConstraintWithItem:lastLabel
                                 toItem:label
                    equivalentAttribute:NSLayoutAttributeLeft
                             multiplier:1
                               constant:(-kYNCGoalUserViewWidth - 10)
                                 toView:usersContainer];
    }
    [autoLayout addConstraintForViews:@[label,usersContainer]
                  equivalentAttribute:NSLayoutAttributeTop
                               toView:usersContainer];
    [autoLayout addConstraintForViews:@[label,usersContainer]
                  equivalentAttribute:NSLayoutAttributeBottom
                               toView:usersContainer];
    lastLabel = label;
    count = count + 1;
  }
  
  usersLabel.text = @"leaderboard".uppercaseString;
  calLabel.text = @"progress".uppercaseString;
  descLabel.text = @"details".uppercaseString;
  dates.text = [NSString stringWithFormat:@"%@ DAYS: %@ - %@ ",
                self.goal.duration,
                [self.dateFormatter stringFromDate:self.goal.startDate],
                [self.dateFormatter stringFromDate:self.goal.endDate]
                ];
  
  for (UILabel *label in @[usersLabel, calLabel, descLabel, dates]) {
    label.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:12];
    label.textColor = [UIColor darkGrayColor];
  }
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self setGoalDetails];
  [addLog setImage:[UIImage imageNamed:@"add_log_button.png"] forState:UIControlStateNormal];
  [addLog addTarget:self action:@selector(addLogPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [YNCLog getAllLogsForGoal:self.goal
               withCallback:^(NSArray *logs, NSError *error) {
                 if (!error) {
                   self.logs = logs;
                   [self processLogs];
                 }
               }];
}

- (YNCGoalUserView *)userLabelForUser:(NSString *)userID {
  return (YNCGoalUserView *)self.usersLabels[userID];
}

- (void)processLogs {
  self.calendar.logs = self.logs;
  self.userSums = [[NSMutableDictionary alloc] init];
  for (YNCLog *log in self.logs) {
    if (self.userSums[log.user.pfID]) {
      self.userSums[log.user.pfID] = @([self.userSums[log.user.pfID] floatValue] + [log.value floatValue]);
    } else {
      self.userSums[log.user.pfID] = @([log.value floatValue]);
    }
  }
  for (NSString *userID in self.userSums) {
    [self userLabelForUser:userID].score = self.userSums[userID];
  }
}

- (void)setGoalDetails {
  self.name.text = self.goal.title.uppercaseString;
  self.desc.text = self.goal.desc;
  self.name.font = [UIFont fontWithName:[YNCFont boldFontName] size:30];
  self.desc.font = [YNCFont standardFont];
}

- (void)addLogPressed {
  YNCCreateLogViewController *logVC = [[YNCCreateLogViewController alloc] init];
  logVC.delegate = self;
  logVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;

  [self presentViewController:logVC animated:YES completion:nil];
}

- (void)createLogViewControllerDidSubmit:(YNCCreateLogViewController *)createLogViewController
                                witValue:(NSNumber *)value
                                   notes:(NSString *)notes {
  [YNCLog createAndSaveLogWithGoal:self.goal
                             value:value
                             notes:notes];
}

@end
