//
//  OrderInfoModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseModel.h"
#import "define.h"

#import "LoverInfoModel.h"
#import "RegisterInfoModel.h"
#import "ProductInfoModel.h"

@interface OrderInfoModel : BaseModel

@property (nonatomic, strong) NSString *orderId;//id
@property (nonatomic, strong) NSString *serialNumber;//订单号
@property (nonatomic, strong) NSString *beginDate;//订单开始日期
@property (nonatomic, strong) NSString *endDate;//订单结束日期;
@property (nonatomic, assign) DateType dateType;//
@property (nonatomic, assign) NSInteger orderCount;
//@property (nonatomic, assign) CGFloat orgUnitPrice;
@property (nonatomic, assign) CGFloat unitPrice;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) NSInteger commentStatus;
@property (nonatomic, assign) PayStatus payStatus;
@property (nonatomic, strong) NSString *createdDate;
@property (nonatomic, strong) LoverInfoModel *loverinfo;
@property (nonatomic, strong) RegisterInfoModel *registerInfo;
@property (nonatomic, strong) ProductInfoModel *productInfo;
@property (nonatomic, assign) CGFloat  realyTotalPrice;
@property (nonatomic, assign) CGFloat  couponsAmount;

@property (nonatomic, strong) NSString *priceName;

@end
