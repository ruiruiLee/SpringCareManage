//
//  MyOrderListVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/12.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"

typedef enum : NSUInteger {
    EnumOrderAll,
    EnumOrderNew,
    EnumOrderSubscribe,
    EnumOrderTreatPay,
    EnumOrderEvaluate,
} OrderListType;

@interface MyOrderListVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, PullTableViewDelegate>
{
    UISearchBar *_searchBar;
    PullTableView *_tableview;
    NSString *_SearchConditionStr;
}

@property (nonatomic, strong) PullTableView *tableview;
@property (nonatomic, assign) OrderListType orderType;
@property (nonatomic, strong) NSMutableArray *DataList;

@end
