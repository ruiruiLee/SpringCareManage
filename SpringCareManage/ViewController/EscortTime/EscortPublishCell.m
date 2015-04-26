//
//  EscortPublishCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EscortPublishCell.h"
#import "define.h"

@implementation EscortPublishCell
@synthesize delegate;
@synthesize _lbTimeLine = _lbTimeLine;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubviews];
    }
    
    return self;
}

- (void) initSubviews
{
    //时间轴
    _lbToday = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 60)];
    _lbToday.font = _FONT_B(20);
    _lbToday.textAlignment = NSTextAlignmentCenter;
    _lbToday.textColor = [UIColor whiteColor];
    _lbToday.backgroundColor = Abled_Color;
    _lbToday.layer.cornerRadius = 30;
    _lbToday.clipsToBounds = YES;
    _lbToday.text = @"今天";
    _lbToday.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    _lbTimeLine = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbTimeLine];
    _lbTimeLine.backgroundColor = Abled_Color;
    _lbTimeLine.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbToday];
    
    _btnPublish = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_btnPublish];
    _btnPublish.translatesAutoresizingMaskIntoConstraints = NO;
    [_btnPublish setBackgroundImage:ThemeImage(@"escortpublish") forState:UIControlStateNormal];
    [_btnPublish addTarget:self action:@selector(doBtnPublishNewEscort:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbToday, _lbTimeLine, _btnPublish);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_lbToday(60)]-10-[_btnPublish(60)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[_lbTimeLine(2)]->=10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_lbToday(60)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_btnPublish(60)]->=0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_btnPublish attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbToday attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTimeLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_lbToday attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTimeLine attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lbToday attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTimeLine attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) doBtnPublishNewEscort:(UIButton *) sender
{
    if(delegate && [delegate respondsToSelector:@selector(NotifyToPublishEscort:)])
        [delegate NotifyToPublishEscort:self];
}

@end
