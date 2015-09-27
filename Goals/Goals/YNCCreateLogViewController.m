//
//  YNCCreateLogViewController.m
//  Goals
//
//  Created by Yiwen Zhan on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateLogViewController.h"
#import "YNCAutoLayout.h"
#import "YNCLog.h"
#import "YNCFont.h"
#import "YNCColor.h"

CGFloat const kAnimationDuration = 0.4;

@interface YNCCreateLogViewController ()<UITextFieldDelegate, UITextViewDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) UITextField *countEntry;
@property (strong, nonatomic) UITextField *notesEntry;
@property (strong, nonatomic) UILabel *dailyTitle;
@property (strong, nonatomic) UILabel *countPlaceholder;
@property (strong, nonatomic) UILabel *notesPlaceholder;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *outerContainer;
@property (strong, nonatomic) UIView *countBottomBorder;
@property (strong, nonatomic) UIView *notesBottomBorder;
@property (nonatomic) GoalType goalType;

@end

@implementation YNCCreateLogViewController

- (instancetype)initWithGoalType:(GoalType)type {
  if (self = [super init]) {
    self.goalType = type;
    self.transitioningDelegate = self;

  }
  return self;
}

- (void)loadView {
  self.view = [[UIView alloc] init];
  UITextField *countEntry = self.countEntry = [[UITextField alloc] init];
  UITextField *notesEntry = self.notesEntry = [[UITextField alloc] init];
  UILabel *dailyTitle = self.dailyTitle = [[UILabel alloc] init];
  UILabel *countPlaceholder = self.countPlaceholder = [[UILabel alloc] init];
  UILabel *notesPlaceholder = self.notesPlaceholder = [[UILabel alloc] init];
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  UIButton *cancelButton = self.cancelButton = [[UIButton alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  UIView *outerContainer = self.outerContainer = [[UIView alloc] init];
  UIView *countBottomBorder = self.countBottomBorder = [[UIView alloc] init];
  UIView *notesBottomBorder = self.notesBottomBorder = [[UIView alloc] init];


  [self.view addSubview:outerContainer];
  [self.view addSubview:container];
  [container addSubview:dailyTitle];
  [container addSubview:countEntry];
  [container addSubview:notesEntry];
  [container addSubview:countPlaceholder];
  [container addSubview:notesPlaceholder];
  [container addSubview:countBottomBorder];
  [container addSubview:notesBottomBorder];
  [container addSubview:submitButton];
  [container addSubview:cancelButton];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, countEntry, notesEntry,
                                                       countPlaceholder, notesPlaceholder,
                                                       submitButton, cancelButton, countBottomBorder, notesBottomBorder, dailyTitle, outerContainer);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|[outerContainer]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[outerContainer]|" toView:self.view];

  [autoLayout addVflConstraint:@"V:|-20-[dailyTitle]" toView:container];
  [autoLayout addVflConstraint:@"V:|-14-[cancelButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-150-[container]" toView:self.view];
  [autoLayout addVflConstraint:@"H:|-50-[container]-50-|" toView:self.view];

  [autoLayout addVflConstraint:@"H:[submitButton(100)]" toView:submitButton];
  [autoLayout addVflConstraint:@"H:|-11-[cancelButton]" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[countEntry]-20-|" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[dailyTitle]-20-|" toView:container];

  [autoLayout addVflConstraint:@"H:|-20-[notesEntry]-20-|" toView:container];
  [autoLayout addConstraintForViews:@[dailyTitle, submitButton, container, self.view]
                equivalentAttribute:NSLayoutAttributeCenterX
                             toView:self.view];
  [autoLayout addConstraintForViews:@[countEntry, countPlaceholder, countBottomBorder] equivalentAttribute:NSLayoutAttributeLeft toView:self.view];
  [autoLayout addConstraintForViews:@[countEntry, countPlaceholder] equivalentAttribute:NSLayoutAttributeTop toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesPlaceholder, notesBottomBorder] equivalentAttribute:NSLayoutAttributeLeft toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesPlaceholder] equivalentAttribute:NSLayoutAttributeTop toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesBottomBorder, countEntry, countBottomBorder] equivalentAttribute:NSLayoutAttributeWidth toView:self.view];
