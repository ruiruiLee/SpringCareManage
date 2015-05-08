//
//  MsgDataListModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/5/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface MsgDataListModel : NSObject

@property (nonatomic, assign) NSInteger pages;//当前页数
@property (nonatomic, assign) NSInteger totals;//总页数
@property (nonatomic, strong) NSString *careId;//护工id

@property (nonatomic, strong) NSMutableArray *dataList;

+ (MsgDataListModel *)ShareMsgListModel;

- (void) LoadMsgListWithBlock:(block) block;

@end
