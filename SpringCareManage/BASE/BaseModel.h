//
//  BaseModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

+ (BaseModel *) modelFromDictionary:(NSDictionary *)dic;

@end
