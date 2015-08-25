//
//  ProductInfoModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "ProductInfoModel.h"

@implementation ProductInfoModel

+ (ProductInfoModel *) modelFromDictionary:(NSDictionary *) dic
{
    ProductInfoModel *model = [[ProductInfoModel alloc] init];
    model.pId = [dic objectForKey:@"id"];
    model.name = [dic objectForKey:@"name"];
    model.typeName = [dic objectForKey:@"typeName"];
    
    return model;
}

@end
