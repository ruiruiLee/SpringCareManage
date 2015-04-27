//
//  EscortTimeReplyCell.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "TextAndEmojiView.h"

@interface EscortTimeReplyCell : UITableViewCell
{
    //UILabel *_lbReplyContent;
    TextAndEmojiView *_lbReplyContent;
}

- (void) setContentWithData:(EscortTimeReplyDataModel*)data;

@end
