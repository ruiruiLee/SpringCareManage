//
//  UserSettingTableCell.m
//  SpringCare
//
//  Created by LiuZach on 15/4/9.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserSettingTableCell.h"
#import "define.h"

@implementation UserSettingTableCell
@synthesize _imgFold;
@synthesize _lbContent;
@synthesize _lbTitle;
@synthesize _line;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbTitle.font = _FONT(18);
        _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        [self.contentView addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.backgroundColor = [UIColor clearColor];
        
        _lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbContent.font = _FONT(18);
        _lbContent.textColor = _COLOR(0x99, 0x99, 0x99);
        [self.contentView addSubview:_lbContent];
        _lbContent.translatesAutoresizingMaskIntoConstraints = NO;
        _lbContent.backgroundColor = [UIColor clearColor];
        _lbContent.hidden = YES;
        _lbContent.textAlignment = NSTextAlignmentRight;
        
        _imgFold = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgFold];
        _imgFold.translatesAutoresizingMaskIntoConstraints = NO;
        _imgFold.image = [UIImage imageNamed:@"usercentershutgray"];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.backgroundColor = SeparatorLineColor;
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbTitle, _lbContent, _imgFold, _line);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[_lbTitle(120)]->=20-[_imgFold]-35-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[_lbTitle(120)]->=20-[_lbContent]-35-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[_line]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgFold attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbContent attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
