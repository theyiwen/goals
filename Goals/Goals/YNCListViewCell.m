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
<<<<<<< HEAD
<<<<<<< HEAD
#import "YNCColor.h"
=======
>>>>>>> yey
=======
#import "YNCColor.h"
>>>>>>> logs finally process on load goals

@interface YNCListViewCell ()

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *scoreLabel;

@end

@implementation YNCListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // configure control(s)
    UIView *container = self.container = [[UIView alloc] init];
    UILabel *titleLabel = self.titleLabel = [[UILabel alloc] init];
    UILabel *scoreLabel = self.scoreLabel = [[UILabel alloc] init];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:24];
    
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.font = [UIFont fontWithName:[YNCFont regularFontName] size:24];
    self.scoreLabel.textColor = [YNCColor tealColor];

    [self.contentView addSubview:container];
    [container addSubview:self.titleLabel];
    [container addSubview:self.scoreLabel];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, scoreLabel);
    YNCAutoLayout *autoLayout =[[YNCAutoLayout alloc] initWithViews:views];

    [autoLayout addVflConstraint:@"H:|-16-[titleLabel][scoreLabel]-16-|" toView:self.container];
    [autoLayout addVflConstraint:@"H:|[container]|" toView:self.contentView];
    [autoLayout addVflConstraint:@"V:|[container]|" toView:self.contentView];
    [autoLayout addConstraintForViews:@[container, titleLabel, scoreLabel]
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

@end