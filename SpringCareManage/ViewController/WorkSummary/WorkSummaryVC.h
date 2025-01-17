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
#import "LoverInfoModel.h"

@interface WorkSummaryVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EscortTimeTableCellDelegate, PullTableViewDelegate>
{
    PullTableView *tableView;
    EscortTimeDataModel *_model;
    
    feedbackView  *_feedbackView;
    UIButton  *_btnphotoImg;//头像
    UILabel *_lbName;//姓名
    UILabel *_lbAddr;//信息
    
    UIImageView *_sex;
    UILabel *_lbAge;
    UIButton *_btnMobile;
    UILabel *_lbPhone;
    UILabel *_lbHeight;
    
    UIImageView *_imgvAddress;
    
    //
    EscortTimeDataModel *_replyContentModel;//
    NSString *_reReplyPId;//被回复人id
    NSString *_reReplyName;//被回复人名字
    //UIImageView *_defaultImgView;
    
    LoverInfoModel *_defaultLover;
    
    NSInteger pages;
    NSInteger totalPages;
    
    NSMutableArray *_dataList;
    NSArray *AttentionArray;
    UIView *headerView;
    
    UIButton *headerbg;
    
    BOOL isHasDefaultLover;
    
    UIButton *_btnLoverSelect;
}

@property (nonatomic, strong) PullTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

- (void) RequestRecordList:(block) block;

@end
