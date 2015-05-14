//
//  UserCenterCell.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserCenterCell.h"
#import "define.h"

@implementation UserCenterCell
@synthesize _imgvLogo;
@synthesize _imgvShutFlag;
@synthesize _lbTitle;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _imgvLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imgvLogo];
        _imgvLogo.translatesAutoresizingMaskIntoConstraints = NO;
        
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_lbTitle];
        _lbTitle.translatesAutoresizingMaskIntoConstraints = NO;
        _lbTitle.font = _FONT(18);
        
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
