//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"
#import "YNCFriendPickerViewController.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCColor.h"
#import "YNCGoal.h"
#import "YNCUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface YNCCreateGoalViewController ()<YNCFriendPickerViewControllerDelegate>

@property (strong, nonatomic) YNCFriendPickerViewController *friendPickerVC;
@property (strong, nonatomic) YNCAutoLayout *autoLayout;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UITextField *goalTitleTextField;
@property (strong, nonatomic) UIView *goalTitleTextFieldBottomBorder;
@property (strong, nonatomic) UIView *goalTypeButtons;
@property (strong, nonatomic) NSMutableArray *typeButtons;
@property (strong, nonatomic) UIButton *dailyTypeButton;
@property (strong, nonatomic) UIButton *sumTypeButton;
@property (strong, nonatomic) UITextField *goalDurationTextField;
@property (strong, nonatomic) UIView *goalDurationTextFieldBottomBorder;
@property (strong, nonatomic) UIView *goalMembersView;
@property (strong, nonatomic) UILabel *goalMembersLabel;
@property (strong, nonatomic) UIView *goalMembersAvatarStrip;
@property (strong, nonatomic) UIButton *addMembers;
@property (strong, nonatomic) UIView *goalMembersBottomBorder;
@property (strong, nonatomic) UILabel *goalDescriptionLabel;
@property (strong, nonatomic) UITextView *goalDescriptionTextView;
@property (strong, nonatomic) UIButton *submitButton;
@property (nonatomic) GoalType goalType;
@property (strong, nonatomic) NSArray *goalMembers;

@end

@implementation YNCCreateGoalViewController

