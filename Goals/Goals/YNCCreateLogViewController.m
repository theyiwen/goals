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

@interface YNCCreateLogViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *countEntry;
@property (strong, nonatomic) UITextField *notesEntry;
@property (strong, nonatomic) UILabel *countPlaceholder;
@property (strong, nonatomic) UILabel *notesPlaceholder;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UIView *countBottomBorder;
@property (strong, nonatomic) UIView *notesBottomBorder;

@end

@implementation YNCCreateLogViewController

- (void)loadView {
  self.view = [[UIView alloc] init];
  UITextField *countEntry = self.countEntry = [[UITextField alloc] init];
  UITextField *notesEntry = self.notesEntry = [[UITextField alloc] init];
  UILabel *countPlaceholder = self.countPlaceholder = [[UILabel alloc] init];
  UILabel *notesPlaceholder = self.notesPlaceholder = [[UILabel alloc] init];
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  UIButton *cancelButton = self.cancelButton = [[UIButton alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  UIView *countBottomBorder = self.countBottomBorder = [[UIView alloc] init];
  UIView *notesBottomBorder = self.notesBottomBorder = [[UIView alloc] init];


  [self.view addSubview:container];
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
                                                       submitButton, cancelButton, countBottomBorder, notesBottomBorder);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
//  [autoLayout addConstraintForView:container withSize:CGSizeMake(300, 300) toView:container];
  [autoLayout addVflConstraint:@"V:|-10-[cancelButton]-20-[countEntry]-5-[countBottomBorder(2)]-20-[notesEntry]-5-[notesBottomBorder(2)]-20-[submitButton]-20-|" toView:container];
  [autoLayout addVflConstraint:@"V:|-100-[container]" toView:self.view];
  [autoLayout addVflConstraint:@"H:|-50-[container]-50-|" toView:self.view];

  [autoLayout addVflConstraint:@"H:|-10-[cancelButton]" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[countEntry]-20-|" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[notesEntry]-20-|" toView:container];
  [autoLayout addConstraintForViews:@[submitButton, container, self.view]
                equivalentAttribute:NSLayoutAttributeCenterX
                             toView:self.view];
  [autoLayout addConstraintForViews:@[countEntry, countPlaceholder, countBottomBorder] equivalentAttribute:NSLayoutAttributeLeft toView:self.view];
  [autoLayout addConstraintForViews:@[countEntry, countPlaceholder] equivalentAttribute:NSLayoutAttributeTop toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesPlaceholder, notesBottomBorder] equivalentAttribute:NSLayoutAttributeLeft toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesPlaceholder] equivalentAttribute:NSLayoutAttributeTop toView:self.view];
  [autoLayout addConstraintForViews:@[notesEntry, notesBottomBorder, countEntry, countBottomBorder] equivalentAttribute:NSLayoutAttributeWidth toView:self.view];
  [autoLayout addConstraintForView:submitButton withSize:CGSizeMake(75,75) toView:submitButton];
  [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  self.cancelButton.titleLabel.font = [YNCFont standardFont];
  self.submitButton.enabled = NO;
  self.countPlaceholder.text = @"add number".uppercaseString;
  self.notesPlaceholder.text = @"add notes".uppercaseString;
  self.countEntry.delegate = self;
  self.notesEntry.delegate = self;
  self.countEntry.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.notesPlaceholder.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.countPlaceholder.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.notesEntry.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  self.notesEntry.text = @"";
  countBottomBorder.backgroundColor = [YNCColor tealColor];
  notesBottomBorder.backgroundColor = [YNCColor tealColor];
  self.notesEntry.tag = 2;
  self.countEntry.tag = 1;
  [self.countEntry addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];

  self.container.backgroundColor = [UIColor whiteColor];
  
  [self.submitButton setImage:[UIImage imageNamed:@"add_button.png"] forState:UIControlStateNormal];
  [self.submitButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [self.cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  self.container.layer.cornerRadius = 10;
  self.container.layer.borderWidth = 2;
  self.countEntry.keyboardType = UIKeyboardTypeDecimalPad;
  self.view.backgroundColor = [UIColor clearColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (textField.tag == 1) {
    self.countPlaceholder.hidden = YES;
  }
  if (textField.tag == 2) {
    self.notesPlaceholder.hidden = YES;
  }
}

- (void)textFieldDidChange:(UITextField *)textField {
  if (textField.tag == 1 && self.countEntry.text.length > 0) {
    self.submitButton.enabled = YES;
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
  if (self.countEntry.text.length > 0) {
    [self.delegate createLogViewControllerDidSubmit:self
                                          withValue:@([self.countEntry.text floatValue])
                                              notes:self.notesEntry.text];
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
    NSLog(@"Shouldn't be here");
  }
}

- (void)cancelButtonPressed {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
