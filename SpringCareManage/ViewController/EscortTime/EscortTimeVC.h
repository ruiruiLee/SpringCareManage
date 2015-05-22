//
//  EscortTimeVC.h
//  Demo
//
//  Created by LiuZach on 15/3/30.
//  Copyright (c) 2015年 LiuZach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscortTimeDataModel.h"
#import "EscortTimeTableCell.h"
#import "feedbackView.h"
#import "PullTableView.h"
#import "LCBaseVC.h"
#import "PublishInfoVC.h"
#import "LoverInfoModel.h"

@interface EscortTimeVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, PullTableViewDelegate,EscortSendDelegate>
{
    PullTableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UILabel *_lbAddr;//信息
    UIImageView *_imgvAddr;
    
    UIImageView *_sex;
    UILabel *_lbAge;
    UILabel *_lbMobile;
    UILabel *_lbHeight;
    UIImageView *_imgvMoblie;
    
    //
    EscortTimeDataModel *_replyContentModel;//
    NSString *_reReplyPId;//被回复人id
    NSString *_reReplyName;//被回复人名字
    
    LoverInfoModel *_defaultLover;
    
    NSInteger pages;
    NSInteger totalPages;
    
    NSMutableArray *_dataList;
    NSArray *AttentionArray;
    UIView *headerView;
    
    UIImageView *headerbg;
    
    BOOL isHasDefaultLover;
    
    UIButton *_btnLoverSelect;
}

@property (nonatomic, strong) PullTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end
