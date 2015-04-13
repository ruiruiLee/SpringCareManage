//
//  EvaluateListCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateListCell.h"
#import "define.h"

@implementation EvaluateListCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubViews];
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

- (void) initSubViews
{
    _lbName = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbName.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbName];
    _lbName.font = _FONT(13);
    _lbName.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbName.text = @"王宏恩";
    
    _lbServiceTime = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbServiceTime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbServiceTime];
    _lbServiceTime.font = _FONT(12);
    _lbServiceTime.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbServiceTime.text = @"服务时间：2015-03-24";
    
    _lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
    _lbContent.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_lbContent];
    _lbContent.font = _FONT(15);
    _lbContent.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbContent.text = @"阿哥浪费难得噶蛋糕上的风格受到各方的风格的沙发后的风格和地方干活";
    _lbContent.numberOfLines = 0;
    _lbContent.preferredMaxLayoutWidth = ScreenWidth - 29;
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    _gradeInfo = [[GradeInfoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_gradeInfo];
    _gradeInfo.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_lbName, _lbServiceTime, _lbContent, _line, _gradeInfo);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-19-[_lbName]-6-[_gradeInfo]->=10-[_lbServiceTime]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-19-[_lbContent]-10-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-19-[_line]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-19-[_lbName]-16-[_lbContent]-15-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_gradeInfo attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_lbServiceTime attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_lbName attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=0-[_gradeInfo(14)]->=0-|" options:0 metrics:nil views:views]];
}

@end
