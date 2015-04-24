//
//  UserModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"

@interface UserModel : NSObject

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *birthAddr;
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *careAge;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *chineseName;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *sex;

//detail
+ (UserModel *) sharedUserInfo;

- (void) LoadDetailUserInfo:(block) block;

- (BOOL) isLogin;

@end
