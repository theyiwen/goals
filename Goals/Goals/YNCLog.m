//
//  YNCLog.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCLog.h"

const struct logKey logKey = {
  .goal = @"goal",
  .user = @"user",
  .count = @"count",
  .notes = @"notes",
};

@interface YNCLog()

@property (strong, nonatomic) PFObject *pfObject;
@property (nonatomic, readwrite) YNCGoal *goal;
@property (nonatomic, readwrite) YNCUser *user;
@property (nonatomic, readwrite) NSString *notes;
@property (nonatomic, readwrite) NSNumber *count;

@end

@implementation YNCLog

- (instancetype)initWithPFObject:(PFObject *)pfObject {
  if (self = [super init]) {
    self.pfObject = pfObject;
  }
  return self;
}

- (YNCGoal *)goal {
  if (!_goal) {
    _goal = [[YNCGoal alloc] initWithPFObject:self.pfObject[logKey.goal]];
  }
  return _goal;
}

- (YNCUser *)user {
  if (!_user) {
    _user = [[YNCUser alloc] initWithPFObject:self.pfObject[logKey.user]];
  }
  return _user;
}

- (NSString *)notes {
  return self.pfObject[logKey.notes];
}

- (NSNumber *)count {
  return self.pfObject[logKey.count];
}

+ (void)createAndSaveLogWithGoal:(YNCGoal *)goal
                           count:(NSNumber *)count
                           notes:(NSString *)notes {
  PFObject *pfObject = [PFObject objectWithClassName:@"Log"];
  pfObject[logKey.goal] = goal.pfObject;
  pfObject[logKey.user] = [PFUser currentUser];
  pfObject[logKey.count] = count;
  pfObject[logKey.notes] = notes;
  [pfObject saveInBackgroundWithBlock:nil];
}


@end
