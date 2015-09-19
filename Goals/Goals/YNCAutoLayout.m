//
//  YNC.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCAutoLayout.h"

@interface YNCAutoLayout()

@property (strong, nonatomic) NSDictionary *views;
@property (strong, nonatomic) NSDictionary *metrics;

@end

@implementation YNCAutoLayout

- (instancetype)initWithViews:(NSDictionary *)views
{
  return [self initWithViews:views metrics:nil];
}

- (instancetype)initWithViews:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  if (self = [super init]) {
    _views = views;
    _metrics = metrics;
  }
  for (NSString *viewKey in views) {
    ((UIView *)views[viewKey]).translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

- (instancetype)init {
  return [self initWithViews:nil metrics:nil];
}

- (NSArray *)addVflConstraint:(NSString *)string toView:(UIView *)view {
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:string
                                                                 options:0
                                                                 metrics:self.metrics
                                                                   views:self.views];
  if (view) {
    [view addConstraints:constraints];
  }
  return constraints;
}

- (NSArray *)addConstraintForView:(UIView *)forView withSize:(CGSize)size toView:(UIView *)toView {
  NSMutableArray *constraints = [[NSMutableArray alloc] init];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:forView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:size.width]];
  [constraints addObject:[NSLayoutConstraint constraintWithItem:forView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:size.height]];
  if (toView) {
    [toView addConstraints:constraints];
  }
  return [constraints copy];
}

- (NSArray *)addConstraintForViews:(NSArray *)views
               equivalentAttribute:(NSLayoutAttribute)attribute
                            toView:(UIView *)toView {
  NSMutableArray *constraints = [[NSMutableArray alloc] init];
  if ([views count] < 2) {
    NSLog(@"Error: Array must have more than one view to setup equality constraint");
    return nil;
  }
  for (int i = 0; i < [views count] - 1; i++) {
    [constraints addObject:[NSLayoutConstraint constraintWithItem:views[i]
                                                        attribute:attribute
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:views[i+1]
                                                        attribute:attribute
                                                       multiplier:1
                                                         constant:0]];
  }
  if (toView) {
    [toView addConstraints:constraints];
  }
  return [constraints copy];
}

- (NSArray *)addCenteringConstraintForViews:(NSArray *)views
                                     toView:(UIView *)toView {
  NSMutableArray *constraints = [[NSMutableArray alloc] init];
  if ([views count] < 2) {
    NSLog(@"Error: Array must have more than one view to setup equality constraint");
    return nil;
  }
  for (int i = 0; i < [views count] - 1; i++) {
    [constraints addObject:[NSLayoutConstraint constraintWithItem:views[i]
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:views[i+1]
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1
                                                         constant:0]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:views[i]
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:views[i+1]
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1
                                                         constant:0]];
  }
  if (toView) {
    [toView addConstraints:constraints];
  }
  return [constraints copy];
}

- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)withItem
                                       toItem:(UIView *)toItem
                          equivalentAttribute:(NSLayoutAttribute)attribute
                                   multiplier:(CGFloat)multipler
                                     constant:(CGFloat)constant
                                       toView:(UIView *)view {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:withItem
                                                                attribute:attribute
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:toItem
                                                                attribute:attribute
                                                               multiplier:multipler
                                                                 constant:constant];
  if (view) {
    [view addConstraint:constraint];
  }
  return constraint;
}

@end
