//
//  EvaluateInfoModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "EvaluateInfoModel.h"

@implementation EvaluateInfoModel

+ (EvaluateInfoModel *) modelFromDictionary:(NSDictionary *)dic
{
    EvaluateInfoModel *model = [[EvaluateInfoModel alloc] init];
    
    model.content = [dic objectForKey:@"content"];
    
    model.createAt = [dic objectForKey:@"createAt"];
    
    model.commentUserName = [dic objectForKey:@"commentUserName"];
    
    model.score = [[dic objectForKey:@"score"] integerValue];
    
    return model;
}

@end
