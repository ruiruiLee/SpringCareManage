//
//  BaseOrderListModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseOrderListModel.h"
#import "UserModel.h"
#import "AllOrderListModel.h"
#import "NewOrderListModel.h"
#import "ConfirmedOrderListModel.h"
#import "WaitCommentOrderListModel.h"
#import "WaitPayOrderListModel.h"


static BaseOrderListModel *allorderModel = nil;
static BaseOrderListModel *neworderModel = nil;
static BaseOrderListModel *confirmedorderModel = nil;
static BaseOrderListModel *waitPayorderModel = nil;
static BaseOrderListModel *waitCommentorderModel = nil;

@implementation BaseOrderListModel

+ (BaseOrderListModel *) ShareOrderListModelWithType:(OrderListType) type
{
    switch (type) {
        case EnumOrderAll:{
            if(!allorderModel)
                allorderModel = [[AllOrderListModel alloc] init];
            return allorderModel;
        }
            break;
        case EnumOrderNew:
            if(!neworderModel)
                neworderModel = [[NewOrderListModel alloc] init];
            return neworderModel;
            break;
        case EnumOrderSubscribe:
            if(!confirmedorderModel)
                confirmedorderModel = [[ConfirmedOrderListModel alloc] init];
            return confirmedorderModel;
            break;
        case EnumOrderTreatPay:
            if(!waitPayorderModel)
                waitPayorderModel = [[WaitPayOrderListModel alloc] init];
            return waitPayorderModel;
            break;
        case EnumOrderEvaluate:
            if(!waitCommentorderModel)
                waitCommentorderModel = [[WaitCommentOrderListModel alloc] init];
            return waitCommentorderModel;
            break;
        default:
            break;
    }
    
    return nil;
}

- (id) init
{
    self = [super init];
    
    if(self){
        
        self.totals = INT_MAX;
        self.pages = 0;
        self.dataList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *) GetOrderList
{
    return self.dataList;
}

//- (id) initWithOrderListType:(OrderListType) type
//{
//    switch (type) {
//        case EnumOrderAll:
//            self = [[AllOrderListModel alloc] init];
//            break;
//        case EnumOrderNew:
//            self = [[NewOrderListModel alloc] init];
//            break;
//        case EnumOrderSubscribe:
//            self = [[ConfirmedOrderListModel alloc] init];
//            break;
//        case EnumOrderTreatPay:
//            self = [[WaitPayOrderListModel alloc] init];
//            break;
//        case EnumOrderEvaluate:
//            self = [[WaitCommentOrderListModel alloc] init];
//            break;
//        default:
//            break;
//    }
//    
//    if(self){
//        self.totals = INT_MAX;
//        self.pages = 0;
//    }
//    
//    return self;
//}

- (void) setPages:(NSInteger)pages
{
    if(pages == 0)
        [self cleanDataList];
    _pages = pages;
}

- (void) setCareId:(NSString *)careId
{
    if(careId != nil && ![careId isEqualToString:self.careId]){
        _careId = careId;
        self.pages = 0;
        self.totals = INT_MAX;
        
        [self cleanDataList];
    }
}

- (void) cleanDataList
{
    [self.dataList removeAllObjects];
}

- (void) RequestOrderListWithBlock:(block) block
{
    
}

- (void) RequestOrderListWithType:(OrderListType) type block:(block)block
{
    self.careId = [UserModel sharedUserInfo].userId;
    
    if(self.pages*LIMIT_COUNT >= self.totals){
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
    NSLog(@"postWithMethod1");
    [LCNetWorkBase postWithMethod:Method Params:parmas Completion:^(int code, id content) {
        NSLog(@"postWithMethod");
        if(code){
            if([content isKindOfClass:[NSDictionary class]]){
                NSMutableArray *result = [[NSMutableArray alloc] init];
                NSArray *rows = [content objectForKey:@"rows"];
                self.totals = [[content objectForKey:@"total"] integerValue];
                for (int i = 0; i < [rows count]; i++) {
                    OrderInfoModel *model = (OrderInfoModel *)[OrderInfoModel modelFromDictionary:[rows objectAtIndex:i]];
                    [result addObject:model];
                }
                
                [self.dataList addObjectsFromArray:result];
                
                if(block){
                    block(1, result);
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
