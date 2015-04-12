//
//  EscortTimeReplyCell.m
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import "EscortTimeReplyCell.h"
#import "EscortTimeTableCell.h"

@implementation EscortTimeReplyCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        
        _lbReplyContent = [[HBCoreLabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbReplyContent];
        _lbReplyContent.numberOfLines = 0;
        _lbReplyContent.backgroundColor = [UIColor clearColor];
        _lbReplyContent.font = _FONT(14);
        _lbReplyContent.textColor = _COLOR(0x66, 0x66, 0x66);
        _lbReplyContent.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbReplyContent);
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-0-[_lbReplyContent]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"V:|-2-[_lbReplyContent]-2-|" options:0 metrics:nil views:views]];
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

- (void) setContentWithData:(EscortTimeReplyDataModel*)data
{
//    _lbReplyContent.text = data.publishContent;
    [_lbReplyContent setMatch:data.parser];
}

@end
