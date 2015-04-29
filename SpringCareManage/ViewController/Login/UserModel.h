//
//  UserModel.h
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "define.h"
#import "UserDetailModel.h"
 #import <AVOSCloud/AVOSCloud.h>
@interface UserModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *birthAddr;
@property (nonatomic, strong) NSDate *birthDay;
@property (nonatomic, strong) NSDate *beginCareDate;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *chineseName;
@property (nonatomic, strong) NSString *headerImage;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) UserDetailModel *userOrderInfo;
@property (nonatomic, strong) NSString *headerFile;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) AVGeoPoint *locationPoint;
@property (nonatomic, strong) NSString *mobilePhoneNumber;
@property (nonatomic, strong) NSString *currentDetailAdrress;
@property (nonatomic, strong) NSString *detailIntro;
//detail
+ (UserModel *) sharedUserInfo;

//- (void) LoadDetailUserInfo:(block) block;
-(void)modifyInfo;
-(void)modifyLocation:(NSString*)detailAddress;
- (BOOL) isLogin;

//获取订单信息
- (void) LoadOrderInfo:(block) block;

@end
