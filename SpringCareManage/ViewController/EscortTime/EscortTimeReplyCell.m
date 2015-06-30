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
        
        _lbReplyContent = [[TextAndEmojiView alloc]init];
        [self.contentView addSubview:_lbReplyContent];
    
        _lbReplyContent.fontsize = 15.0f;
        _lbReplyContent.fontcolor = _COLOR(0x66, 0x66, 0x66);
        _lbReplyContent.translatesAutoresizingMaskIntoConstraints = NO;
        _lbReplyContent.maxWidth = ScreenWidth - 115;
        _lbReplyContent.backgroundColor = [UIColor clearColor];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_lbReplyContent);
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"H:|-0-[_lbReplyContent]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint
                                          constraintsWithVisualFormat:@"V:|-4-[_lbReplyContent]-4-|" options:0 metrics:nil views:views]];
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
    NSMutableAttributedString *str = [EscortTimeReplyDataModel getFullStringWithModel:data];
    _lbReplyContent.attr = str;
    _lbReplyContent.textString = data.content;
}

@end
