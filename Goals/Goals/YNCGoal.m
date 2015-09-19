//
//  YNCGoal.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCGoal.h"
#import "YNCUser.h"

const struct YNCGoalPFKey YNCGoalPFKey = {
  .titleKey = @"title",
  .descriptionKey = @"description",
  .usersListKey = @"usersList"
};

@interface YNCGoal()

@property (nonatomic, readwrite) NSArray *users;
@property (strong, nonatomic) PFObject *pfObject;

@end

@implementation YNCGoal

- (instancetype)initWithPFObject:(PFObject *)pfObject {
  if (self = [super init]) {
    self.pfObject = pfObject;
  }
  return self;
}

- (NSString *)title {
  return (NSString *)self.pfObject[YNCGoalPFKey.titleKey];
}

- (NSString *)desc {
  return (NSString *)self.pfObject[YNCGoalPFKey.descriptionKey];
}

- (NSArray *)users {
  if (!_users) {
    NSMutableArray *usersBuilder = [[NSMutableArray alloc] init];
    for (PFObject *userObject in self.pfObject[YNCGoalPFKey.usersListKey]) {
      [usersBuilder addObject:[[YNCUser alloc] initWithPFObject:userObject]];
    }
    _users = [usersBuilder copy];
  }
  return _users;
}

+ (void)loadGoalsWithCallback:(void (^)(NSArray *goals, NSError *error))callback {
  PFQuery *query = [PFQuery queryWithClassName:[YNCGoal pfClassName]];
  [query orderByDescending:@"createdAt"];
  [query whereKey:YNCGoalPFKey.usersListKey equalTo:[PFUser currentUser]];
  [query includeKey:YNCGoalPFKey.usersListKey];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      NSMutableArray *goalsBuilder = [[NSMutableArray alloc] init];
      for (PFObject *object in objects) {
        [goalsBuilder addObject:[[YNCGoal alloc] initWithPFObject:object]];
      }
      callback([goalsBuilder copy], error);
    } else {
      NSLog(@"Error loading goals %@", error);
      callback(nil, error);
    }
  }];
}

+ (NSString *)pfClassName {
  return @"Goal";
}

@end
