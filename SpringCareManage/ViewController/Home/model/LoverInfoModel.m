//
//  LoverInfoModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "LoverInfoModel.h"
#import "define.h"

@implementation LoverInfoModel

+ (LoverInfoModel *) modelFromDictionary:(NSDictionary *)dic
{
    LoverInfoModel *model = [[LoverInfoModel alloc] init];
    
    model.loverId = [dic objectForKey:@"id"];
    model.name = [dic objectForKey:@"name"];
    model.headerImage = [dic objectForKey:@"headerImage"];
    model.phone = [dic objectForKey:@"phone"];
    model.nickname = [dic objectForKey:@"nickname"];
    model.sex = [dic objectForKey:@"sex"];
    model.addr = [dic objectForKey:@"addr"];
    model.age = [Util GetAgeByBirthday:[dic objectForKey:@"birthDay"]];
    
    model.registerName = [dic objectForKey:@"registerName"];
    model.registerPhone = [dic objectForKey:@"registerPhone"];
    
    if([[dic objectForKey:@"height"] isKindOfClass:[NSNull class]])
        model.height = 0;
    else
        model.height = [NSString stringWithFormat:@"%d", [[dic objectForKey:@"height"] integerValue]];
    model.relationId = [dic objectForKey:@"relationId"];
    
    return model;
}

@end
