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
  __unsafe_unretained NSString *usersListKey;
} YNCGoalPFKey;

@interface YNCGoal : NSObject

@property (strong, nonatomic, readonly) PFObject *pfObject;
@property (strong, nonatomic, readonly) NSArray *users;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *pfID;

- (instancetype)initWithPFObject:(PFObject *)pfObject;
+ (void)loadGoalsWithCallback:(void (^)(NSArray *goals, NSError *error))callback;
+ (NSString *)pfClassName;

@end
