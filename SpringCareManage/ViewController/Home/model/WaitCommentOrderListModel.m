//
//  WaitCommentOrderListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

//待评论订单列表
#import "WaitCommentOrderListModel.h"

@implementation WaitCommentOrderListModel

- (void) RequestOrderListWithBlock:(block) block
{
    [self RequestOrderListWithType:EnumOrderAll block:^(int code, id content) {
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
