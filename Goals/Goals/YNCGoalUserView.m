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
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIView *circle;

@property (strong, nonatomic) YNCUser *user;
@property (strong, nonatomic) UIColor *color;

@end

@implementation YNCGoalUserView
- (instancetype)initWithUser:(YNCUser *)user color:(UIColor *)color {
  if (self = [super initWithFrame:CGRectZero]) {
    _name = [[UILabel alloc] init];
    _scoreLabel = [[UILabel alloc] init];
    _photo = [[UIImageView alloc] init];
    _circle = [[UIView alloc] init];
    
    [self addSubview:_name];
    [self addSubview:_scoreLabel];
    [self addSubview:_circle];
    [self addSubview:_photo];
    
    NSDictionary *views = @{ @"name" : _name,
                             @"photo" : _photo,
                             @"score" : _scoreLabel,
                             @"self" : self,
                             @"circle" : _circle };
    YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
    [autoLayout addConstraintForView:self withSize:CGSizeMake(kYNCGoalUserViewWidth, 70) toView:self];
    [autoLayout addVflConstraint:@"V:|-5-[circle]-2-[score]" toView:self];
    [autoLayout addConstraintForView:self.photo withSize:CGSizeMake(40, 40) toView:self.photo];
    [autoLayout addConstraintForView:self.circle withSize:CGSizeMake(45, 45) toView:self.circle];

    [autoLayout addConstraintForViews:@[self, _photo, _scoreLabel]
                  equivalentAttribute:NSLayoutAttributeCenterX
                               toView:self];
    [autoLayout addCenteringConstraintForViews:@[_circle, _photo] toView:self];
    
    self.photo.layer.cornerRadius = 20;
    self.circle.layer.cornerRadius = 22.5;
    

    self.photo.clipsToBounds = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.scoreLabel.font = [UIFont fontWithName:[YNCFont lightFontName] size:15];
    self.user = user;
    self.color = color;
  }
  return self;
}

- (void)setScore:(NSNumber *)score {
  _score = score;
  _scoreLabel.text = [NSString stringWithFormat:@"%@", score];
}

- (void)setUser:(YNCUser *)user {
  _user = user;
  self.name.text = _user.fullName;
  self.name.hidden = YES;
  NSURL *url = [NSURL URLWithString:_user.photoUrl];
  NSData *data = [NSData dataWithContentsOfURL:url];
  UIImage *img = [[UIImage alloc] initWithData:data];
  self.photo.contentMode = UIViewContentModeScaleAspectFit;
  [self.photo setImage:img];
}

- (void)setColor:(UIColor *)color {
  _color = color;
  self.circle.backgroundColor = _color;
}

@end
