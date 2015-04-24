//
//  BaseOrderListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseOrderListModel.h"

@implementation BaseOrderListModel

static NSMutableArray *orderList = nil;

+ (NSArray *) GetOrderList
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        orderList = [[NSMutableArray alloc] init];
    });
    return orderList;
}

- (void) setPages:(NSInteger)pages
{
    if(pages == 0)
        [self cleanDataList];
    _pages = pages;
}

- (void) setCareId:(NSString *)careId
{
    if(self.careId != nil && ![self.careId isEqualToString:careId]){
        _careId = careId;
        self.pages = 0;
        self.totals = INT16_MAX;
        
        [self cleanDataList];
    }
}

- (void) cleanDataList
{
    [orderList removeAllObjects];
}

- (void) RequestOrderListWithBlock:(block) block
{
    
}

- (void) RequestOrderListWithType:(OrderListType) type block:(block)block
{
    if(self.pages >= self.totals){
        if(block){
            block(1000, nil);
        }
        
        return;
    }
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setObject:self.careId forKey:@"careId"];
    [parmas setObject:[self GetTypeNameWithOrderType:type] forKey:@"orderType"];
    [parmas setObject:[NSNumber numberWithInt:LIMIT_COUNT] forKey:@"limit"];
    [parmas setObject:[NSNumber numberWithInt:LIMIT_COUNT * self.pages] forKey:@"offset"];
    [LCNetWorkBase postWithMethod:Method Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                if([content objectForKey:@"code"] == nil){
                    NSMutableArray *result = [[NSMutableArray alloc] init];
                    NSArray *rows = [content objectForKey:@"rows"];
                    for (int i = 0; i < [rows count]; i++) {
                        OrderInfoModel *model = (OrderInfoModel *)[OrderInfoModel modelFromDictionary:[rows objectAtIndex:i]];
                        [result addObject:model];
                    }
                    
                    if(block){
                        block(1, result);
                    }
                }else
                {
                    if(block)
                        block(0, nil);
                }
            }
            else
            {
                if(block)
                    block(0, nil);
            }
        }
        else
        {
            if(block)
                block(0, nil);
        }
    }];
}

- (NSString *) GetTypeNameWithOrderType:(OrderListType) type
{
    NSString *typeName = @"all";
    if(type == EnumOrderAll)
        typeName = @"all";
    else if (type == EnumOrderNew)
        typeName = @"new";
    else if (type == EnumOrderSubscribe)
        typeName = @"confirmed";
    else if (type == EnumOrderTreatPay)
        typeName = @"waitPay";
    else if (type == EnumOrderEvaluate)
        typeName = @"waitComment";
    return typeName;
}

@end
