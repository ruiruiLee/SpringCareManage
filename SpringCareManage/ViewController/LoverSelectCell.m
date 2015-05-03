//
//  LoverSelectCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LoverSelectCell.h"
#import "define.h"
#import "UIImageView+WebCache.h"

@implementation LoverSelectCell
@synthesize selectedBtn;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSubviews];
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

- (void) initSubviews
{
    _photoImgV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _photoImgV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_photoImgV];
    _photoImgV.clipsToBounds = YES;
    _photoImgV.layer.cornerRadius = 30;
    
    _lbNickName = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbNickName];
    _lbNickName.translatesAutoresizingMaskIntoConstraints = NO;
    _lbNickName.textColor = _COLOR(0x22, 0x22, 0x22);
    _lbNickName.font = _FONT(15);
    
    
    _lbNameAge = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbNameAge];
    _lbNameAge.translatesAutoresizingMaskIntoConstraints = NO;
    _lbNameAge.textColor = _COLOR(0x66, 0x66, 0x66);
    _lbNameAge.font = _FONT(16);
    
    _lbAddress = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_lbAddress];
    _lbAddress.translatesAutoresizingMaskIntoConstraints = NO;
    _lbAddress.textColor = _COLOR(0x99, 0x99, 0x99);
    _lbAddress.font = _FONT(12);
    
    selectedBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:selectedBtn];
    selectedBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [selectedBtn setImage:[UIImage imageNamed:@"paytypenoselect"] forState:UIControlStateNormal];
    [selectedBtn setImage:[UIImage imageNamed:@"paytypeselected"] forState:UIControlStateSelected];
    selectedBtn.selected = NO;
    
    _line = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_line];
    _line.translatesAutoresizingMaskIntoConstraints = NO;
    _line.backgroundColor = SeparatorLineColor;
    
    intervalV1 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV1];
    intervalV1.translatesAutoresizingMaskIntoConstraints = NO;
    
    intervalV2 = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:intervalV2];
    intervalV2.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_photoImgV, _lbNameAge, _lbNickName, _line, selectedBtn,_lbAddress, intervalV1, intervalV2);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgV(60)]-20-[_lbNickName]->=20-[selectedBtn]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgV(60)]-20-[_lbNameAge]->=20-[selectedBtn]-20-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgV(60)]-20-[_lbAddress]->=60-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[intervalV1]-0-[_lbNickName]-10-[_lbNameAge]-6-[_lbAddress]-0-[intervalV2]-0-[_line(1)]-0-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_photoImgV(60)]-20-[_line]-0-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_photoImgV(60)]-15-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_photoImgV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:selectedBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:intervalV2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:intervalV1 attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

- (void) SetContentDataWithModel:(LoverInfoModel *) model
{
    _lbAddress.text = model.addr;
    _lbNickName.text = model.nickname;
    _lbNameAge.text = [NSString stringWithFormat:@"%@   %ld岁", model.name, (long)model.age];//@"张大川  68岁";
    [_photoImgV sd_setImageWithURL:[NSURL URLWithString:model.headerImage] placeholderImage:ThemeImage(@"placeholderimage")];
}
@end
