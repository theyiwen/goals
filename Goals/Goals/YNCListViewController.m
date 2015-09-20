//
//  YNCListViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCListViewController.h"
#import "YNCGoalViewController.h"
#import "YNCCreateGoalViewController.h"
#import "YNCAutoLayout.h"
#import "YNCGoal.h"

static NSString * const kYNCListViewCellIdentifier = @"cellIdentifier";

@interface YNCListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *goals;

@end

@implementation YNCListViewController

- (void)loadView {
  [super loadView];
  self.goals = [[NSArray alloc] init];
  
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonPressed)];
  self.navigationItem.rightBarButtonItem = addButton;
  NSLog(@"yes");
  
  UITableView *tableView = self.tableView = [[UITableView alloc] init];
  [self.view addSubview:tableView];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"H:|[tableView]|" toView:self.view];
  [autoLayout addVflConstraint:@"V:|[tableView]|" toView:self.view];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kYNCListViewCellIdentifier];
  
  [YNCGoal loadGoalsWithCallback:^(NSArray *goals, NSError *error) {
    NSLog(@"found goals %@", goals);
    self.goals = goals;
    [self.tableView reloadData];
  }];
}

- (YNCGoal *)goalAtIndexPath:(NSIndexPath *)indexPath {
  return (YNCGoal *)self.goals[indexPath.row];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.goals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYNCListViewCellIdentifier];
  YNCGoal *goal = [self goalAtIndexPath:indexPath];
  cell.textLabel.text = goal.title;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  YNCGoal *goal = [self goalAtIndexPath:indexPath];
  YNCGoalViewController *goalVC = [[YNCGoalViewController alloc] initWithGoal:goal];
  [self.navigationController pushViewController:goalVC animated:YES];
}

- (void)addButtonPressed {
  YNCCreateGoalViewController *createGoalVC = [[YNCCreateGoalViewController alloc] init];
  [self.navigationController pushViewController:createGoalVC animated:YES];
}

@end
