//
//  UserDetailModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserDetailModel.h"
#import "UserModel.h"

@implementation UserDetailModel

- (void) RequestOrderInfo:(block) block
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    [parmas setObject:[UserModel sharedUserInfo].userId forKey:@"careId"];
    
    [LCNetWorkBase postWithMethod:@"api/care/index" Params:parmas Completion:^(int code, id content) {
        if(code == 1 && [content objectForKey:@"code"] == 0){
            //各类型订单数
            NSDictionary *orderCount = [content objectForKey:@"orderCount"];
            self.newCount = [[orderCount objectForKey:@"newCount"] integerValue];
            self.confirmedCount = [[orderCount objectForKey:@"confirmedCount"] integerValue];
            self.waitPayCount = [[orderCount objectForKey:@"waitPayCount"] integerValue];
            self.waitCommentCount = [[orderCount objectForKey:@"waitCommentCount"] integerValue];
            
            //当前正在执行的产品信息
            NSDictionary *processOrder = [content objectForKey:@"processOrder"];
            if(processOrder){
                self.orderModel = (OrderInfoModel*)[OrderInfoModel modelFromDictionary:processOrder];
            }
            
            if(block)
                block (1, nil);
        }
        else
        {
            if(block)
                block(0, nil);
        }
    }];
}

@end
