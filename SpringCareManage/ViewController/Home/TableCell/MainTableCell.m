//
//  MainTableCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MainTableCell.h"
#import "define.h"

@implementation MainTableCell
@synthesize photoImgV = _photoImgV;
@synthesize lbTitle = _lbTitle;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _photoImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_photoImgV];
        _photoImgV.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbTitle.font = _FONT(16);
        _lbTitle.backgroundColor = [UIColor clearColor];
        
        _imgUnfold = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgUnfold];
        _imgUnfold.translatesAutoresizingMaskIntoConstraints = NO;
        _imgUnfold.image = [UIImage imageNamed:@"usercentershutgray"];
        
        _line = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_line];
        _line.translatesAutoresizingMaskIntoConstraints = NO;
        _line.backgroundColor = SeparatorLineColor;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_photoImgV, _lbTitle, _line, _imgUnfold);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-18-[_photoImgV(22)]-14-[_lbTitle]->=10-[_imgUnfold]-16-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=0-[_photoImgV(22)]-14-[_line]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imgUnfold attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
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
