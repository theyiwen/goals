//
//  YNCFriendPickerViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/20/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCFriendPickerViewController.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCColor.h"
#import "YNCUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString * const kYNCFriendViewCellIdentifier = @"cellIdentifier";

@interface YNCFriendPickerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSArray *myFriends;
@property (strong, nonatomic) UITableView *friendListTableView;

@end

@implementation YNCFriendPickerViewController

- (void)loadView {
  self.title = @"Add Friends"; // how to change font of this?
  self.view = [[UIView alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  [self.view addSubview:container];
  
  container.backgroundColor = [YNCColor tealColor];
  
  NSArray *myFriends = self.myFriends = [[NSArray alloc] init];
  UITableView *friendsListTableView = self.friendListTableView = [[UITableView alloc] init];
  friendsListTableView.delegate = self;
  friendsListTableView.dataSource = self;
  [friendsListTableView registerClass:[UITableViewCell class]
     forCellReuseIdentifier:kYNCFriendViewCellIdentifier];
  
  [container addSubview:friendsListTableView];
  
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, friendsListTableView);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|[friendsListTableView(500)]" toView:container];
  [autoLayout addVflConstraint:@"H:|[friendsListTableView(400)]" toView:container];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:self.view];

  
}

- (void)viewDidLoad {
  // time to find friends!
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                initWithGraphPath:@"/me/friends"
                                parameters:nil
                                HTTPMethod:@"GET"];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                        id result,
                                        NSError *error) {
    if(!error) {
      NSMutableArray *friendBuilder = [[NSMutableArray alloc] init];
      NSDictionary *friendData = (NSDictionary *)result;
      NSDictionary *friends = (NSDictionary *)friendData[@"data"];
      for (NSDictionary *friend in friends) {
        [friendBuilder addObject:friend[@"id"]];
      }
      [YNCUser loadUsersWithFacebookIDs:[friendBuilder copy] Callback:^(NSArray *users, NSError *error) {
        self.myFriends = [users copy];
        [self.friendListTableView reloadData];
      }];
    }
    else {
      NSLog(@"error finding friends");
    }
  }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"count %d", [self.myFriends count]);
  return [self.myFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYNCFriendViewCellIdentifier];
  NSLog(@"cell");
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];
  NSLog(@"user %@", user);
  cell.textLabel.text = user.firstName;
  cell.textLabel.font = [YNCFont standardFont];
  cell.textLabel.textColor = [UIColor blackColor];
  
  NSURL *url = [NSURL URLWithString:user.photoUrl];
  NSData *data = [NSData dataWithContentsOfURL:url];
  UIImage *img = [[UIImage alloc] initWithData:data];
  cell.imageView.image = img;

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  /*YNCGoal *goal = [self goalAtIndexPath:indexPath];
   YNCGoalViewController *goalVC = [[YNCGoalViewController alloc] initWithGoal:goal];
   [self.navigationController pushViewController:goalVC animated:YES];
   */
  NSLog(@"you picked something!");
}


@end