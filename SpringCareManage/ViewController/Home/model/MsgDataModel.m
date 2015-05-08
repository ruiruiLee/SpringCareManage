//
//  MsgDataModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/5/8.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "MsgDataModel.h"

@implementation MsgDataModel

+ (MsgDataModel *) modelFromDictionary:(NSDictionary *) dic
{
    MsgDataModel *model = [[MsgDataModel alloc] init];
    
    model.msgId = [dic objectForKey:@"id"];
    model.newsTitle = [dic objectForKey:@"newsTitle"];
    model.createdAt = [dic objectForKey:@"createdAt"];
    
    return model;
}


@end
