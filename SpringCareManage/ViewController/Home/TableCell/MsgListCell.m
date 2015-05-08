//
//  MsgListCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MsgListCell.h"
#import "define.h"

@implementation MsgListCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _lbContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbContent];
        _lbContent.translatesAutoresizingMaskIntoConstraints = NO;
        _lbContent.font = _FONT(14);
        _lbContent.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbContent.preferredMaxLayoutWidth = ScreenWidth - 40;
        _lbContent.numberOfLines = 0;
        
        
        _lbTime = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbTime];
        _lbTime.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTime.font = _FONT(12);
        _lbTime.textColor = _COLOR(0x99, 0x99, 0x99);
        _lbTime.textAlignment = NSTextAlignmentRight;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbTime, _lbContent);
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbContent]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_lbTime]-20-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_lbContent]-10-[_lbTime]-6-|" options:0 metrics:nil views:views]];
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

- (void) SetContentDataWithModel:(MsgDataModel *) model
{
    _lbContent.text = model.newsTitle;
    _lbTime.text = model.createdAt;
}

@end
