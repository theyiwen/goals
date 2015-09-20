//
//  YNCFont.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCFont.h"

@implementation YNCFont

+ (NSString *)regularFontName {
  return @"Raleway";
}

+ (NSString *)boldFontName {
  return @"Raleway-ExtraBold";
}

+ (NSString *)semiBoldFontName {
  return @"Raleway-SemiBold";
}

+ (NSString *)lightFontName {
  return @"Raleway-Light";
}

+ (UIFont *)standardFont {
  return [UIFont fontWithName:[YNCFont regularFontName] size:18];
}

+ (void)printFontNames {
  for (NSString* family in [UIFont familyNames]) {
    for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
      NSLog(@"  %@", name);
    }
  }
}

@end
