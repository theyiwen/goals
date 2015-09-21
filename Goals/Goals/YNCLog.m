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
  .value = @"value",
  .notes = @"notes",
  .date = @"date"
};

@interface YNCLog()

@property (strong, nonatomic) PFObject *pfObject;
@property (nonatomic, readwrite) YNCGoal *goal;
@property (nonatomic, readwrite) YNCUser *user;
@property (nonatomic, readwrite) NSString *notes;
@property (nonatomic, readwrite) NSNumber *value;

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

- (NSNumber *)value {
  return self.pfObject[logKey.value];
}

- (NSDate *)date {
  return self.pfObject[logKey.date];
}

+ (void)createAndSaveLogWithGoal:(YNCGoal *)goal
                           value:(NSNumber *)value
                           notes:(NSString *)notes {
  PFObject *pfObject = [PFObject objectWithClassName:@"Log"];
  pfObject[logKey.goal] = goal.pfObject;
  pfObject[logKey.user] = [PFUser currentUser];
  pfObject[logKey.value] = value;
  pfObject[logKey.notes] = notes;
  [pfObject saveInBackgroundWithBlock:nil];
}

+ (void)getAllLogsForGoal:(YNCGoal *)goal withCallback:(void (^)(NSArray *, NSError *))callback {
  PFQuery *query = [PFQuery queryWithClassName:[YNCLog pfClassName]];
  [query orderByDescending:@"createdAt"];
  [query whereKey:logKey.goal equalTo:goal.pfObject];
  [query includeKey:logKey.user];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      NSMutableArray *logsBuilder = [[NSMutableArray alloc] init];
      for (PFObject *object in objects) {
        [logsBuilder addObject:[[YNCLog alloc] initWithPFObject:object]];
      }
      callback([logsBuilder copy], error);
    } else {
      NSLog(@"Error loading logs %@", error);
      callback(nil, error);
    }
  }];
}

+ (NSString *)pfClassName {
  return @"Log";
}


@end
