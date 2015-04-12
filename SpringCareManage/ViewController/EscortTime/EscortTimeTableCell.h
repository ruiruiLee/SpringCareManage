//
//  EscortTimeTableCell.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "ImageLayoutView.h"
#import "define.h"
#import "HBCoreLabel.h"
#import "EscortTimeReplyCell.h"


typedef void(^ReplayAction)(int index);

@protocol EscortTimeTableCellDelegate <NSObject>

- (void) ReloadTebleView;

@end


@interface EscortTimeTableCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    ImageLayoutView *_imageContent;
    UIView *_replyContent;
    HBCoreLabel *_lbContent;
    UIButton *_btnVolice;
    UILabel *_lbVoliceLimit;
    UIButton *_btnVideo;
    UIButton *_btnFoldOrUnfold;
    
    //回复视图的内容
    UILabel *_lbPublishTime;
    UIButton *_btnReply;
    UIImageView *_replyTableBg;
    UITableView *_replyTableView;
    
    
    NSInteger numOfLines;
    NSInteger limitLines;
    
    NSArray *hLayoutInfoArray;
    
    NSArray *hReplyTableLayoutArray;
    NSArray *hReplyBgLayoutArry;
    
    EscortTimeDataModel *_model;
    
    
    UILabel *_lbTimeLine;
    UILabel *_lbToday;
//    UIView *_headDateView;
    
    UILabel *_line;
}


@property (nonatomic, assign) id<EscortTimeTableCellDelegate> cellDelegate;
@property (nonatomic, strong) EscortTimeReplyCell *replyCell;

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier blocks:(ReplayAction)blocks;

- (void) setContentData:(EscortTimeDataModel*)data;

@end
