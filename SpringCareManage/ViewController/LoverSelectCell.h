//
//  LoverSelectCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoverInfoModel.h"

@interface LoverSelectCell : UITableViewCell
{
    UIImageView *_photoImgV;
    UILabel *_lbNickName;
    UILabel *_lbNameAge;
    UILabel *_lbAddress;
    UILabel *_line;
    
    UIView *intervalV1;
    UIView *intervalV2;
}

@property (nonatomic, strong) UIButton *selectedBtn;

- (void) SetContentDataWithModel:(LoverInfoModel *) model;

@end
