//
//  ConfirmedOrderListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//
//已预约订单
#import "ConfirmedOrderListModel.h"

@implementation ConfirmedOrderListModel

- (void) RequestOrderListWithBlock:(block) block
{
    [self RequestOrderListWithType:EnumOrderSubscribe block:^(int code, id content) {
        if(code == 1){
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
