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

@interface YNCCreateLogViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *countEntry;
@property (strong, nonatomic) UITextView *notesEntry;
@property (strong, nonatomic) UILabel *countPlaceholder;
@property (strong, nonatomic) UILabel *notesPlaceholder;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIView *container;

@end

@implementation YNCCreateLogViewController

- (void)loadView {
  self.view = [[UIView alloc] init];
  UITextField *countEntry = self.countEntry = [[UITextField alloc] init];
  UITextView *notesEntry = self.notesEntry = [[UITextView alloc] init];
  UILabel *countPlaceholder = self.countPlaceholder = [[UILabel alloc] init];
  UILabel *notesPlaceholder = self.notesPlaceholder = [[UILabel alloc] init];
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  UIButton *cancelButton = self.cancelButton = [[UIButton alloc] init];
  UIView *container = self.container = [[UIView alloc] init];

  [self.view addSubview:container];
  [container addSubview:countEntry];
  [container addSubview:notesEntry];
  [container addSubview:countPlaceholder];
  [container addSubview:notesPlaceholder];
  [container addSubview:submitButton];
  [container addSubview:cancelButton];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(container, countEntry, notesEntry,
                                                       countPlaceholder, notesPlaceholder,
                                                       submitButton, cancelButton);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addConstraintForView:container withSize:CGSizeMake(300, 300) toView:container];
  [autoLayout addVflConstraint:@"V:|[cancelButton]-20-[countEntry]-20-[notesEntry(50)]-20-[submitButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-100-[container]" toView:self.view];
  [autoLayout addVflConstraint:@"H:|-10-[cancelButton]" toView:container];
  [autoLayout addVflConstraint:@"V:|-10-[cancelButton]" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[countEntry]-20-|" toView:container];
  [autoLayout addVflConstraint:@"H:|-20-[notesEntry]-20-|" toView:container];
  [autoLayout addConstraintForViews:@[countEntry, notesEntry, submitButton, container, self.view]
                equivalentAttribute:NSLayoutAttributeCenterX
                             toView:self.view];
  [autoLayout addCenteringConstraintForViews:@[countEntry, countPlaceholder]
                                      toView:container];
  [autoLayout addCenteringConstraintForViews:@[notesEntry, notesPlaceholder]
                                      toView:container];
  [autoLayout addConstraintForView:submitButton withSize:CGSizeMake(75,75) toView:submitButton];
  [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  self.submitButton.enabled = NO;
  self.countPlaceholder.text = @"add number";
  self.notesPlaceholder.text = @"add notes";
  self.countEntry.delegate = self;
  self.notesEntry.delegate = self;
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
  if (!self.countPlaceholder.hidden) {
    self.countPlaceholder.hidden = YES;
  }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
  if (!self.notesPlaceholder.hidden) {
    self.notesPlaceholder.hidden = YES;
  }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (self.countEntry.text.length > 0) {
    self.submitButton.enabled = YES;
  } else {
    self.countPlaceholder.hidden = NO;
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  if (self.notesEntry.text.length == 0) {
    self.notesPlaceholder.hidden = NO;
  }
}

- (void)submitButtonPressed {
  if (self.countEntry.text.length > 0) {
    [self.delegate createLogViewControllerDidSubmit:self
                                           witCount:@([self.countEntry.text floatValue])
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