//  [autoLayout addConstraintForView:submitButton withSize:CGSizeMake(75,75) toView:submitButton];
  [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  self.cancelButton.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.submitButton.enabled = NO;
  self.countPlaceholder.text = @"amount".uppercaseString;
  self.notesPlaceholder.text = @"notes".uppercaseString;
  self.countEntry.delegate = self;
  self.notesEntry.delegate = self;
  self.countEntry.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.notesPlaceholder.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.countPlaceholder.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.notesEntry.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.countPlaceholder.textColor = [UIColor lightGrayColor];
  self.notesPlaceholder.textColor = [UIColor lightGrayColor];
  self.notesEntry.text = @"";
  countBottomBorder.backgroundColor = [YNCColor tealColor];
  notesBottomBorder.backgroundColor = [YNCColor tealColor];
  self.notesEntry.tag = 2;
  self.countEntry.tag = 1;
  [self.countEntry addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  [self.notesEntry addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
  self.dailyTitle.textColor = [UIColor blackColor];
  self.dailyTitle.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.dailyTitle.textAlignment = NSTextAlignmentCenter;
  self.dailyTitle.text = @"I did this today!".uppercaseString;

  self.container.backgroundColor = [UIColor whiteColor];
  
  [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor colorWithWhite:0.7f alpha:1.0f] forState:UIControlStateDisabled];
  submitButton.layer.borderColor = [YNCColor tealColor].CGColor;
  submitButton.layer.borderWidth = 2.0f;
  submitButton.layer.cornerRadius = 8;
  [self.submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.container.layer.cornerRadius = 10;
  self.countEntry.keyboardType = UIKeyboardTypeNumberPad;
  self.view.backgroundColor = [UIColor clearColor];
  
  if (self.goalType == daily) {
    [autoLayout addVflConstraint:@"V:[dailyTitle]-20-[notesEntry]-5-[notesBottomBorder(2)]-20-[submitButton]-20-|" toView:container];
    self.countEntry.hidden = YES;
    self.countPlaceholder.hidden = YES;
    self.countBottomBorder.hidden = YES;
    self.submitButton.enabled = YES;
  } else if (self.goalType == sum) {
    [autoLayout addVflConstraint:@"V:[dailyTitle]-20-[countEntry]-5-[countBottomBorder(2)]-20-[notesEntry]-5-[notesBottomBorder(2)]-20-[submitButton]-20-|" toView:container];
  }
  
  self.cancelButton.hidden = YES;
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
  [outerContainer addGestureRecognizer:tap];
}

- (void)viewTapped:(UIGestureRecognizer *)tapGesture {
  [self dismiss];
}

- (void)viewWillAppear:(BOOL)animated {
  if (self.goalType == daily) {
    [self.notesEntry becomeFirstResponder];
  } else if (self.goalType == sum) {
    [self.countEntry becomeFirstResponder];
  }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//  if (textField.tag == 1) {
//    self.countPlaceholder.hidden = YES;
//  }
//  if (textField.tag == 2) {
//    self.notesPlaceholder.hidden = YES;
//  }
}

- (void)textFieldDidChange:(UITextField *)textField {
  if (textField.tag == 1) {
    if (self.countEntry.text.length > 0) {
      self.countPlaceholder.hidden = YES;
      self.submitButton.enabled = YES;
    } else {
      self.countPlaceholder.hidden = NO;
      self.submitButton.enabled = NO;
    }
  }
  if (textField.tag == 2) {
    if (self.notesEntry.text.length > 0) {
      self.notesPlaceholder.hidden = YES;
    } else {
      self.notesPlaceholder.hidden = NO;
    }
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField.tag == 1) {
    if (self.countEntry.text.length > 0) {
      self.submitButton.enabled = YES;
    } else {
      self.countPlaceholder.hidden = NO;
    }
  } else if (textField.tag == 2) {
    if (self.notesEntry.text.length == 0) {
      self.notesPlaceholder.hidden = NO;
    }
  }
}

- (void)submitButtonPressed {
  NSLog(@"submit pressed");
  if (self.goalType == sum && self.countEntry.text.length == 0) {
    NSLog(@"Shouldn't be here");
  } else {
    NSNumber *value = @((self.goalType == sum) ? [self.countEntry.text floatValue] : 1);
    [self.delegate createLogViewControllerDidSubmit:self
                                          withValue:value
                                              notes:self.notesEntry.text];
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}

- (void)cancelButtonPressed {
  [self dismiss];
}

- (void)dismiss {
  NSLog(@"dismiss");
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
  return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
  return kAnimationDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  if ([fromVC isKindOfClass:[self class]]) {
    CGRect frame = fromVC.view.frame;
    frame.origin.y = fromVC.view.bounds.size.height;
    [fromVC resignFirstResponder];
    [UIView animateWithDuration:kAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       fromVC.view.frame=frame;
                       toVC.view.alpha = 1;
                     } completion:^(BOOL finished) {
                       [fromVC.view removeFromSuperview];
                       [transitionContext completeTransition:YES];
                     }];
  } else {
    UIView *contextView = [transitionContext containerView];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame =
      CGRectMake(0, fromVC.view.bounds.size.height, finalFrame.size.width, finalFrame.size.height);
    [contextView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:0.9
          initialSpringVelocity:5.0f
                        options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                       fromVC.view.alpha = 0.5;
                       toVC.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                       [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
  }
  
}


@end
