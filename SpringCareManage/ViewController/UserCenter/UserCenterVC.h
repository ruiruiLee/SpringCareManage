//
//  UserCenterVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/13.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"

@interface UserCenterVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate>
{
    NSString   *_appDownUrl;
}

@property (nonatomic, strong) UITableView *tableview;

@end
