//
//  YNC.h
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNCAutoLayout : NSObject

- (instancetype)initWithViews:(NSDictionary *)views metrics:(NSDictionary *)metrics
NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithViews:(NSDictionary *)views;


/**
 Generates a set of constraints based on VFL string, and optionally adds them to a view.
 @param string Auto layout constraint in visual language format
 @param view UIView to add constraint to. Must be common ancestor of all views in VFL string.
 Can be nil if you don't want to add constraints to a view.
 */
- (NSArray *)addVflConstraint:(NSString *)string toView:(UIView *)view;

/**
 Generates a set of size constraints, and optionally adds to view.
 @param forView UIView the size constraint describes.
 @param size CGSize specifying size of view
 @param toView UIView the size constraint should be added to, which often is the same as forView.
 Can be nil if you don't want to add constraints to a view.
 */
- (NSArray *)addConstraintForView:(UIView *)forView withSize:(CGSize)size toView:(UIView *)toView;

/**
 Generates a set of equality constraints for a given attribute, and optionally adds them to a view.
 @param views NSArray of views for which the equality constraint applies to
 @param attribute NSLayoutAttribute that is equivalent in views
 @param toViews UIView the equality constraints should be added to. Must be common ancestor of all
 views for which this constraint applies. Can be nil if you don't want to add constraints
 to a view.
 */
- (NSArray *)addConstraintForViews:(NSArray *)views
               equivalentAttribute:(NSLayoutAttribute)attribute
                            toView:(UIView *)toView;

/**
 Generates a set of constraints that center, both horizontally and vertically,
 the array of views with each other.
 @param views NSArray of views to center
 @param toView UIView the constraints to add the constraints to. Must be common ancestor of all
 views for which this constraint applies to. Can be nil if you don't want to add constraints to
 a view.
 @return NSArray of NSLayoutConstraints that represent the centering
 */
- (NSArray *)addCenteringConstraintForViews:(NSArray *)views
                                     toView:(UIView *)toView;

/**
 Generates an equality constraint for two views, given an attribute, multiplier and constant.
 Optionally adds to view (if view is not nil).
 */
- (NSLayoutConstraint *)addConstraintWithItem:(UIView *)withItem
                                       toItem:(UIView *)toItem
                          equivalentAttribute:(NSLayoutAttribute)attribute
                                   multiplier:(CGFloat)multipler
                                     constant:(CGFloat)constant
                                       toView:(UIView *)view;

@end
