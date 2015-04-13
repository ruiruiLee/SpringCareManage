//
//  EscortObjectCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EscortObjectCell : UITableViewCell
{
    UIImageView *_photoImgV;
    UILabel *_lbNickName;
    UILabel *_lbNameAge;
    UILabel *_lbAddress;
    UIButton *_btnRing;
    UILabel *_line;
    
    UIView *intervalV1;
    UIView *intervalV2;
}

@end
