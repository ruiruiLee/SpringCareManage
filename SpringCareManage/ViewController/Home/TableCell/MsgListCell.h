//
//  MsgListCell.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgDataModel.h"

@interface MsgListCell : UITableViewCell
{
    UILabel *_lbContent;
    UILabel *_lbTime;
}

- (void) SetContentDataWithModel:(MsgDataModel *) model;

@end
