//
//  DefaultLoverSelectVC.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/26.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "PullTableView.h"
#import "LoverInfoModel.h"

@protocol DefaultLoverSelectDelegate <NSObject>

- (void) NotifyCurrentSelectLoverModel:(LoverInfoModel *) model;

@end

@interface DefaultLoverSelectVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, PullTableViewDelegate>
{
    PullTableView *_tableview;
    
    NSString *_defaultLoverId;
}

@property (nonatomic, strong) PullTableView *tableview;
@property (nonatomic, strong) NSMutableArray *DataList;
@property (nonatomic, assign) id<DefaultLoverSelectDelegate> delegate;

- (id) initWithSelectLoverId:(NSString *) loverId;

@end
