//
//  UserDetailModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/25.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "OrderInfoModel.h"
#import "LoverInfoModel.h"
#import "RegisterInfoModel.h"
#import "ProductInfoModel.h"

@interface UserDetailModel : NSObject

@property (nonatomic, assign) NSInteger newCount;
@property (nonatomic, assign) NSInteger confirmedCount;
@property (nonatomic, assign) NSInteger waitPayCount;
@property (nonatomic, assign) NSInteger waitCommentCount;

@property (nonatomic, strong) OrderInfoModel *orderModel;

- (void) RequestOrderInfo:(block) block;

@end
