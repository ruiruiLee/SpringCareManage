//
//  EditUserInfoVC.h
//  SpringCare
//
//  Created by LiuZach on 15/4/7.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCPickView.h"

@protocol EditUserInfoVCDelegate <NSObject>

- (void) NotifyReloadData:(NSString*)loveID;
@end

@interface EditUserInfoVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, LCPickViewDelegate>
{
    UITableView *_tableview;
    NSArray *_data;
    NSDate *selectDate;
    id  userData;
    LCPickView *_sexPick;
    LCPickView *_agePick;
    
    NSIndexPath *indexpathStore;
    
    
    NSMutableDictionary *_EditDic;
}

@property (nonatomic, assign) id<EditUserInfoVCDelegate> delegate;
@property (nonatomic, strong) UITableView *_tableview;


- (void) setContentArray:(NSArray*)dataArray andmodel:(id) model;

@end
