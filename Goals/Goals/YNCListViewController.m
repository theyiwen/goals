//
//  YNCListViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCListViewController.h"
#import "YNCAutoLayout.h"

@interface YNCListViewController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation YNCListViewController

- (void)loadView {
  [super loadView];
  UITableView *tableView = self.tableView = [[UITableView alloc] init];
  [self.view addSubview:tableView];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"H:|[tableView]|" toView:self.view];
  [autoLayout addVflConstraint:@"V:|[tableView]|" toView:self.view];
}

@end
