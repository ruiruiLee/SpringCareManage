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
    
    __weak UserDetailModel *weakSelf = self;
    [LCNetWorkBase postWithMethod:@"api/care/index" Params:parmas Completion:^(int code, id content) {
        if(code == 1 && [content objectForKey:@"code"] == 0){
            //各类型订单数
            NSDictionary *orderCount = [content objectForKey:@"orderCount"];
            weakSelf.newCount = [[orderCount objectForKey:@"newCount"] integerValue];
            weakSelf.confirmedCount = [[orderCount objectForKey:@"confirmedCount"] integerValue];
            weakSelf.waitPayCount = [[orderCount objectForKey:@"waitPayCount"] integerValue];
            weakSelf.waitCommentCount = [[orderCount objectForKey:@"waitCommentCount"] integerValue];
            
            //当前正在执行的产品信息
            NSDictionary *processOrder = [content objectForKey:@"processOrder"];
            if(processOrder){
                self.orderModel = (OrderInfoModel*)[OrderInfoModel modelFromDictionary:processOrder];
            }else
                self.orderModel = nil;
            
            if(block)
                block (1, content);
        }
        else
        {
            if(block)
                block(0, nil);
        }
    }];
}

@end
