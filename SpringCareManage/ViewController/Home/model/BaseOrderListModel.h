//
//  BaseOrderListModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

//订单列表基类
#import <Foundation/Foundation.h>
#import "OrderInfoModel.h"

#define Method  @"api/order/care/list"

@interface BaseOrderListModel : NSObject

@property (nonatomic, assign) NSInteger pages;//当前页数
@property (nonatomic, assign) NSInteger totals;//总页数
@property (nonatomic, strong) NSString *careId;//护工id

+ (NSArray *) GetOrderList;

- (void) cleanDataList;

/******
 **  如果pages超过totals，返回状态码1000
 **  正确，返回1，其他返回0
 ******/
- (void) RequestOrderListWithBlock:(block) block;

- (void) RequestOrderListWithType:(OrderListType) type block:(block)block;//

@end
