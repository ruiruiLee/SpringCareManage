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

#import "LoverInfoModel.h"

@interface EscortTimeVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, PullTableViewDelegate>
{
    PullTableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnAddr;//信息
    
    UIImageView *_sex;
    UILabel *_lbAge;
    UILabel *_relationName;
    UILabel *_lbMobile;
    UIButton *_btnRing;
    
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
}

@property (nonatomic, strong) PullTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end
