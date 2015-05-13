//
//  UserCenterVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "EGORefreshTableHeaderView.h"

@interface UserCenterVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) EGORefreshTableHeaderView *refreshView;
@property (nonatomic, strong) UITableView *tableview;

@end
