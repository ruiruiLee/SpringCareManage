//
//  UserModel.m
//  SpringCareManage
//
//  Created by LiuZach on 15/4/24.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import "UserModel.h"

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
        if ([AVUser currentUser]!=nil) {
            AVUser *muser = [AVUser currentUser];
            self.userId = muser.objectId;
            self.userName = muser.username;
            self.chineseName = [muser objectForKey:@"chineseName"];
            self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];
            self.locationPoint =[muser objectForKey:@"locationPoint"];
            self.birthDay = [muser objectForKey:@"birthDay"];
            self.birthAddr = [muser objectForKey:@"birthplace"];
            self.userOrderInfo = [[UserDetailModel alloc] init];
            self.sex = [[muser objectForKey:@"sex"] boolValue]?@"男":@"女";
            self.intro = [muser objectForKey:@"intro"];
            self.detailIntro = [muser objectForKey:@"detailIntro"];
            self.beginCareDate = [muser objectForKey:@"beginCareDate"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{[self LoadOrderInfo:nil];
                    });
        }
    }
    return self;
}

-(void)modifyInfo{
    AVUser *muser = [AVUser currentUser];
    self.userId = muser.objectId;
    self.userName = muser.username;
    self.chineseName = [muser objectForKey:@"chineseName"];
    self.headerFile = [(AVFile*)[muser objectForKey:@"headerImage"] url];
    self.locationPoint =[muser objectForKey:@"locationPoint"];
    self.birthDay = [muser objectForKey:@"birthDay"];
    self.birthAddr = [muser objectForKey:@"birthplace"];
    self.userOrderInfo = [[UserDetailModel alloc] init];
    self.sex = [[muser objectForKey:@"sex"] boolValue]?@"男":@"女";
    self.intro = [muser objectForKey:@"intro"];
    self.detailIntro = [muser objectForKey:@"detailIntro"];
    self.beginCareDate = [muser objectForKey:@"beginCareDate"];
    
}
-(NSString*) displayName{
        if (self.chineseName.length==0) {
            return self.mobilePhoneNumber;
        }
        else{
            return self.chineseName;
        }
    }
-(void)modifyLocation:(NSString*)detailAddress{
        self.locationPoint =[[AVUser currentUser] objectForKey:@"locationPoint"];
        if (detailAddress) {
            self.currentDetailAdrress= detailAddress;
        }
    }
- (BOOL) isLogin
{
    if ( [AVUser currentUser]==nil) {
        return false;
    }
    else{
        return true;
    }
}

//- (void) setUserId:(NSString *)userId
//{
//    _userId = userId;
//    if(userId != nil){
//        [self LoadDetailUserInfo:nil];
//        [self LoadOrderInfo:nil];
//    }
//}

//- (void) LoadDetailUserInfo:(block) block
//{
//    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
//    
//    [parmas setObject:self.userId forKey:@"careId"];
//    
//    [LCNetWorkBase postWithMethod:@"api/care/BaseInfo" Params:parmas Completion:^(int code, id content) {
//        if(code){
//            if([content objectForKey:@"code"] == nil){
//                self.birthAddr = [content objectForKey:@"birthPlace"];
//                self.age = [content objectForKey:@"age"];
//                self.careAge = [content objectForKey:@"careAge"];
//                self.intro = [content objectForKey:@"intro"];
//                self.sex = [content objectForKey:@"sex"];
//                self.headerImage = [content objectForKey:@"headerImage"];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:User_DetailInfo_Get object:nil];
//                
//                if(block)
//                    block(1, nil);
//            }
//        }
//        
//        if(block){
//            block(0, nil);
//        }
//    }];
//}

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
