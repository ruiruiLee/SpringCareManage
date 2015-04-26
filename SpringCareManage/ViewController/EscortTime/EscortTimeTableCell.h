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
#import "EscortTimeReplyCell.h"
#import "RecoderAndPlayer.h"

typedef void(^ReplayAction)(int index);

@protocol EscortTimeTableCellDelegate <NSObject>
-(void)commentButtonClick:(id)target ReplyName:(NSString*)ReplyName ReplyID:(NSString*)ReplyID; // 评论陪护时光
- (void) ReloadTebleView;

@end


@interface EscortTimeTableCell : UITableViewCell<UITableViewDataSource, UITableViewDelegate>
{
    ImageLayoutView *_imageContent;
    UIView *_replyContent;
    UILabel *_lbContent;
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
    RecoderAndPlayer  *_recoderAndPlayer;
    
    UILabel *_lbTimeLine;
    UILabel *_lbToday;
    
    UILabel *_line;
    NSString *previousTime;
}


@property (nonatomic, assign) id<EscortTimeTableCellDelegate> cellDelegate;
@property (nonatomic, strong) UILabel *_lbToday;
@property (nonatomic, strong) UILabel *_lbTimeLine;
@property (nonatomic, strong) UIButton *_btnReply;
@property (nonatomic, strong) EscortTimeDataModel *_model;

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier blocks:(ReplayAction)blocks;

- (void) setContentData:(EscortTimeDataModel*)data;

- (CGFloat) getContentHeightWithData:(EscortTimeDataModel *) modelData;

@end
