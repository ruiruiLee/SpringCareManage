//
//  BaseModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dic
{
    BaseModel *model = [[BaseModel alloc] init];
    
    return model;
}

@end
