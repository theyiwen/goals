//
//  YNCListViewCell.m
//  Goals
//
//  Created by Calvin Lee on 10/4/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCFriendPickerCell.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCColor.h"

@interface YNCFriendPickerCell ()

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIImageView *avatarPicture;
@property (strong, nonatomic) UILabel *userNameLabel;

@end

@implementation YNCFriendPickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // configure control(s)
    UIView *container = self.container = [[UIView alloc] init];
    UIImageView *avatarPicture = self.avatarPicture = [[UIImageView alloc] init];
    UILabel *userNameLabel = self.userNameLabel = [[UILabel alloc] init];
    
    self.avatarPicture.layer.cornerRadius = 22;
    self.avatarPicture.clipsToBounds = YES;
    
    self.userNameLabel.font = [UIFont fontWithName:[YNCFont regularFontName] size:18];
    self.userNameLabel.textColor = [UIColor blackColor];

    [self.contentView addSubview:container];
    [container addSubview:self.avatarPicture];
    [container addSubview:self.userNameLabel];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(container, avatarPicture, userNameLabel);
    YNCAutoLayout *autoLayout =[[YNCAutoLayout alloc] initWithViews:views];

    [autoLayout addVflConstraint:@"H:|-16-[avatarPicture(44)]-16-[userNameLabel]-16-|" toView:self.container];
    [autoLayout addVflConstraint:@"V:[avatarPicture(44)]" toView:self.container];
    [autoLayout addVflConstraint:@"H:|[container]|" toView:self.contentView];
    [autoLayout addVflConstraint:@"V:|[container]|" toView:self.contentView];
    [autoLayout addConstraintForViews:@[container, avatarPicture, userNameLabel]
                  equivalentAttribute:NSLayoutAttributeCenterY
                               toView:self.container];
  }
  return self;
}

-(void)prepareForReuse
{
  [super prepareForReuse];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  if (selected) {
    self.userNameLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:18];
    self.avatarPicture.layer.borderWidth = 3.0f;
    self.avatarPicture.layer.borderColor = [YNCColor tealColor].CGColor;
  }
  else {
    self.avatarPicture.layer.borderWidth = 0.0f;
    self.userNameLabel.font = [UIFont fontWithName:[YNCFont regularFontName] size:18];
  }
}

- (void)setPicture:(UIImage *)image {
  self.avatarPicture.image = image;
}
- (void)setName:(NSString *)name {
  self.userNameLabel.text = name;
}

@end