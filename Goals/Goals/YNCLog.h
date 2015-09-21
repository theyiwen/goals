//
//  YNCLog.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNCGoal.h"
#import "YNCUser.h"

extern const struct logKey {
  __unsafe_unretained NSString *goal;
  __unsafe_unretained NSString *user;
  __unsafe_unretained NSString *value;
  __unsafe_unretained NSString *notes;
  __unsafe_unretained NSString *date;
} logKey;

@interface YNCLog : NSObject

@property (nonatomic, readonly) YNCGoal *goal;
@property (nonatomic, readonly) YNCUser *user;
@property (nonatomic, readonly) NSString *notes;
@property (nonatomic, readonly) NSNumber *value;
@property (nonatomic, readonly) NSDate *date;

+ (void)createAndSaveLogWithGoal:(YNCGoal *)goal
                           value:(NSNumber *)value
                           notes:(NSString *)notes;

+ (void)getAllLogsForGoal:(YNCGoal *)goal
             withCallback:(void (^)(NSArray *logs, NSError *error))callback;

@end
