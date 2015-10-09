//
//  YNCListViewCell.m
//  Goals
//
//  Created by Calvin Lee on 10/4/15.
//  Copyright © 2015 Yiwen Zhan. All rights reserved.
//

#import "YNCListViewCell.h"
#import "YNCAutoLayout.h"
#import "YNCFont.h"
#import "YNCColor.h"

@interface YNCListViewCell ()

@property (strong, nonatomic) YNCAutoLayout *autoLayout;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) UIView *membersContainer;

@end

@implementation YNCListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // configure control(s)
    UIView *container = self.container = [[UIView alloc] init];
    UILabel *titleLabel = self.titleLabel = [[UILabel alloc] init];
    UILabel *scoreLabel = self.scoreLabel = [[UILabel alloc] init];
    UIView *membersContainer = self.membersContainer = [[UIView alloc] init];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:24];
    
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.font = [UIFont fontWithName:[YNCFont regularFontName] size:24];
    self.scoreLabel.textColor = [YNCColor tealColor];

    [self.contentView addSubview:container];
    [container addSubview:self.titleLabel];
    [container addSubview:self.membersContainer];
    [container addSubview:self.scoreLabel];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, membersContainer, scoreLabel);
    YNCAutoLayout *autoLayout = self.autoLayout = [[YNCAutoLayout alloc] initWithViews:views];

    [autoLayout addVflConstraint:@"H:|-16-[titleLabel][membersContainer(104)]-16-[scoreLabel]-16-|" toView:self.container];
        [autoLayout addVflConstraint:@"V:[membersContainer(50)]" toView:self.container];
    [autoLayout addVflConstraint:@"H:|[container]|" toView:self.contentView];
    [autoLayout addVflConstraint:@"V:|[container]|" toView:self.contentView];
    [autoLayout addConstraintForViews:@[container, titleLabel, membersContainer, scoreLabel]
                  equivalentAttribute:NSLayoutAttributeCenterY
                               toView:self.container];
  }
  return self;
}

-(void)prepareForReuse
{
  [super prepareForReuse];
}

// -(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated

- (void)setTitle:(NSString *)title {
  self.titleLabel.text = title;
}

- (void)setScore:(NSNumber *)score {
  self.scoreLabel.text = [NSString stringWithFormat:@"%@", score]; //
}

- (void)setMembersWithImages:(NSArray *)images
                       count:(NSInteger)count {
  UIImageView *lastImageView;
  for (NSInteger i = 0; i < MIN(3, count); i++) {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = images[i];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.layer.cornerRadius = 16;
    
    [self.membersContainer addSubview:imageView];
    [self.autoLayout addConstraintForView:imageView withSize:CGSizeMake(32, 32) toView:imageView];
    if (i == 0) {
      [self.autoLayout addConstraintWithItem:imageView
                                      toItem:self.membersContainer
                         equivalentAttribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:0
                                      toView:self.membersContainer];
    }
    if (lastImageView) {
      [self.autoLayout addConstraintWithItem:imageView
                                      toItem:lastImageView
                         equivalentAttribute:NSLayoutAttributeLeft
                                  multiplier:1
                                    constant:36
                                      toView:self.membersContainer];
      
    }
    [self.autoLayout addConstraintWithItem:imageView
                                    toItem:self.membersContainer
                       equivalentAttribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0
                                    toView:self.membersContainer];
    lastImageView = imageView;
  }
  
  
  // todo (calvin): handle count >= 3
}

@end