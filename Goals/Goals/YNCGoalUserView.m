//
//  YNCGoalUserView.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCGoalUserView.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"

@interface YNCGoalUserView()

@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UIImageView *photo;

@property (strong, nonatomic) YNCUser *user;

@end

@implementation YNCGoalUserView

- (instancetype)initWithUser:(YNCUser *)user {
  if (self = [super initWithFrame:CGRectZero]) {
    _user = user;
    _name = [[UILabel alloc] init];
    _photo = [[UIImageView alloc] init];
    
    [self addSubview:_name];
    [self addSubview:_photo];
    
    NSDictionary *views = @{ @"name" : _name,
                             @"photo" : _photo,
                             @"self" : self };
    YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
    [autoLayout addVflConstraint:@"H:|-20-[photo]-20-[name]" toView:self];
    [autoLayout addConstraintForView:self.photo withSize:CGSizeMake(40, 40) toView:self.photo];
    [autoLayout addVflConstraint:@"V:[self(50)]" toView:self];
    [autoLayout addConstraintForViews:@[self, _name, _photo]
                  equivalentAttribute:NSLayoutAttributeCenterY
                               toView:self];

    self.photo.layer.cornerRadius = 20;
    
    self.name.text = self.user.fullName;
    NSURL *url = [NSURL URLWithString:self.user.photoUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    self.photo.contentMode = UIViewContentModeScaleAspectFit;
    [self.photo setImage:img];
    self.photo.clipsToBounds = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.name.font = [YNCFont standardFont];

  }
  return self;
}

@end
