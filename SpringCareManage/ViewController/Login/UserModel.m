//
//  UserModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudSNS/AVOSCloudSNS.h>

@implementation UserModel

+ (UserModel *) sharedUserInfo
{
    static dispatch_once_t onceToken;
    static UserModel *user = nil;
    dispatch_once(&onceToken, ^{
        user = [[UserModel alloc] init];
    });
    return user;
}

- (id)init
{
    if (self = [super init]) {
        if ( ![[AVUser currentUser]isEqual: nil]) {
            AVUser *user = [AVUser currentUser];
            self.userId = user.objectId;
            self.userName = user.username;
            self.phone = user.mobilePhoneNumber;
            self.chineseName = [user objectForKey:@"chinese_name"];
            self.isNew = user.isNew;
        }
        
        self.age = @"";
        self.careAge = @"";
        self.birthAddr = @" ";
        
        self.userOrderInfo = [[UserDetailModel alloc] init];
    }
    
    return self;
}

- (BOOL) isLogin
{
    if ( [AVUser currentUser]==nil) {
        return false;
    }
    else{
        AVUser *user = [AVUser currentUser];
        self.userId = user.objectId;
        self.userName = user.username;
        self.phone = user.mobilePhoneNumber;
        self.chineseName = [user objectForKey:@"chinese_name"];
        self.isNew = user.isNew;
        
        self.age = @"";
        self.careAge = @"";
        self.birthAddr = @" ";
        return true;
    }
}

- (void) setUserId:(NSString *)userId
{
    _userId = userId;
    if(userId != nil){
        [self LoadDetailUserInfo:nil];
        [self LoadOrderInfo:nil];
    }
}

- (void) LoadDetailUserInfo:(block) block
{
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    
    [parmas setObject:self.userId forKey:@"careId"];
    
    [LCNetWorkBase postWithMethod:@"api/care/BaseInfo" Params:parmas Completion:^(int code, id content) {
        if(code){
            if([content objectForKey:@"code"] == nil){
                self.birthAddr = [content objectForKey:@"birthPlace"];
                self.age = [content objectForKey:@"age"];
                self.careAge = [content objectForKey:@"careAge"];
                self.intro = [content objectForKey:@"intro"];
                self.sex = [content objectForKey:@"sex"];
                self.headerImage = [content objectForKey:@"headerImage"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:User_DetailInfo_Get object:nil];
                
                if(block)
                    block(1, nil);
            }
        }
        
        if(block){
            block(0, nil);
        }
    }];
}

- (void) LoadOrderInfo:(block) block
{
    [self.userOrderInfo RequestOrderInfo:^(int code, id content) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:User_DetailInfo_Get object:nil];
        
        if(block){
            block(code, content);
        }
    }];
}

@end