- (void)loadView {
  self.title = @"Create Goal"; // how to change font of this?
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  
  YNCFriendPickerViewController *friendpickerVC = self.friendPickerVC = [[YNCFriendPickerViewController alloc] init];
  friendpickerVC.delegate = self;
  
  UIScrollView *scrollView = self.scrollView = [[UIScrollView alloc] init];
  UIView *container = self.container = [[UIView alloc] init];
  
  UILabel *goalDescriptionLabel = self.goalDescriptionLabel = [[UILabel alloc] init];
  goalDescriptionLabel.text = @"DESCRIPTION:";
  
  UITextField *goalTitleTextField = self.goalTitleTextField = [[UITextField alloc] init];
  goalTitleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"GOAL" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
  UIView *goalTitleTextFieldBottomBorder = self.goalTitleTextFieldBottomBorder = [[UIView alloc] init];
  goalTitleTextFieldBottomBorder.backgroundColor = [YNCColor tealColor];
  
  UITextView *goalDescriptionTextView = self.goalDescriptionTextView = [[UITextView alloc] init];
  goalDescriptionTextView.layer.borderWidth = 2.0f;
  goalDescriptionTextView.layer.borderColor = [YNCColor tealColor].CGColor;
  goalDescriptionTextView.layer.cornerRadius = 8;
  
  self.goalType = -1;
  UIView *goalTypeButtons = self.goalTypeButtons = [[UIView alloc] init];
  UIButton *dailyTypeButton = self.dailyTypeButton = [[UIButton alloc] init];
  UIButton *sumTypeButton = self.sumTypeButton = [[UIButton alloc] init];
  UILabel *orLabel = [[UILabel alloc] init];
  orLabel.textColor = [UIColor blackColor];
  orLabel.text = @"OR";
  self.typeButtons = [[NSMutableArray alloc] initWithArray:@[dailyTypeButton, sumTypeButton]];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  dailyTypeButton.tag = daily;
  [sumTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  sumTypeButton.tag = sum;
  for (UIButton *button in self.typeButtons) {
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor = [YNCColor tealColor].CGColor;
    button.layer.borderWidth = 2.0f;
    button.layer.cornerRadius = 40.0f;
    [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    [goalTypeButtons addSubview:button];
  }
  [goalTypeButtons addSubview:orLabel];
  
  UIView *goalMembersView = self.goalMembersView = [[UIView alloc] init];
  UILabel *goalMembersLabel = self.goalMembersLabel = [[UILabel alloc] init];
  goalMembersLabel.text = @"WITH";
  UIView *goalMembersAvatarStrip = self.goalMembersAvatarStrip = [[UIView alloc] init];
  UIButton *addMembers = self.addMembers = [[UIButton alloc] init];
  [addMembers setImage:[UIImage imageNamed:@"add_hollow_button.png"] forState:UIControlStateNormal];
  [addMembers addTarget:self action:@selector(addMembersButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  UIView *goalMembersBottomBorder = self.goalMembersBottomBorder = [[UIView alloc] init];
  goalMembersBottomBorder.backgroundColor = [YNCColor tealColor];
  [goalMembersView addSubview:goalMembersLabel];
  [goalMembersView addSubview:goalMembersAvatarStrip];
  [goalMembersView addSubview:addMembers];
  [goalMembersView addSubview:goalMembersBottomBorder];
  
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  goalDurationTextField.keyboardType = UIKeyboardTypeNumberPad;
  goalDurationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"# OF DAYS" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
  UIView *goalDurationTextFieldBottomBorder = self.goalDurationTextFieldBottomBorder = [[UIView alloc] init];
  goalDurationTextFieldBottomBorder.backgroundColor = [YNCColor tealColor];
  
  UIButton *submitButton = self.submitButton = [[UIButton alloc] init];
  [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [submitButton setTitleColor:[UIColor colorWithWhite:0.7f alpha:1.0f] forState:UIControlStateDisabled];
  submitButton.layer.borderColor = [YNCColor tealColor].CGColor;
  submitButton.layer.borderWidth = 2.0f;
  submitButton.layer.cornerRadius = 8;
  [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  submitButton.enabled = NO;

  goalDescriptionLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  goalMembersLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  goalTitleTextField.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  goalDescriptionTextView.font = [YNCFont standardFont];
  goalDurationTextField.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  dailyTypeButton.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  sumTypeButton.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  submitButton.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:20];
  orLabel.font = [UIFont fontWithName:[YNCFont lightFontName] size:16];
  
  // todo (calvin): replace all blacks with dark grey
  
  [self.view addSubview:scrollView];
  [scrollView addSubview:container];
  [container addSubview:goalTitleTextField];
  [container addSubview:goalTitleTextFieldBottomBorder];
  [container addSubview:goalTypeButtons];
  [container addSubview:goalDurationTextField];
  [container addSubview:goalDurationTextFieldBottomBorder];
  [container addSubview:goalMembersView];
  [container addSubview:goalDescriptionLabel];
  [container addSubview:goalDescriptionTextView];
  [container addSubview:submitButton];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, container, goalTitleTextField, goalTitleTextFieldBottomBorder, goalTypeButtons, dailyTypeButton, orLabel, sumTypeButton, goalDurationTextField, goalDurationTextFieldBottomBorder, goalMembersView, goalMembersLabel, goalMembersAvatarStrip, addMembers, goalMembersBottomBorder, goalDescriptionLabel, goalDescriptionTextView, submitButton);
  YNCAutoLayout *autoLayout = self.autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-50-[goalTitleTextField(25)]-5-[goalTitleTextFieldBottomBorder(2)]-20-[goalTypeButtons(80)]-20-[goalDurationTextField(25)]-5-[goalDurationTextFieldBottomBorder(2)]-20-[goalMembersView]-20-[goalDescriptionLabel]-5-[goalDescriptionTextView(100)]-50-[submitButton]|" toView:container];
  [autoLayout addVflConstraint:@"H:|-40-[goalDescriptionTextView(300)]" toView:container];
  [autoLayout addVflConstraint:@"H:[goalTitleTextField(300)]" toView:container];
  
  [autoLayout addVflConstraint:@"V:|[dailyTypeButton(80)]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"V:|[orLabel]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"V:|[sumTypeButton(80)]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"H:|[dailyTypeButton(80)]-15-[orLabel]-15-[sumTypeButton(80)]|" toView:goalTypeButtons];
  
  [autoLayout addVflConstraint:@"V:|[goalMembersLabel]-5-[goalMembersBottomBorder(2)]|" toView:goalMembersView];
  [autoLayout addVflConstraint:@"V:|[goalMembersAvatarStrip(24)]" toView:goalMembersView];
  [autoLayout addVflConstraint:@"V:|[addMembers]" toView:goalMembersView];
  [autoLayout addVflConstraint:@"H:|[goalMembersLabel]-10-[goalMembersAvatarStrip(205)]" toView:goalMembersView];
  [autoLayout addVflConstraint:@"H:[addMembers]|" toView:goalMembersView];
  [autoLayout addConstraintForView:addMembers withSize:CGSizeMake(24,24) toView:addMembers]; // can probably get rid of this and just make the whole view be tap target
  
  // todo (calvin): show the pictures of selected peeps
  
  [autoLayout addVflConstraint:@"H:|[goalMembersBottomBorder(300)]|" toView:goalMembersView];
  
  [autoLayout addVflConstraint:@"H:[goalDurationTextField(300)]" toView:container];
  [autoLayout addVflConstraint:@"H:|-40-[goalDescriptionLabel]" toView:container];
  
  [autoLayout addVflConstraint:@"H:[submitButton(100)]" toView:container];

  [autoLayout addVflConstraint:@"V:|[scrollView]|" toView:self.view];
  [autoLayout addVflConstraint:@"H:|[scrollView]|" toView:self.view];
  [autoLayout addVflConstraint:@"V:|[container]|" toView:scrollView];
  [autoLayout addVflConstraint:@"H:|[container]|" toView:scrollView];
  
  [autoLayout addConstraintForViews:@[container, scrollView]
                equivalentAttribute:NSLayoutAttributeWidth
                             toView:self.view];
  [autoLayout addConstraintForViews:@[goalTitleTextField, goalTitleTextFieldBottomBorder] equivalentAttribute:NSLayoutAttributeWidth toView:container];
  [autoLayout addConstraintForViews:@[goalDurationTextField, goalDurationTextFieldBottomBorder] equivalentAttribute:NSLayoutAttributeWidth toView:container];
  [autoLayout addConstraintForViews:@[container, goalTitleTextField, goalTitleTextFieldBottomBorder, goalTypeButtons, goalMembersView, goalDurationTextField, goalDurationTextFieldBottomBorder, submitButton] equivalentAttribute:NSLayoutAttributeCenterX toView:container];

  
  [goalTitleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  [goalDurationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  
}

- (void)selectType:(UIButton *)sender {
  self.goalType = (int)sender.tag;
  
  for (UIButton *button in self.typeButtons) {
    if (button != sender) {
      [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else {
      [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
  }
  if ([self formValidated]) {
    self.submitButton.enabled = YES;
  }
}

- (void)addMembersButtonPressed:(UIButton *) button {
  [self.navigationController pushViewController:self.friendPickerVC animated:YES];
}


- (void)submitButtonPressed:(UIButton *)button {
  
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  NSNumber *duration = [f numberFromString:self.goalDurationTextField.text];
  
  NSMutableArray *usersBuilder = [[NSMutableArray alloc] init];
  NSMutableArray *copy = [self.goalMembers mutableCopy];
  if (copy) {
    usersBuilder = copy;
  }
  [usersBuilder addObject:[PFUser currentUser]];
  //NSLog(@"goal members: %@", usersBuilder);
  
  [YNCGoal createAndSaveGoalWithTitle:self.goalTitleTextField.text desc:self.goalDescriptionTextView.text type:self.goalType duration:duration usersList:usersBuilder];
  [self.navigationController popViewControllerAnimated:YES];
  // TODO (calvin): REFRESH list view with callbacks
}

- (void)friendPickerViewControllerDidSubmit:(YNCFriendPickerViewController *)friendPickerViewController withFriends:(NSArray *)friends {
  self.goalMembers = [friends copy];
  [self drawGoalMembersAvatarStrip];
}

- (BOOL)formValidated {
  return (self.goalTitleTextField.text && self.goalTitleTextField.text.length > 0 && self.goalType != -1 && self.goalDurationTextField.text && self.goalDurationTextField.text.length > 0);
  // TODO (calvin): add users validation
}

- (void) drawGoalMembersAvatarStrip {
  for (id viewToRemove in [self.goalMembersAvatarStrip subviews]){
      [viewToRemove removeFromSuperview];
  }
  UIImageView *lastPhoto;
  NSInteger count = 0;
  for (PFObject *object in self.goalMembers) {
    YNCUser *user = [[YNCUser alloc] initWithPFObject:object];
    NSURL *url = [NSURL URLWithString:user.photoUrl];
    NSLog (@"url: %@", user.photoUrl);
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    UIImageView *photo = [[UIImageView alloc] init];
    photo.contentMode = UIViewContentModeScaleAspectFit;
    [photo setImage:img];
    photo.clipsToBounds = YES;
    photo.translatesAutoresizingMaskIntoConstraints = NO;
    photo.layer.cornerRadius = 12;
    
    [self.goalMembersAvatarStrip addSubview:photo];
    [self.autoLayout addConstraintForView:photo withSize:CGSizeMake(24, 24) toView:photo];
    if (count == 0) {
      [self.autoLayout addConstraintWithItem:photo
                                 toItem:self.goalMembersAvatarStrip
                    equivalentAttribute:NSLayoutAttributeLeft
                             multiplier:1
                               constant:0
                                 toView:self.goalMembersAvatarStrip];
    }
    if (lastPhoto) {
      [self.autoLayout addConstraintWithItem:photo
                                 toItem:lastPhoto
                    equivalentAttribute:NSLayoutAttributeLeft
                             multiplier:1
                               constant:10
                                 toView:self.goalMembersAvatarStrip];

    }
    
    [self.autoLayout addConstraintForViews:@[photo,self.goalMembersAvatarStrip]
                  equivalentAttribute:NSLayoutAttributeTop
                               toView:self.goalMembersAvatarStrip];
    [self.autoLayout addConstraintForViews:@[photo,self.goalMembersAvatarStrip]
                  equivalentAttribute:NSLayoutAttributeBottom
                               toView:self.goalMembersAvatarStrip];
    lastPhoto = photo;
    count = count + 1;
  }
}

- (void)textFieldDidChange:(UITextField *)textField {
  if ([self formValidated]) {
    self.submitButton.enabled = YES;
  }
  else {
    self.submitButton.enabled = NO;
  }
}

// TODO (calvin): make placeholders go away
/*
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
 */

@end