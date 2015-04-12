//
//  EscortTimeReplyCell.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "HBCoreLabel.h"

@interface EscortTimeReplyCell : UITableViewCell
{
    HBCoreLabel *_lbReplyContent;
}

- (void) setContentWithData:(EscortTimeReplyDataModel*)data;

@end
