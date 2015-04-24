//
//  RegisterInfoModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseModel.h"

@interface RegisterInfoModel : BaseModel

@property (nonatomic, strong) NSString *registerId;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *chineseName;

@end
