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

static NSString * const kYNCLogTableCellId = @"cellIdentifier";

@interface YNCGoalViewController ()<YNCCreateLogViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, YNCCalendarViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *dates;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *usersLabel;
@property (strong, nonatomic) UILabel *calLabel;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *usersContainer;
@property (strong, nonatomic) UITableView *logTable;
@property (strong, nonatomic) NSMutableDictionary *usersLabels;
@property (strong, nonatomic) UIButton *addLog;
@property (strong, nonatomic) YNCCalendarView *calendar;

@property (strong, nonatomic) YNCGoal *goal;
@property (strong, nonatomic) NSArray *allLogs;
@property (strong, nonatomic) NSMutableDictionary *logsByDate;
@property (strong, nonatomic) NSMutableDictionary *userSums;
@property (strong, nonatomic) NSMutableDictionary *userColors;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *logResults;
@property (strong, nonatomic) NSLayoutConstraint *calendarHeightConstraint;

@end

@implementation YNCGoalViewController

- (instancetype)initWithGoal:(YNCGoal *)goal {
  if (self = [super init]) {
    _goal = goal;
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"MM/dd";
    _userColors = [[NSMutableDictionary alloc] init];
    _logResults = [[NSMutableArray alloc] init];
    _logsByDate = [[NSMutableDictionary alloc] init];
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
  UITableView *logTable = self.logTable = [[UITableView alloc] init];

  UIButton *addLog = self.addLog = [[UIButton alloc] init];
  CGRect calFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 40, 0);
  YNCCalendarView *calendar = self.calendar = [[YNCCalendarView alloc] initWithFrame:calFrame
                                                                                goal:self.goal
                                                                                logs:self.allLogs
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
  [container addSubview:logTable];

  NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, container, name, dates, desc, usersContainer, addLog, calendar,
                                                       descLabel, calLabel, usersLabel, logTable);
//  calendar.translatesAutoresizingMaskIntoConstraints = YES;

  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-30-[name][dates]-20-[descLabel]-5-[desc]-20-[usersLabel]-5-[usersContainer]-20-[calLabel]-5-[calendar]-5-[logTable]-20-|" toView:container];
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
  [autoLayout addVflConstraint:@"H:|-20-[logTable]-20-|" toView:container];
  self.calendarHeightConstraint = [NSLayoutConstraint constraintWithItem:calendar
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0 constant:0];
  [self.view addConstraint:self.calendarHeightConstraint];

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
  [logTable registerClass:[UITableViewCell class]
   forCellReuseIdentifier:kYNCLogTableCellId];
  logTable.delegate = self;
  logTable.dataSource = self;
  calendar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [YNCLog getAllLogsForGoal:self.goal
               withCallback:^(NSArray *logs, NSError *error) {
                 if (!error) {
                   self.allLogs = logs;
                   [self processLogs];
                 }
               }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)sizeTableViewToFitResults {
    self.logTable.frame =
    CGRectMake(self.logTable.frame.origin.x,
               self.logTable.frame.origin.y,
               self.logTable.contentSize.width,
               self.logTable.contentSize.height);
}

- (YNCGoalUserView *)userLabelForUser:(NSString *)userID {
  return (YNCGoalUserView *)self.usersLabels[userID];
}

- (void)processLogs {
  self.calendar.logs = self.allLogs;
  self.userSums = [[NSMutableDictionary alloc] init];
  for (YNCLog *log in self.allLogs) {
    if (self.userSums[log.user.pfID]) {
      self.userSums[log.user.pfID] = @([self.userSums[log.user.pfID] floatValue] + [log.value floatValue]);
    } else {
      self.userSums[log.user.pfID] = @([log.value floatValue]);
    }
    NSString *dateStr = [self.dateFormatter stringFromDate:log.date];
    if (!self.logsByDate[dateStr]) {
      self.logsByDate[dateStr] = [[NSMutableArray alloc] init];
    }
    [(NSMutableArray *)self.logsByDate[dateStr] addObject:log];
  }
  for (NSString *userID in self.userSums) {
    [self userLabelForUser:userID].score = self.userSums[userID];
  }

}

- (void)setGoalDetails {
  self.name.text = self.goal.title.uppercaseString;
  self.desc.text = self.goal.desc;
  self.name.font = [UIFont fontWithName:[YNCFont boldFontName] size:20];
  self.desc.font = [YNCFont standardFont];
}

- (void)addLogPressed {
  YNCCreateLogViewController *logVC = [[YNCCreateLogViewController alloc] initWithGoalType:self.goal.type];
  logVC.delegate = self;
  logVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;

  [self presentViewController:logVC animated:YES completion:nil];
}

- (void)createLogViewControllerDidSubmit:(YNCCreateLogViewController *)createLogViewController
                               withValue:(NSNumber *)value
                                   notes:(NSString *)notes {
  [YNCLog createAndSaveLogWithGoal:self.goal
                             value:value
                             notes:notes];
}

- (void)calendarView:(YNCCalendarView *)calendarView didSelectDate:(NSDate *)date {
  if (self.logsByDate[[self.dateFormatter stringFromDate:date]]) {
    self.logResults = self.logsByDate[[self.dateFormatter stringFromDate:date]];
  } else {
    self.logResults = [[NSMutableArray alloc] init];
  }
  [self.logTable reloadData];
  [self sizeTableViewToFitResults];
}

- (void)calendarView:(YNCCalendarView *)calendarView didUpdateHeight:(CGFloat)height {
  self.calendarHeightConstraint.constant = height;
}

- (YNCLog *)logAtIndexPath:(NSIndexPath *)indexPath {
  return (YNCLog *)self.logResults[indexPath.row];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.logResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYNCLogTableCellId];
  YNCLog *log = [self logAtIndexPath:indexPath];
  if (log.notes.length > 0) {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ did it: %@", log.user.firstName, log.notes, nil];
  } else {
    cell.textLabel.text = [NSString stringWithFormat:@"%@ did it!", log.user.firstName, nil];
  }
  cell.textLabel.font = [YNCFont standardFont];
  return cell;
}

@end
