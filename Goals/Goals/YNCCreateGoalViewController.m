//
//  YNCCreateGoalViewController.m
//  Goals
//
//  Created by Calvin Lee on 9/19/15.
//  Copyright (c) 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCCreateGoalViewController.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCColor.h"
#import "YNCGoal.h"
#import "YNCUser.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static NSString * const kYNCFriendViewCellIdentifier = @"cellIdentifier";

@interface YNCCreateGoalViewController ()<UITableViewDelegate, UITableViewDataSource>

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
@property (strong, nonatomic) UIButton *addMembers;
@property (strong, nonatomic) UIView *goalMembersBottomBorder;
@property (strong, nonatomic) UILabel *goalDescriptionLabel;
@property (strong, nonatomic) UITextView *goalDescriptionTextView;
@property (strong, nonatomic) UIButton *submitButton;
@property (nonatomic) GoalType goalType;

@property (strong, nonatomic) NSArray *myFriends;
@property (strong, nonatomic) UITableView *memberList;

@end

@implementation YNCCreateGoalViewController

- (void)loadView {
  self.title = @"Create Goal"; // how to change font of this?
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor whiteColor];
  
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
  [dailyTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [dailyTypeButton setTitle:@"DAILY" forState:UIControlStateNormal];
  dailyTypeButton.layer.borderColor = [YNCColor tealColor].CGColor;
  dailyTypeButton.layer.borderWidth = 2.0f;
  dailyTypeButton.tag = daily;
  dailyTypeButton.layer.cornerRadius = 40.0f;
  [dailyTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  [sumTypeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [sumTypeButton setTitle:@"TOTAL" forState:UIControlStateNormal];
  sumTypeButton.layer.borderColor = [YNCColor tealColor].CGColor;
  sumTypeButton.layer.borderWidth = 2.0f;
  sumTypeButton.tag = sum;
  sumTypeButton.layer.cornerRadius = 40.0f;
  [sumTypeButton addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
  [goalTypeButtons addSubview:dailyTypeButton];
  [goalTypeButtons addSubview:orLabel];
  [goalTypeButtons addSubview:sumTypeButton];
  
  UIView *goalMembersView = self.goalMembersView = [[UIView alloc] init];
  UILabel *goalMembersLabel = self.goalMembersLabel = [[UILabel alloc] init];
  goalMembersLabel.text = @"WITH";
  UIButton *addMembers = self.addMembers = [[UIButton alloc] init];
  [addMembers setImage:[UIImage imageNamed:@"add_hollow_button.png"] forState:UIControlStateNormal];
  UIView *goalMembersBottomBorder = self.goalMembersBottomBorder = [[UIView alloc] init];
  goalMembersBottomBorder.backgroundColor = [YNCColor tealColor];
  [goalMembersView addSubview:goalMembersLabel];
  [goalMembersView addSubview:addMembers];
  [goalMembersView addSubview:goalMembersBottomBorder];
  
  UITextField *goalDurationTextField = self.goalDurationTextField = [[UITextField alloc] init];
  goalDurationTextField.keyboardType = UIKeyboardTypeNumberPad;
  goalDurationTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"DURATION" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
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
  
  
  NSArray *myFriends = self.myFriends = [[NSArray alloc] init];
  UITableView *memberList = self.memberList = [[UITableView alloc] init];
  memberList.delegate = self;
  memberList.dataSource = self;
  [memberList registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kYNCFriendViewCellIdentifier];
  
  
  // no more friends
  
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
  [container addSubview:memberList];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, container, goalTitleTextField, goalTitleTextFieldBottomBorder, goalTypeButtons, dailyTypeButton, orLabel, sumTypeButton, goalDurationTextField, goalDurationTextFieldBottomBorder, goalMembersView, goalMembersLabel, addMembers, goalMembersBottomBorder, goalDescriptionLabel, goalDescriptionTextView, submitButton, memberList);
  YNCAutoLayout *autoLayout = [[YNCAutoLayout alloc] initWithViews:views];
  [autoLayout addVflConstraint:@"V:|-50-[goalTitleTextField(25)]-5-[goalTitleTextFieldBottomBorder(2)]-20-[goalTypeButtons(80)]-20-[goalDurationTextField(25)]-5-[goalDurationTextFieldBottomBorder(2)]-20-[goalMembersView]-20-[goalDescriptionLabel]-5-[goalDescriptionTextView(100)]-50-[submitButton]-10-[memberList(100)]|" toView:container];
  [autoLayout addVflConstraint:@"H:|-40-[goalDescriptionTextView(300)]" toView:container];
  [autoLayout addVflConstraint:@"H:[goalTitleTextField(300)]" toView:container];
  
  [autoLayout addVflConstraint:@"V:|[dailyTypeButton(80)]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"V:|[orLabel]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"V:|[sumTypeButton(80)]|" toView:goalTypeButtons];
  [autoLayout addVflConstraint:@"H:|[dailyTypeButton(80)]-15-[orLabel]-15-[sumTypeButton(80)]|" toView:goalTypeButtons];
  
  [autoLayout addVflConstraint:@"V:|[goalMembersLabel]-5-[goalMembersBottomBorder(2)]|" toView:goalMembersView];
  [autoLayout addVflConstraint:@"V:|[addMembers]" toView:goalMembersView];
  [autoLayout addVflConstraint:@"H:|[goalMembersLabel]" toView:goalMembersView];
  [autoLayout addVflConstraint:@"H:[addMembers]|" toView:goalMembersView];
  [autoLayout addConstraintForView:addMembers withSize:CGSizeMake(24,24) toView:addMembers];
  [autoLayout addVflConstraint:@"H:|[goalMembersBottomBorder(300)]|" toView:goalMembersView];
  
  [autoLayout addVflConstraint:@"H:[goalDurationTextField(300)]" toView:container];
  [autoLayout addVflConstraint:@"H:|-40-[goalDescriptionLabel]" toView:container];
  
  [autoLayout addVflConstraint:@"H:[submitButton(100)]" toView:container];
  [autoLayout addVflConstraint:@"H:[memberList(300)]" toView:container];

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

- (void)viewDidLoad {
  // time to find friends!
  FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                initWithGraphPath:@"/me/friends"
                                parameters:nil
                                HTTPMethod:@"GET"];
  [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                        id result,
                                        NSError *error) {
    if(!error) {
      NSMutableArray *friendBuilder = [[NSMutableArray alloc] init];
      NSDictionary *friendData = (NSDictionary *)result;
      NSDictionary *friends = (NSDictionary *)friendData[@"data"];
      for (NSDictionary *friend in friends) {
        [friendBuilder addObject:friend[@"id"]];
      }
      [YNCUser loadUsersWithFacebookIDs:[friendBuilder copy] Callback:^(NSArray *users, NSError *error) {
        self.myFriends = [users copy];
        [self.memberList reloadData];
      }];
    }
    else {
      NSLog(@"error finding friends");
    }
  }];

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



- (void)submitButtonPressed:(UIButton *)button {
  
  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
  f.numberStyle = NSNumberFormatterDecimalStyle;
  NSNumber *duration = [f numberFromString:self.goalDurationTextField.text];
  
  NSMutableArray *usersBuilder = [[NSMutableArray alloc] init];
  [usersBuilder addObject:[PFUser currentUser]];
  /* for (PFObject *userObject in self.pfObject[YNCGoalPFKey.usersListKey]) {
    [usersBuilder addObject:[[YNCUser alloc] initWithPFObject:userObject]];
  }
   */
  NSArray *usersList = [usersBuilder copy];
  
  [YNCGoal createAndSaveGoalWithTitle:self.goalTitleTextField.text desc:self.goalDescriptionTextView.text type:self.goalType duration:duration usersList:usersList];
  [self.navigationController popViewControllerAnimated:YES];
  // TODO (calvin): REFRESH list view with callbacks
}

- (BOOL)formValidated {
  return (self.goalTitleTextField.text && self.goalTitleTextField.text.length > 0 && self.goalType != -1 && self.goalDurationTextField.text && self.goalDurationTextField.text.length > 0);
  // TODO (calvin): add users validation
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"count %d", [self.myFriends count]);
  return [self.myFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYNCFriendViewCellIdentifier];
  NSLog(@"cell");
  YNCUser *user = (YNCUser *)self.myFriends[indexPath.row];
  NSLog(@"user %@", user);
  cell.textLabel.text = user.firstName;
  cell.textLabel.font = [YNCFont standardFont];
  cell.textLabel.textColor = [UIColor blackColor];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  /*YNCGoal *goal = [self goalAtIndexPath:indexPath];
  YNCGoalViewController *goalVC = [[YNCGoalViewController alloc] initWithGoal:goal];
  [self.navigationController pushViewController:goalVC animated:YES];
   */
  NSLog(@"you picked something!");
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

- (void)textFieldDidChange:(UITextField *)textField {
  if ([self formValidated]) {
    self.submitButton.enabled = YES;
  }
  else {
    self.submitButton.enabled = NO;
  }
}

@end