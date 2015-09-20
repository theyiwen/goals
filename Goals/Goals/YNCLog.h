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
  __unsafe_unretained NSString *count;
  __unsafe_unretained NSString *notes;
} logKey;

@interface YNCLog : NSObject

@property (nonatomic, readonly) YNCGoal *goal;
@property (nonatomic, readonly) YNCUser *user;
@property (nonatomic, readonly) NSString *notes;
@property (nonatomic, readonly) NSNumber *count;

+ (void)createAndSaveLogWithGoal:(YNCGoal *)goal
                           count:(NSNumber *)count
                           notes:(NSString *)notes;

@end
