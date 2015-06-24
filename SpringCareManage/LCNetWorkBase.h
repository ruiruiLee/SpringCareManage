//
//  LCNetWorkBase.h
//  SpringCare
//
//  Created by LiuZach on 15/3/23.
//  Copyright (c) 2015年 cmkj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Completion) (int code, id content);
/*
 正式
 */
//#define SERVER_ADDRESS @"http://spring.avosapps.com/"
/*
 测试
 */
#define SERVER_ADDRESS @"http://dev.springcare.avosapps.com/"

@interface LCNetWorkBase : NSObject

+ (id)sharedLCNetWorkBase;

- (void)requestWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion;

- (void)postWithMethod:(NSString *)method Params:(NSDictionary *)params Completion:(Completion)completion;

- (void)postWithParams:(NSString*)params Url:(NSString*)url Completion:(Completion)completion;

- (void)GetWithParams:(NSDictionary *)params Url:(NSString*)url Completion:(Completion)completion;

@end
