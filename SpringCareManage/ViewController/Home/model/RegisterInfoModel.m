//
//  RegisterInfoModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "RegisterInfoModel.h"

@implementation RegisterInfoModel

+ (RegisterInfoModel *) modelFromDictionary:(NSDictionary *)dic
{
    RegisterInfoModel *model = [[RegisterInfoModel alloc] init];
    
    model.registerId = [dic objectForKey:@"id"];
    model.phone = [dic objectForKey:@"phone"];
    model.chineseName = [dic objectForKey:@"chineseName"];
    
    return model;
}

@end
