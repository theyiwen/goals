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
    
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.scoreLabel.backgroundColor = [UIColor redColor];
    
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.font = [UIFont fontWithName:[YNCFont semiBoldFontName] size:24];
    
    [self.contentView addSubview:container];
    [container addSubview:self.titleLabel];
    [container addSubview:self.scoreLabel];
    
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(container, titleLabel, scoreLabel);
    YNCAutoLayout *autoLayout =[[YNCAutoLayout alloc] initWithViews:views];
    [autoLayout addVflConstraint:@"H:|[titleLabel(250)][scoreLabel]|" toView:self.container];
    [autoLayout addVflConstraint:@"H:|[titleLabel]" toView:self.container];
    [autoLayout addVflConstraint:@"H:[scoreLabel]|" toView:self.container];
    
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