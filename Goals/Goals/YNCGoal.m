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
  .usersListKey = @"usersList",
  .typeKey = @"type",
  .durationKey = @"duration",
  .startDateKey = @"startDate",
};

@interface YNCGoal()

@property (nonatomic, readwrite) NSArray *users;
@property (strong, readwrite) PFObject *pfObject;

@end

@implementation YNCGoal

- (instancetype)initWithPFObject:(PFObject *)pfObject {
  if (self = [super init]) {
    self.pfObject = pfObject;
  }
  return self;
}

- (NSString *)pfID {
  return self.pfObject.objectId;
}

- (NSString *)title {
  return (NSString *)self.pfObject[YNCGoalPFKey.titleKey];
}

- (NSString *)desc {
  return (NSString *)self.pfObject[YNCGoalPFKey.descriptionKey];
}

- (GoalType)type {
  NSString *type = (NSString *)self.pfObject[YNCGoalPFKey.typeKey];
  if ([type isEqualToString:@"daily"]) {
    return daily;
  }
  else if ([type isEqualToString:@"sum"]) {
    return sum;
  }
  return 0;
}

- (NSNumber *)duration {
  return (NSNumber *)self.pfObject[YNCGoalPFKey.durationKey];
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

- (NSDate *)startDate {
  return self.pfObject[YNCGoalPFKey.startDateKey];
}

- (NSDate *)endDate {
  if (!_endDate) {
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = [self.duration integerValue];
    _endDate = [[NSCalendar currentCalendar]dateByAddingComponents:dateComponents
                                                            toDate:self.startDate
                                                           options:0];
  }
  return _endDate;
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

+ (void)createAndSaveGoalWithTitle:(NSString *)title
                              desc:(NSString *)desc
                              type:(GoalType)type
                          duration:(NSNumber *)duration
                         usersList:(NSArray *)usersList {
  PFObject *pfObject = [PFObject objectWithClassName:@"Goal"];
  pfObject[YNCGoalPFKey.titleKey] = title;
  pfObject[YNCGoalPFKey.descriptionKey] = desc;
  pfObject[YNCGoalPFKey.durationKey] = duration;
  pfObject[YNCGoalPFKey.startDateKey] = [NSDate date];
  if (type == daily) {
    pfObject[YNCGoalPFKey.typeKey] = @"daily";
  }
  else if (type == sum) {
    pfObject[YNCGoalPFKey.typeKey] = @"sum";
  }
  pfObject[YNCGoalPFKey.usersListKey] = usersList;
  [pfObject saveInBackgroundWithBlock:nil];
  
}

+ (void)scheduleNotificationsForGoals:(NSArray *)goals
{
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
  //for (int i = 0; i < maxDuration; i++) {
    //
  //}
  
  if (!goals) return;
  
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  calendar.timeZone = [NSTimeZone defaultTimeZone];
  NSDate *endDate = nil; // Latest date
  
  for (YNCGoal* goal in goals)
  {
    NSDate *date = [goal endDate];
    
    if (endDate == nil)
    {
      endDate = date;
    }
    if ([date compare:endDate] == NSOrderedDescending)
    {
      endDate = date;
    }
    
  }
  
  NSLog(@"latest date: %@", endDate);
  NSLog(@"adjusted date: %@", [calendar startOfDayForDate:endDate]);
  
  int kAlertTime: 20*60*60;
  
  for ( nextDate = startDate ; [nextDate compare:endDate] < 0 ; nextDate = [nextDate addTimeInterval:24*60*60] ) {
    // use date
  }
  
  UILocalNotification* localNotif = [[UILocalNotification alloc] init];
  if (localNotif == nil)
    return;
  localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
  localNotif.timeZone = [NSTimeZone defaultTimeZone];
  
  // Notification details
  
  NSString *message = @"Don't forget to track your goals today!";
  localNotif.alertBody = message;
  
  // Set the action button
  localNotif.alertAction = @"Open App";
  
  // Schedule the notification
  [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
  NSLog(@"scheduled");
}

@end

