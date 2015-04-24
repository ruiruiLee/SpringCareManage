//
//  AllOrderListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "AllOrderListModel.h"

@implementation AllOrderListModel

static NSMutableArray *orderList = nil;

- (NSArray *) GetOrderList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderList = [[NSMutableArray alloc] init];
    });
    return orderList;
}

- (id) init
{
    self = [super init];
    if(self){
        if(orderList == nil)
            orderList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) cleanDataList
{
    [orderList removeAllObjects];
}

- (void) RequestOrderListWithBlock:(block) block
{
    [self RequestOrderListWithType:EnumOrderAll block:^(int code, id content) {
        if(code == 1){
            [orderList addObjectsFromArray:content];
            if(block){
                block(1, content);
            }
        }else{
            if(block)
                block(0, nil);
        }
    }];
}

@end
