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
@property (strong, nonatomic) NSMutableSet *pickedFriends;

@end

@implementation YNCFriendPickerViewController

- (void)loadView {
  self.title = @"Add Friends"; // how to change font of this?
  self.view = [[UIView alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  [self.view addSubview:container];
  self.view.backgroundColor = [UIColor whiteColor];
  
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
  self.navigationItem.rightBarButtonItem = doneButton; // should only show if picked friends > 1 but whatever
  
  
  self.pickedFriends = [[NSMutableSet alloc] init];
  self.myFriends = [[NSArray alloc] init];
  UITableView *friendsListTableView = self.friendListTableView = [[UITableView alloc] init];
  friendsListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  friendsListTableView.delegate = self;
  friendsListTableView.dataSource = self;
  [friendsListTableView registerClass:[UITableViewCell class]
     forCellReuseIdentifier:kYNCFriendViewCellIdentifier];
  friendsListTableView.allowsMultipleSelection = YES;
  
  [container addSubview:friendsListTableView];
  
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, friendsListTableView);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-12-[friendsListTableView(500)]" toView:container];
  // todo (calvin): this should scale to content / be scrollable yeah?
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
  return [self.myFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYNCFriendViewCellIdentifier];
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];

  cell.textLabel.text = user.firstName;
  cell.textLabel.font = [YNCFont standardFont];
  cell.textLabel.textColor = [UIColor blackColor];
  
  NSURL *url = [NSURL URLWithString:user.photoUrl];
  NSData *data = [NSData dataWithContentsOfURL:url];
  UIImage *img = [[UIImage alloc] initWithData:data];
  cell.imageView.image = img;
  cell.imageView.layer.cornerRadius = 22;
  cell.imageView.clipsToBounds = YES;

  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];
  [self.pickedFriends addObject:user.pfObject];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];
  [self.pickedFriends removeObject:user.pfObject];
}
/*
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];
  return [self.pickedFriends containsObject:user.pfObject];
}
 */

- (void)doneButtonPressed {

  [self.delegate friendPickerViewControllerDidSubmit:self withFriends:[self.pickedFriends allObjects]];
  [self.navigationController popViewControllerAnimated:YES];
  NSLog(@"done");
  
}

// todo (calvin): change done styling (teal stroke, bold names)

// delegate

/*
 
 - (void)sizeTableViewToFitResults {
 if (self.tableView.contentSize.height + kYESSearchBarHeight < self.view.frame.size.height) {
 self.tableView.frame =
 CGRectMake(self.tableView.frame.origin.x,
 self.tableView.frame.origin.y,
 self.tableView.contentSize.width,
 self.tableView.contentSize.height);
 } else {
 self.tableView.frame =
 CGRectMake(self.tableView.frame.origin.x,
 self.tableView.frame.origin.y,
 self.view.frame.size.width,
 self.view.frame.size.height - kYESSearchBarHeight);
 }
 }
 
 */


@end