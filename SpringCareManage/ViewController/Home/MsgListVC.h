//
//  MsgListVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/3.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"


@interface MsgListVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    PullTableView *_tableview;
}

@property (nonatomic, strong) PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *DataList;

@end
