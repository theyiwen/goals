//
//  YNCGoal.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

extern const struct YNCGoalPFKey {
  __unsafe_unretained NSString *titleKey;
  __unsafe_unretained NSString *descriptionKey;
  __unsafe_unretained NSString *durationKey;
  __unsafe_unretained NSString *typeKey;
  __unsafe_unretained NSString *usersListKey;
} YNCGoalPFKey;

typedef enum {
  daily,
  sum
} GoalType;

@interface YNCGoal : NSObject

@property (strong, nonatomic, readonly) PFObject *pfObject;
@property (strong, nonatomic, readonly) NSArray *users;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic) GoalType type; // i hope this is right
@property (nonatomic, copy) NSNumber *duration;
@property (nonatomic, copy) NSString *pfID;

- (instancetype)initWithPFObject:(PFObject *)pfObject;
+ (void)loadGoalsWithCallback:(void (^)(NSArray *goals, NSError *error))callback;
+ (NSString *)pfClassName;
+ (void)createAndSaveGoalWithTitle:(NSString *)title
                              desc:(NSString *)desc
                              type:(GoalType)type
                          duration:(NSNumber *)duration
                         usersList:(NSArray *)usersList;
@end
