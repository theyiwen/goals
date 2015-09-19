//
//  YNCLoginViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCLoginViewController.h"
#import "YNCAutoLayout.h"

@interface YNCLoginViewController ()

@property (strong, nonatomic) UILabel *appName;
@property (strong, nonatomic) UIImageView *appIcon;

@end

@implementation YNCLoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.logInView setLogo:nil];
  self.appName = [[UILabel alloc] init];
  self.appIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp_icon.png"]];
  [self.logInView insertSubview:self.appName atIndex:0];
  [self.logInView insertSubview:self.appIcon atIndex:1];
  self.appName.text = @"Goals";
  self.appName.textColor = [UIColor grayColor];
  NSDictionary *views = @{ @"title" : self.appName,
                           @"icon" : self.appIcon };
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:[icon]-20-[title]" toView:self.logInView];
  [autoLayout addConstraintForViews:@[self.appIcon, self.appName, self.logInView]
                equivalentAttribute:NSLayoutAttributeCenterX
                             toView:self.logInView];
  [autoLayout addConstraintWithItem:self.appName
                             toItem:self.logInView
                equivalentAttribute:NSLayoutAttributeCenterY
                         multiplier:1.1
                           constant:0 toView:self.logInView];
  
}

@end
