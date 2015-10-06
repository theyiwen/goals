//
//  YNCUser.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Parse/Parse.h>

const struct userKey userKey = {
  .facebookId = @"facebookId",
  .firstName = @"firstName",
  .lastName = @"lastName",
  .photoUrl = @"photoUrl"
};

@interface YNCUser()

@property (strong, nonatomic, readwrite) PFObject *pfObject;
@property (nonatomic, readwrite) NSString *firstName;
@property (nonatomic, readwrite) NSString *lastName;
@property (nonatomic, readwrite) NSString *facebookId;
@property (nonatomic, readwrite) NSString *photoUrl;

@end

@implementation YNCUser

- (instancetype)initWithPFObject:(PFObject *)pfObject {
  if (self = [super init]) {
    self.pfObject = pfObject;
  }
  return self;
}

- (NSString *)pfID {
  return self.pfObject.objectId;
}

- (NSString *)firstName {
  return self.pfObject[userKey.firstName];
}

- (NSString *)lastName {
  return self.pfObject[userKey.lastName];
}

- (NSString *)fullName {
  return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)photoUrl {
  return self.pfObject[userKey.photoUrl];
}

- (void)fetchAndSaveFBData {
  NSLog(@"Access Token %@", [FBSDKAccessToken currentAccessToken]);
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me?fields=id,first_name,last_name" parameters:nil];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (!error) {
      // result is a dictionary with the user's Facebook data
      NSDictionary *userData = (NSDictionary *)result;
      self.pfObject[userKey.facebookId] = userData[@"id"];
      self.pfObject[userKey.firstName] = userData[@"first_name"];
      self.pfObject[userKey.lastName] = userData[@"last_name"];
      self.pfObject[userKey.photoUrl] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square&return_ssl_resources=1", userData[@"id"]];
      [self.pfObject saveInBackground];
    } else {
      NSLog(@"Error fetching Facbeook data");
    }
  }];
}

+ (NSString *)pfClassName {
  return @"_User";
}

+ (void)loadUsersWithFacebookIDs:(NSArray *)ids
                        Callback:(void (^)(NSArray *users, NSError *error))callback {
  PFQuery *query = [PFQuery queryWithClassName:[YNCUser pfClassName]];
  [query orderByAscending:@"firstName"];
  [query whereKey:userKey.facebookId containedIn:ids];
  query.cachePolicy = kPFCachePolicyNetworkElseCache;
  [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
      NSMutableArray *usersBuilder = [[NSMutableArray alloc] init];
      for (PFObject *object in objects) {
        [usersBuilder addObject:[[YNCUser alloc] initWithPFObject:object]];
      }
      callback([usersBuilder copy], error);
    } else {
      NSLog(@"Error loading users %@", error);
      callback(nil, error);
    }
  }];
}

@end
