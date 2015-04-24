//
//  LoverInfoModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "BaseModel.h"

@interface LoverInfoModel : BaseModel

@property (nonatomic, strong) NSString *loverId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *addr;
@property (nonatomic, strong) NSString *age;

@end
