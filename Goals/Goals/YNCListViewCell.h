//
//  YNCListViewCell.h
//  Goals
//
//  Created by Calvin Lee on 10/4/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNCListViewCell : UITableViewCell


- (void)setTitle:(NSString *)title;
- (void)setScore:(NSNumber *)score;
- (void)setMembersWithImages:(NSArray *)images
                       count:(NSInteger)count;

@end