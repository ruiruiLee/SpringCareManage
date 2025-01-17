//
//  OrderInfoModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoModel

+ (OrderInfoModel *) modelFromDictionary:(NSDictionary *)dic
{
    OrderInfoModel *model = [[OrderInfoModel alloc] init];
    model.orderId = [dic objectForKey:@"id"];
    model.serialNumber = [dic objectForKey:@"serialNumber"];
    model.beginDate = [dic objectForKey:@"beginDate"];
    model.endDate = [dic objectForKey:@"endDate"];
    model.dateType = [Util getDateType:[[dic objectForKey:@"dateType"] integerValue]];
    model.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
    model.orderCountStr = [dic objectForKey:@"orderCount"];
//    model.orgUnitPrice = [[dic objectForKey:@"orgUnitPrice"] floatValue];
    model.unitPrice = [[dic objectForKey:@"unitPrice"] floatValue];
    model.totalPrice = [[dic objectForKey:@"totalPrice"] floatValue];
    model.orderStatus = [Util GetOrderStatus:[[dic objectForKey:@"orderStatus"] integerValue]];
    model.commentStatus = [Util GetCommentStatus:[[dic objectForKey:@"commentStatus"] integerValue]];
    model.payStatus = [Util GetPayStatus:[[dic objectForKey:@"payStatus"] integerValue]];
    model.createdDate = [dic objectForKey:@"createdDate"];
    
    model.loverinfo = (LoverInfoModel*)[LoverInfoModel modelFromDictionary:[dic objectForKey:@"lover"]];
    model.registerInfo = (RegisterInfoModel*)[RegisterInfoModel modelFromDictionary:[dic objectForKey:@"register"]];
    model.productInfo = (ProductInfoModel*)[ProductInfoModel modelFromDictionary:[dic objectForKey:@"product"]];
    
    model.couponsAmount = [[dic objectForKey:@"couponsAmount"] floatValue];
    model.realyTotalPrice = [[dic objectForKey:@"realyTotalPrice"] floatValue];
    model.priceName = [dic objectForKey:@"priceName"];
    
    return model;
}

@end
