//
//  YNCUser.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

extern const struct userKey {
  __unsafe_unretained NSString *facebookId;
  __unsafe_unretained NSString *firstName;
  __unsafe_unretained NSString *lastName;
  __unsafe_unretained NSString *photoUrl;
} userKey;

@interface YNCUser : NSObject

@property (nonatomic, readonly) NSString *firstName;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) NSString *facebookId;
@property (nonatomic, readonly) NSString *photoUrl;

- (instancetype)initWithPFObject:(PFObject *)pfObject;
- (void)fetchAndSaveFBData;

@end
