//
//  YNCFont.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNCFont : NSObject

+ (NSString *)regularFontName;
+ (NSString *)boldFontName;
+ (NSString *)lightFontName;
+ (UIFont *)standardFont;
+ (void)printFontNames;

@end
