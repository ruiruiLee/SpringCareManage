//
//  MyEscortObjectVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"

@interface MyEscortObjectVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    PullTableView *_tableview;
    NSString *_SearchConditionStr;
}

@property (nonatomic, strong) PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *DataList;

@end
