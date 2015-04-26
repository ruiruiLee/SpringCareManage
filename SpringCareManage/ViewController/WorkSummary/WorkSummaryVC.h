//
//  WorkSummaryVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "EscortTimeDataModel.h"
#import "EscortTimeTableCell.h"
#import "feedbackView.h"
#import "PullTableView.h"
#import "LCBaseVC.h"

@interface WorkSummaryVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, PullTableViewDelegate>
{
    PullTableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIImageView  *_photoImgView;//头像
    UILabel *_lbName;//姓名
    UIButton *_btnAddr;//信息
    
    UIImageView *_sex;
    UILabel *_lbAge;
    UIButton *_btnMobile;
    UILabel *_lbPhone;
    
    //
    EscortTimeDataModel *_replyContentModel;//
    NSString *_reReplyPId;//被回复人id
    NSString *_reReplyName;//被回复人名字
    //UIImageView *_defaultImgView;
    
    NSString *_currentSelectAttention;//当前选择的服务对象
    
    NSInteger pages;
    NSInteger totalPages;
    
    NSMutableArray *_dataList;
    NSArray *AttentionArray;
    UIView *headerView;
}

@property (nonatomic, strong) PullTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end
